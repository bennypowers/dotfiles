pragma ComponentBehavior: Bound
import QtQuick

Row {
    id: root
    
    required property real cpuUsage
    required property list<real> coreUsages
    required property var colors
    
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property string textColor: "#cdd6f4"
    property real barSpacing: 2
    property real maxBarHeight: 140
    
    spacing: 16
    
    // Overall CPU usage header - left side
    Text {
        id: cpuHeader
        text: `CPU: ${Math.round(root.cpuUsage)}%`
        font.family: root.fontFamily
        font.pixelSize: root.fontSize + 8
        font.bold: true
        color: root.textColor
        anchors.verticalCenter: parent.verticalCenter
    }
    
    // EQ Visualizer bars - right side
    Row {
        spacing: root.barSpacing
        anchors.verticalCenter: parent.verticalCenter
        
        Repeater {
            id: coreRepeater
            model: root.coreUsages.length
            
            delegate: CpuBar {
                required property int index
                coreIndex: index
                usage: index < root.coreUsages.length ? root.coreUsages[index] : 0
                colors: root.colors
                fontFamily: root.fontFamily
                fontSize: root.fontSize
            }
        }
    }
}
