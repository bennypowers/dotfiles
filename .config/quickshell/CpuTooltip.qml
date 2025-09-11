import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow

    property alias transientParent: tooltipWindow.transientParent
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 12
    property string backgroundColor: "#45475a"
    property string borderColor: "#6c7086"
    property string textColor: "#cdd6f4"
    property real overallUsage: 0
    property list<real> coreUsages: []
    property QtObject colors: null

    readonly property int barWidth: 14
    readonly property int barSpacing: 2
    readonly property int maxBarHeight: 100
    readonly property int totalWidth: Math.max(200, tooltipWindow.coreUsages.length * (barWidth + barSpacing) - barSpacing + 32)

    width: totalWidth
    height: maxBarHeight + 60

    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: tooltipWindow.backgroundColor
        border.color: tooltipWindow.borderColor
        border.width: 1
        radius: 8

        Column {
            id: content
            anchors.centerIn: parent
            spacing: 12

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
                width: tooltipWindow.coreUsages.length * (tooltipWindow.barWidth + tooltipWindow.barSpacing) - tooltipWindow.barSpacing
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
                                    
                                    // Glow blur effect
                                    layer.enabled: true
                                    layer.effect: ShaderEffect {
                                        property real sigma: 2
                                        fragmentShader: "
                                            varying highp vec2 qt_TexCoord0;
                                            uniform sampler2D source;
                                            uniform lowp float qt_Opacity;
                                            uniform highp float sigma;
                                            void main() {
                                                gl_FragColor = texture2D(source, qt_TexCoord0) * qt_Opacity;
                                            }"
                                    }
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
    }

    function showAt(x, y, overallCpu, cores, colorsObj) {
        overallUsage = overallCpu
        coreUsages = cores
        colors = colorsObj
        tooltipWindow.x = x
        tooltipWindow.y = y
        visible = true
    }

    function updateData(overallCpu, cores, colorsObj) {
        overallUsage = overallCpu
        coreUsages = cores
        colors = colorsObj
    }

    function hide() {
        visible = false
    }
}