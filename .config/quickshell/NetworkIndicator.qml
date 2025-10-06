import QtQuick
import Quickshell.Io

Item {
    id: networkIndicator

    property string connectionName: ""
    property string connectionType: ""
    property bool isConnected: false
    property bool isWifi: false
    property int wifiStrength: 0
    property bool shouldDisplay: true  // Network indicator always shown

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

    Component.onCompleted: {
        networkProcess.running = true
    }

    // Network status check process
    Process {
        id: networkProcess

        command: ["/bin/bash", "-c", "nmcli -t -f NAME,TYPE,DEVICE,STATE connection show --active"]
        running: false

        stdout: SplitParser {
            onRead: function (data) {
                const lines = data.trim().split('\n')
                if (lines.length > 0 && lines[0]) {
                    const parts = lines[0].split(':')
                    if (parts.length >= 4) {
                        connectionName = parts[0]
                        connectionType = parts[1]
                        isConnected = parts[3] === 'activated'
                        isWifi = connectionType.includes('wireless') || connectionType.includes('wifi')

                        if (isWifi) {
                            wifiCheckProcess.running = true
                        }
                    }
                }
            }
        }

        onExited: function (exitCode) {
            networkCheckTimer.start()
        }
    }

    // Wifi strength check
    Process {
        id: wifiCheckProcess

        command: ["/bin/bash", "-c", "nmcli -f IN-USE,SIGNAL dev wifi | grep '^\\*' | awk '{print $2}'"]
        running: false

        stdout: SplitParser {
            onRead: function (data) {
                const strength = parseInt(data.trim())
                if (!isNaN(strength)) {
                    wifiStrength = strength
                }
            }
        }
    }

    Timer {
        id: networkCheckTimer

        interval: 5000
        repeat: false

        onTriggered: {
            networkProcess.running = true
        }
    }
}
