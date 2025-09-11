import QtQuick
import Quickshell.Io

Rectangle {
    id: networkWidget
    height: 40
    color: "transparent"
    radius: 8

    signal clicked()

    property bool isConnected: false
    property bool isWifi: false
    property int wifiStrength: 0
    property string connectionName: ""
    property string ipv4Address: ""
    property string ssidName: ""
    property string connectionType: ""
    property list<var> networkStats: []
    
    // Configurable parameters
    property int maxNetworkStats: 20
    property int networkCheckInterval: 5000
    property int statsCheckInterval: 2000
    property int defaultWifiStrength: 75

    Colors {
        id: colors
    }


    Component.onCompleted: {
        networkProcess.running = true
    }

    property string networkIcon: {
        if (!isConnected) return "󰌙"

        if (isWifi) {
            if (wifiStrength >= 80) return "󰤨"
            else if (wifiStrength >= 60) return "󰤥"
            else if (wifiStrength >= 40) return "󰤢"
            else if (wifiStrength >= 20) return "󰤟"
            else return "󰤯"
        } else {
            return "󰈀"
        }

        return "󰌙"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            clickProcess.running = true
        }
        hoverEnabled: true

        onEntered: {
            parent.color = colors.surface
            if (networkWidget.isConnected) {
                var tooltipWidth = 250
                var tooltipHeight = 180
                var widgetCenter = networkWidget.mapToGlobal(networkWidget.width/2, networkWidget.height/2)
                var widgetLeftEdge = networkWidget.mapToGlobal(0, networkWidget.height/2)

                var tooltipX = widgetLeftEdge.x - tooltipWidth
                var tooltipY = widgetCenter.y - tooltipHeight/2

                tooltip.showAt(tooltipX, tooltipY, generateTooltipText(), "right", tooltipWidth, tooltipHeight/2)
            }
        }

        onExited: {
            parent.color = "transparent"
            tooltip.hide()
        }
    }

    Text {
        text: networkWidget.networkIcon
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: colors.iconSize
        color: colors.text
        anchors.centerIn: parent
    }

    // Network status check process
    Process {
        id: networkProcess
        command: ["nmcli", "-t", "-f", "STATE,TYPE,DEVICE", "connection", "show", "--active"]
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const line = data.trim()
                        const parts = line.split(":")
                        if (parts.length >= 3 && parts[0] === "activated") {
                            const connType = parts[1]
                            const deviceName = parts[2]

                            // Check if it's ethernet or wifi
                            if (connType.includes("wifi") || connType.includes("wireless")) {
                                networkWidget.isConnected = true
                                networkWidget.isWifi = true
                                networkWidget.connectionName = "WiFi"
                                networkWidget.connectionType = "Wi-Fi"
                                networkWidget.wifiStrength = networkWidget.defaultWifiStrength
                                // Get detailed info for wifi
                                detailedInfoProcess.running = true
                            } else if (connType.includes("ethernet") || connType.includes("802-3")) {
                                networkWidget.isConnected = true
                                networkWidget.isWifi = false
                                networkWidget.connectionName = "Ethernet"
                                networkWidget.connectionType = "Ethernet"
                                // Get detailed info for ethernet
                                detailedInfoProcess.running = true
                            }
                        }
                    }
                } catch (e) {
                }
            }
        }
    }

    Timer {
        interval: networkWidget.networkCheckInterval
        running: true
        repeat: true
        onTriggered: {
            networkProcess.running = true
        }
    }

    // Detailed network info process
    Process {
        id: detailedInfoProcess
        command: ["bash", "-c", "nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -1"]
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const line = data.trim()
                        const parts = line.split(":")
                        if (parts.length >= 3) {
                            networkWidget.connectionName = parts[0] || "Unknown"
                            const deviceName = parts[2]
                            // Get IP address for this device
                            ipAddressProcess.command = ["ip", "addr", "show", deviceName]
                            ipAddressProcess.running = true
                            
                            // Get SSID if wifi
                            if (networkWidget.isWifi && deviceName) {
                                ssidProcess.command = ["iwgetid", deviceName, "-r"]
                                ssidProcess.running = true
                            }
                        }
                    }
                } catch (e) {
                }
            }
        }
    }

    // IP address process
    Process {
        id: ipAddressProcess
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.includes("inet ")) {
                        const lines = data.split("\n")
                        for (const line of lines) {
                            if (line.includes("inet ") && !line.includes("127.0.0.1")) {
                                const match = line.match(/inet\s+(\d+\.\d+\.\d+\.\d+)/)
                                if (match) {
                                    networkWidget.ipv4Address = match[1]
                                    break
                                }
                            }
                        }
                    }
                } catch (e) {
                }
            }
        }
    }

    // SSID process for WiFi
    Process {
        id: ssidProcess
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        networkWidget.ssidName = data.trim()
                    }
                } catch (e) {
                }
            }
        }
    }

    // Network statistics collector
    Process {
        id: networkStatsProcess
        command: ["cat", "/proc/net/dev"]
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.includes(":")) {
                        const lines = data.split("\n")
                        let totalRx = 0
                        let totalTx = 0
                        
                        for (let line of lines) {
                            if (line.includes(":") && !line.includes("lo:")) {
                                const parts = line.trim().split(/\s+/)
                                if (parts.length >= 10) {
                                    totalRx += parseInt(parts[1]) || 0
                                    totalTx += parseInt(parts[9]) || 0
                                }
                            }
                        }
                        
                        // Add to stats history
                        const timestamp = Date.now()
                        networkWidget.networkStats.push({rx: totalRx, tx: totalTx, time: timestamp})
                        
                        // Keep only last N entries
                        if (networkWidget.networkStats.length > networkWidget.maxNetworkStats) {
                            networkWidget.networkStats.shift()
                        }
                    }
                } catch (e) {
                }
            }
        }
    }

    // Stats collection timer
    Timer {
        interval: networkWidget.statsCheckInterval
        running: true
        repeat: true
        onTriggered: {
            networkStatsProcess.running = true
        }
    }

    // Click handler process
    Process {
        id: clickProcess
        command: ["nmgui"]
    }

    // Tooltip
    SimpleTooltip {
        id: tooltip
        backgroundColor: colors.surface
        borderColor: colors.overlay
        textColor: colors.text
    }

    function generateTooltipText() {
        let text = `<b>Network Status</b><br/>`
        text += `<b>Type:</b> ${networkWidget.connectionType}<br/>`
        text += `<b>Connection:</b> ${networkWidget.connectionName}<br/>`
        
        if (networkWidget.isWifi && networkWidget.ssidName) {
            text += `<b>SSID:</b> ${networkWidget.ssidName}<br/>`
            text += `<b>Signal:</b> ${networkWidget.wifiStrength}%<br/>`
        }
        
        text += `<b>IPv4:</b> ${networkWidget.ipv4Address}<br/><br/>`
        
        // Simple network activity indicator
        if (networkWidget.networkStats.length > 1) {
            const latest = networkWidget.networkStats[networkWidget.networkStats.length - 1]
            const previous = networkWidget.networkStats[networkWidget.networkStats.length - 2]
            const rxRate = (latest.rx - previous.rx) / 1024 // KB/s
            const txRate = (latest.tx - previous.tx) / 1024 // KB/s
            
            text += `<b>Network Activity:</b><br/>`
            text += `↓ ${rxRate.toFixed(1)} KB/s<br/>`
            text += `↑ ${txRate.toFixed(1)} KB/s`
        }
        
        return text
    }
}
