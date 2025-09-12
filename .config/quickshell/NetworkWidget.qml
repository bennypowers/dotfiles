import QtQuick
import Quickshell.Io

Rectangle {
    id: networkWidget

    // Property to receive shell root reference
    property var shellRoot: null

    property string connectionName: ""
    property string connectionType: ""
    property int defaultWifiStrength: 75
    property string ipv4Address: ""
    property bool isConnected: false
    property bool isWifi: false

    // Configurable parameters
    property int maxNetworkStats: 20
    property int networkCheckInterval: 5000
    property string networkIcon: {
        if (!isConnected)
            return "󰌙";

        if (isWifi) {
            if (wifiStrength >= 80)
                return "󰤨";
            else if (wifiStrength >= 60)
                return "󰤥";
            else if (wifiStrength >= 40)
                return "󰤢";
            else if (wifiStrength >= 20)
                return "󰤟";
            else
                return "󰤯";
        } else {
            return "󰈀";
        }

        return "󰌙";
    }
    property list<var> networkStats: []
    property string ssidName: ""
    property int statsCheckInterval: 2000
    property int wifiStrength: 0

    signal clicked

    function generateTooltipText() {
        let text = `<b>Network Status</b><br/>`;
        text += `<b>Type:</b> ${networkWidget.connectionType}<br/>`;
        text += `<b>Connection:</b> ${networkWidget.connectionName}<br/>`;

        if (networkWidget.isWifi && networkWidget.ssidName) {
            text += `<b>SSID:</b> ${networkWidget.ssidName}<br/>`;
            text += `<b>Signal:</b> ${networkWidget.wifiStrength}%<br/>`;
        }

        text += `<b>IPv4:</b> ${networkWidget.ipv4Address}<br/><br/>`;

        // Simple network activity indicator
        if (networkWidget.networkStats.length > 1) {
            const latest = networkWidget.networkStats[networkWidget.networkStats.length - 1];
            const previous = networkWidget.networkStats[networkWidget.networkStats.length - 2];
            const rxRate = (latest.rx - previous.rx) / 1024; // KB/s
            const txRate = (latest.tx - previous.tx) / 1024; // KB/s

            text += `<b>Network Activity:</b><br/>`;
            text += `↓ ${rxRate.toFixed(1)} KB/s<br/>`;
            text += `↑ ${txRate.toFixed(1)} KB/s`;
        }

        return text;
    }

    color: "transparent"
    height: 40
    radius: 8

    Component.onCompleted: {
        networkProcess.running = true;
    }

    Tooltip {
        id: tooltip

    }
    Colors {
        id: colors

    }
    MouseArea {
        id: mouseArea

        property bool hovered: false

        function showTooltip() {
            tooltip.showForWidget(mouseArea, generateTooltipText());
        }

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            clickProcess.running = true;
        }
        onEntered: {
            console.log("🟢 NetworkWidget MouseArea entered");
            hovered = true;
            parent.color = colors.surface;
            if (networkWidget.isConnected) {
                showTooltip();
            }
        }
        onExited: {
            console.log("🔴 NetworkWidget MouseArea exited");
            hovered = false;
            parent.color = "transparent";
            tooltip.hide();
        }
    }
    Text {
        anchors.centerIn: parent
        color: colors.text
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: colors.iconSize
        text: networkWidget.networkIcon
    }

    // Network status check process
    Process {
        id: networkProcess

        command: ["nmcli", "-t", "-f", "STATE,TYPE,DEVICE", "connection", "show", "--active"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        var line = data.trim();
                        var parts = line.split(":");
                        if (parts.length >= 3 && parts[0] === "activated") {
                            var connType = parts[1];
                            var deviceName = parts[2];

                            // Check if it's ethernet or wifi
                            if (connType.includes("wifi") || connType.includes("wireless")) {
                                networkWidget.isConnected = true;
                                networkWidget.isWifi = true;
                                networkWidget.connectionName = "WiFi";
                                networkWidget.connectionType = "Wi-Fi";
                                networkWidget.wifiStrength = networkWidget.defaultWifiStrength;
                                // Get detailed info for wifi
                                detailedInfoProcess.running = true;
                            } else if (connType.includes("ethernet") || connType.includes("802-3")) {
                                networkWidget.isConnected = true;
                                networkWidget.isWifi = false;
                                networkWidget.connectionName = "Ethernet";
                                networkWidget.connectionType = "Ethernet";
                                // Get detailed info for ethernet
                                detailedInfoProcess.running = true;
                            }
                        }
                    }
                } catch (e) {}
            }
        }
    }
    Timer {
        interval: networkWidget.networkCheckInterval
        repeat: true
        running: true

        onTriggered: {
            networkProcess.running = true;
        }
    }

    // Detailed network info process
    Process {
        id: detailedInfoProcess

        command: ["bash", "-c", "nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -1"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const line = data.trim();
                        const parts = line.split(":");
                        if (parts.length >= 3) {
                            networkWidget.connectionName = parts[0] || "Unknown";
                            const deviceName = parts[2];
                            // Get IP address for this device
                            ipAddressProcess.command = ["ip", "addr", "show", deviceName];
                            ipAddressProcess.running = true;

                            // Get SSID if wifi
                            if (networkWidget.isWifi && deviceName) {
                                ssidProcess.command = ["iwgetid", deviceName, "-r"];
                                ssidProcess.running = true;
                            }
                        }
                    }
                } catch (e) {}
            }
        }
    }

    // IP address process
    Process {
        id: ipAddressProcess

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.includes("inet ")) {
                        const lines = data.split("\n");
                        for (const line of lines) {
                            if (line.includes("inet ") && !line.includes("127.0.0.1")) {
                                const match = line.match(/inet\s+(\d+\.\d+\.\d+\.\d+)/);
                                if (match) {
                                    networkWidget.ipv4Address = match[1];
                                    break;
                                }
                            }
                        }
                    }
                } catch (e) {}
            }
        }
    }

    // SSID process for WiFi
    Process {
        id: ssidProcess

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        networkWidget.ssidName = data.trim();
                    }
                } catch (e) {}
            }
        }
    }

    // Network statistics collector
    Process {
        id: networkStatsProcess

        command: ["cat", "/proc/net/dev"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.includes(":")) {
                        const lines = data.split("\n");
                        let totalRx = 0;
                        let totalTx = 0;

                        for (let line of lines) {
                            if (line.includes(":") && !line.includes("lo:")) {
                                const parts = line.trim().split(/\s+/);
                                if (parts.length >= 10) {
                                    totalRx += parseInt(parts[1]) || 0;
                                    totalTx += parseInt(parts[9]) || 0;
                                }
                            }
                        }

                        // Add to stats history
                        const timestamp = Date.now();
                        networkWidget.networkStats.push({
                            rx: totalRx,
                            tx: totalTx,
                            time: timestamp
                        });

                        // Keep only last N entries
                        if (networkWidget.networkStats.length > networkWidget.maxNetworkStats) {
                            networkWidget.networkStats.shift();
                        }
                    }
                } catch (e) {}
            }
        }
    }

    // Stats collection timer
    Timer {
        interval: networkWidget.statsCheckInterval
        repeat: true
        running: true

        onTriggered: {
            networkStatsProcess.running = true;
        }
    }

    // Click handler process
    Process {
        id: clickProcess

        command: ["nmgui"]
    }
}
