import QtQuick
import Quickshell.Io

Column {
    id: networkSection

    property string connectionName: ""
    property string connectionType: ""
    property bool isConnected: false
    property bool isWifi: false
    property int wifiStrength: 0
    property string ssidName: ""

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

    spacing: 0

    Component.onCompleted: {
        networkProcess.running = true
    }

    Colors {
        id: colors
    }

    // Network status check
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

        command: ["/bin/bash", "-c", "nmcli -f IN-USE,SIGNAL,SSID dev wifi | grep '^\\*' | awk '{print $2,$3}'"]
        running: false

        stdout: SplitParser {
            onRead: function (data) {
                const output = data.trim().split(' ')
                if (output.length >= 2) {
                    const strength = parseInt(output[0])
                    if (!isNaN(strength)) {
                        wifiStrength = strength
                    }
                    ssidName = output.slice(1).join(' ')
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

    Process {
        id: settingsProcess

        command: ["/bin/bash", "-c", "nm-connection-editor &"]
        running: false
    }

    // Action button style
    Rectangle {
        width: parent.width
        height: 64
        radius: 12
        color: networkMouseArea.containsMouse ? colors.surface : colors.mantle

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // Network icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: isConnected ? colors.text : colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                text: networkIcon
            }

            // Connection info
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.bold: true
                    text: isConnected ? (isWifi && ssidName ? ssidName : connectionName) : "Not Connected"
                }

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: {
                        if (!isConnected) return "Disconnected"
                        if (isWifi) return wifiStrength + "%"
                        return "Wired"
                    }
                }
            }

            Item {
                width: parent.width - 200
                height: 1
            }

            // Chevron
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: "󰅂"
            }
        }

        MouseArea {
            id: networkMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                settingsProcess.running = true
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}
