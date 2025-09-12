import QtQuick

Item {
    id: root

    property real barWidth: 20
    required property var colors
    required property int coreIndex
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 12
    property real maxBarHeight: 140
    required property real usage
    readonly property string usageColor: {
        if (usage < 25)
            return colors.green;
        else if (usage < 50)
            return colors.yellow;
        else if (usage < 75)
            return colors.peach;
        else
            return colors.red;
    }

    height: maxBarHeight + 20
    width: barWidth

    // Background bar
    Rectangle {
        anchors.bottom: coreLabel.top
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: root.colors.overlay
        border.width: 1
        color: "transparent"
        height: root.maxBarHeight
        opacity: 0.3
        radius: 2
        width: root.barWidth
    }

    // Active usage bar
    Rectangle {
        id: usageBar

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.usageColor
        height: Math.max(2, (root.maxBarHeight - 2) * (root.usage / 100))
        radius: 1
        width: root.barWidth - 2

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
    }

    // Core label
    Text {
        id: coreLabel

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.colors.text
        font.family: root.fontFamily
        font.pixelSize: root.fontSize - 2
        opacity: 0.8
        text: root.coreIndex.toString()
    }
}
