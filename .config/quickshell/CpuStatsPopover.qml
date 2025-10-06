import QtQuick

BasePopover {
    id: popover

    property int rightPanelWidth: 80
    property int screenWidth: 0
    property int sectionSpacing: 12

    // Stats properties
    property real cpuUsage: 0
    property list<real> coreUsages: []
    property real ramUsage: 0
    property real ramTotal: 0
    property real ramUsed: 0
    property string uptime: ""
    property real diskUsage: 0
    property real diskTotal: 0
    property real diskUsed: 0
    property real diskRead: 0
    property real diskWrite: 0
    property real networkDown: 0
    property real networkUp: 0

    anchorSide: "right"
    cornerPositions: ["topLeft", "bottomRight"]
    namespace: "quickshell-cpu-stats"

    Column {
        id: contentColumn

        spacing: sectionSpacing
        width: parent.width

        // Header
        Text {
            color: colors.text
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            text: "System Stats"
        }

        // Overall CPU & RAM Usage (side by side)
        Row {
            spacing: 24
            width: parent.width

            // CPU
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "CPU"
                }

                Text {
                    color: colors.text
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 32
                    text: `${Math.round(popover.cpuUsage)}%`
                }
            }

            // RAM
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "MEMORY"
                }

                Row {
                    spacing: 12

                    Text {
                        color: colors.text
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 32
                        text: `${Math.round(popover.ramUsage)}%`
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: `${(popover.ramUsed / 1024).toFixed(1)} / ${(popover.ramTotal / 1024).toFixed(1)} GB`
                    }
                }
            }
        }

        // Per-core usage
        Column {
            spacing: 4
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                text: "Per-Core Usage"
            }

            Grid {
                columns: 4
                columnSpacing: 12
                rowSpacing: 8

                Repeater {
                    model: popover.coreUsages.length

                    delegate: Row {
                        required property int index

                        spacing: 4

                        Text {
                            color: colors.overlay
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            text: `${index}:`
                            width: 20
                        }

                        Text {
                            property real usage: index < popover.coreUsages.length ? popover.coreUsages[index] : 0
                            property string usageColor: {
                                if (usage < 25)
                                    return colors.green;
                                else if (usage < 50)
                                    return colors.yellow;
                                else if (usage < 75)
                                    return colors.peach;
                                else
                                    return colors.red;
                            }

                            color: usageColor
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            text: `${Math.round(usage)}%`
                            width: 35
                        }
                    }
                }
            }
        }

        // Disk Usage & I/O
        Row {
            spacing: 24
            width: parent.width

            // Disk Usage
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "DISK (ROOT)"
                }

                Row {
                    spacing: 8

                    Text {
                        color: colors.text
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                        text: `${Math.round(popover.diskUsage)}%`
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: `${(popover.diskUsed).toFixed(0)} / ${(popover.diskTotal).toFixed(0)} GB`
                    }
                }
            }

            // Disk I/O
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "DISK I/O"
                }

                Row {
                    spacing: 16

                    Row {
                        spacing: 4

                        Text {
                            color: colors.blue
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: "R"
                        }

                        Text {
                            color: colors.text
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: `${popover.diskRead.toFixed(1)} MB/s`
                        }
                    }

                    Row {
                        spacing: 4

                        Text {
                            color: colors.peach
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: "W"
                        }

                        Text {
                            color: colors.text
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: `${popover.diskWrite.toFixed(1)} MB/s`
                        }
                    }
                }
            }
        }

        // Network & Uptime (side by side)
        Row {
            spacing: 24
            width: parent.width

            // Network
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "NETWORK"
                }

                Row {
                    spacing: 16

                    Row {
                        spacing: 4

                        Text {
                            color: colors.green
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: "↓"
                        }

                        Text {
                            color: colors.text
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: `${popover.networkDown.toFixed(1)} MB/s`
                        }
                    }

                    Row {
                        spacing: 4

                        Text {
                            color: colors.red
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: "↑"
                        }

                        Text {
                            color: colors.text
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: `${popover.networkUp.toFixed(1)} MB/s`
                        }
                    }
                }
            }

            // Uptime
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "UPTIME"
                }

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    text: popover.uptime
                }
            }
        }
    }
}
