import QtQuick

NodeTooltip {
    id: tooltipWindow

    property real overallUsage: 0
    property list<real> coreUsages: []
    property QtObject colors: null

    readonly property int barWidth: 20
    readonly property int barSpacing: 4
    readonly property int maxBarHeight: 140

    Column {
        id: tooltipContent
        parent: contentContainer
        anchors.centerIn: parent
        spacing: 12
        
        width: Math.max(250, tooltipWindow.coreUsages.length * (tooltipWindow.barWidth + tooltipWindow.barSpacing) + 40)
        height: tooltipWindow.maxBarHeight + 80

        // Overall CPU usage header
        Text {
            text: "CPU: " + Math.round(tooltipWindow.overallUsage) + "%"
            font.family: tooltipWindow.fontFamily
            font.pixelSize: tooltipWindow.fontSize + 2
            font.bold: true
            color: tooltipWindow.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // EQ Visualizer bars
        Item {
            width: Math.max(200, tooltipWindow.coreUsages.length * (tooltipWindow.barWidth + tooltipWindow.barSpacing) - tooltipWindow.barSpacing)
            height: tooltipWindow.maxBarHeight + 20
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                anchors.centerIn: parent
                spacing: tooltipWindow.barSpacing

                Repeater {
                    model: tooltipWindow.coreUsages.length

                    Item {
                        width: tooltipWindow.barWidth
                        height: tooltipWindow.maxBarHeight + 20

                        property real coreUsage: index < tooltipWindow.coreUsages.length ? tooltipWindow.coreUsages[index] : 0
                        property string coreColor: {
                            if (!tooltipWindow.colors) return "#ffffff"
                            if (coreUsage < 25) return tooltipWindow.colors.green
                            else if (coreUsage < 50) return tooltipWindow.colors.yellow
                            else if (coreUsage < 75) return tooltipWindow.colors.peach
                            else return tooltipWindow.colors.red
                        }

                        // Background bar (representing 0-100% scale)
                        Rectangle {
                            id: backgroundBar
                            width: tooltipWindow.barWidth
                            height: tooltipWindow.maxBarHeight
                            anchors.bottom: coreLabel.top
                            anchors.bottomMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "transparent"
                            border.color: tooltipWindow.borderColor
                            border.width: 1
                            radius: 2
                            opacity: 0.3
                        }

                        // Active usage bar (scales upward)
                        Rectangle {
                            width: tooltipWindow.barWidth - 2
                            height: Math.max(2, (tooltipWindow.maxBarHeight - 2) * (coreUsage / 100))
                            anchors.bottom: backgroundBar.bottom
                            anchors.bottomMargin: 1
                            anchors.horizontalCenter: backgroundBar.horizontalCenter
                            color: coreColor
                            radius: 1

                            // Animated height changes
                            Behavior on height {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.OutQuad
                                }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }

                            // Subtle glow effect for high usage
                            Rectangle {
                                anchors.fill: parent
                                color: parent.color
                                radius: parent.radius
                                opacity: Math.max(0, (coreUsage - 50) / 50 * 0.4)
                                z: -1
                            }
                        }

                        // Core label
                        Text {
                            id: coreLabel
                            text: index.toString()
                            font.family: tooltipWindow.fontFamily
                            font.pixelSize: tooltipWindow.fontSize - 2
                            color: tooltipWindow.textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            opacity: 0.8
                        }
                    }
                }
            }
        }
    }

    function showAt(x, y, overallCpu, cores, colorsObj, side, connX, connY) {
        overallUsage = overallCpu || 0
        coreUsages = cores || []
        colors = colorsObj
        
        // Set connection properties and show
        connectionSide = side || "top"
        connectionX = connX || width / 2
        connectionY = connY || height / 2
        
        tooltipWindow.x = x
        tooltipWindow.y = y
        
        visible = true
        connectionStem.requestPaint()
        showAnimation.start()
    }

    function updateData(overallCpu, cores, colorsObj) {
        overallUsage = overallCpu || 0
        coreUsages = cores || []
        colors = colorsObj
    }
}