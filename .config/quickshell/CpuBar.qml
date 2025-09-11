import QtQuick

Item {
    id: root
    
    required property int coreIndex
    required property real usage
    required property var colors
    
    property real barWidth: 20
    property real maxBarHeight: 140
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 12
    
    width: barWidth
    height: maxBarHeight + 20
    
    readonly property string usageColor: {
        if (usage < 25) return colors.green
        else if (usage < 50) return colors.yellow
        else if (usage < 75) return colors.peach
        else return colors.red
    }
    
    // Background bar
    Rectangle {
        width: root.barWidth
        height: root.maxBarHeight
        anchors.bottom: coreLabel.top
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.color: root.colors.overlay
        border.width: 1
        radius: 2
        opacity: 0.3
    }
    
    // Active usage bar
    Rectangle {
        id: usageBar
        width: root.barWidth - 2
        height: Math.max(2, (root.maxBarHeight - 2) * (root.usage / 100))
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.usageColor
        radius: 1
        
        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    // Core label
    Text {
        id: coreLabel
        text: root.coreIndex.toString()
        font.family: root.fontFamily
        font.pixelSize: root.fontSize - 2
        color: root.colors.text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        opacity: 0.8
    }
}