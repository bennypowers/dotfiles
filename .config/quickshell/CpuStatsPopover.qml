import QtQuick

BasePopover {
    id: popover

    property int rightPanelWidth: 80
    property int screenWidth: 0
    property int sectionSpacing: 12

    // Stats properties
    property real cpuUsage: 0
    property list<real> coreUsages: []
    property real cpuTemp: 0
    property real cpuPower: 0
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
    property real gpuUsage: 0
    property real gpuVramTotal: 0
    property real gpuVramUsed: 0
    property real gpuTemp: 0
    property real gpuPower: 0
    property var gpuUsageHistory: []
    property var gpuVramHistory: []
    property var gpuTempHistory: []
    property var gpuPowerHistory: []

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

        // CPU Details (Temperature & Power)
        Row {
            spacing: 24
            width: parent.width

            // Temperature
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "CPU TEMP"
                }

                Row {
                    spacing: 4

                    Text {
                        property string tempColor: {
                            if (popover.cpuTemp < 50)
                                return colors.green;
                            else if (popover.cpuTemp < 70)
                                return colors.yellow;
                            else if (popover.cpuTemp < 85)
                                return colors.peach;
                            else
                                return colors.red;
                        }

                        color: tempColor
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                        text: `${Math.round(popover.cpuTemp)}°C`
                    }
                }
            }

            // Power
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "CPU POWER"
                }

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 20
                    text: popover.cpuPower > 0 ? `${Math.round(popover.cpuPower)} W` : "N/A"
                }
            }
        }

        // GPU Section (Usage & VRAM)
        Row {
            spacing: 24
            width: parent.width

            // GPU Usage
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "GPU"
                }

                Text {
                    color: colors.text
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 32
                    text: `${Math.round(popover.gpuUsage)}%`
                }
            }

            // GPU VRAM
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "VRAM"
                }

                Row {
                    spacing: 12

                    Text {
                        property real vramUsagePercent: popover.gpuVramTotal > 0 ? (popover.gpuVramUsed / popover.gpuVramTotal) * 100 : 0

                        color: colors.text
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 32
                        text: `${Math.round(vramUsagePercent)}%`
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: `${popover.gpuVramUsed.toFixed(1)} / ${popover.gpuVramTotal.toFixed(1)} GB`
                    }
                }
            }
        }

        // GPU Details (Temperature & Power)
        Row {
            spacing: 24
            width: parent.width

            // Temperature
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "GPU TEMP"
                }

                Row {
                    spacing: 4

                    Text {
                        property string tempColor: {
                            if (popover.gpuTemp < 60)
                                return colors.green;
                            else if (popover.gpuTemp < 75)
                                return colors.yellow;
                            else if (popover.gpuTemp < 85)
                                return colors.peach;
                            else
                                return colors.red;
                        }

                        color: tempColor
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                        text: `${Math.round(popover.gpuTemp)}°C`
                    }
                }
            }

            // Power
            Column {
                spacing: 4
                width: (parent.width - parent.spacing) / 2

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "GPU POWER"
                }

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 20
                    text: `${Math.round(popover.gpuPower)} W`
                }
            }
        }

        // GPU Graphs Section
        Column {
            spacing: 8
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                text: "GPU Metrics"
            }

            // Usage and VRAM graphs (side by side)
            Row {
                spacing: 12
                width: parent.width

                // GPU Usage Graph
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: "Usage %"
                    }

                    GpuGraph {
                        dataPoints: popover.gpuUsageHistory
                        fillColor: colors.blue
                        height: 60
                        lineColor: colors.blue
                        maxValue: 100
                        minValue: 0
                        width: parent.width
                    }
                }

                // VRAM Graph
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: "VRAM %"
                    }

                    GpuGraph {
                        dataPoints: popover.gpuVramHistory
                        fillColor: colors.sapphire
                        height: 60
                        lineColor: colors.sapphire
                        maxValue: 100
                        minValue: 0
                        width: parent.width
                    }
                }
            }

            // Temperature and Power graphs (side by side)
            Row {
                spacing: 12
                width: parent.width

                // Temperature Graph
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: "Temp °C"
                    }

                    GpuGraph {
                        property real maxTemp: {
                            if (popover.gpuTempHistory.length === 0)
                                return 100;
                            var max = Math.max(...popover.gpuTempHistory);
                            return Math.max(max * 1.1, 60);
                        }

                        dataPoints: popover.gpuTempHistory
                        fillColor: colors.peach
                        height: 60
                        lineColor: colors.peach
                        maxValue: maxTemp
                        minValue: 0
                        width: parent.width
                    }
                }

                // Power Graph
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: "Power W"
                    }

                    GpuGraph {
                        property real maxPower: {
                            if (popover.gpuPowerHistory.length === 0)
                                return 300;
                            var max = Math.max(...popover.gpuPowerHistory);
                            return Math.max(max * 1.1, 100);
                        }

                        dataPoints: popover.gpuPowerHistory
                        fillColor: colors.yellow
                        height: 60
                        lineColor: colors.yellow
                        maxValue: maxPower
                        minValue: 0
                        width: parent.width
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
