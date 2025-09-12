pragma ComponentBehavior: Bound
import QtQuick

Row {
    id: root

    property real barSpacing: 2
    property real barWidth: 20

    // Precalculated width based on core count
    readonly property real calculatedWidth: {
        var cpuLabelWidth = 80;  // "CPU: 100%" with large font
        var barsWidth = root.coreUsages.length * (root.barWidth + root.barSpacing) - root.barSpacing;  // Remove last spacing
        return cpuLabelWidth + spacing + barsWidth;
    }
    required property var colors
    required property list<real> coreUsages
    required property real cpuUsage
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property real maxBarHeight: 140
    property string textColor: "#cdd6f4"

    spacing: 16
    width: calculatedWidth

    // Overall CPU usage header - left side
    Text {
        id: cpuHeader

        anchors.verticalCenter: parent.verticalCenter
        color: root.textColor
        font.bold: true
        font.family: root.fontFamily
        font.pixelSize: root.fontSize + 8
        text: `CPU: ${Math.round(root.cpuUsage)}%`
    }

    // EQ Visualizer bars - right side
    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.barSpacing

        Repeater {
            id: coreRepeater

            model: root.coreUsages.length

            delegate: CpuBar {
                required property int index

                barWidth: root.barWidth
                colors: root.colors
                coreIndex: index
                fontFamily: root.fontFamily
                fontSize: root.fontSize
                usage: index < root.coreUsages.length ? root.coreUsages[index] : 0
            }
        }
    }
}
