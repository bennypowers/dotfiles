pragma ComponentBehavior: Bound
import QtQuick

Column {
    id: root
    
    required property real cpuUsage
    required property list<real> coreUsages
    required property var colors
    
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property string textColor: "#cdd6f4"
    property real barSpacing: 4
    property real maxBarHeight: 140
    
    spacing: 12
    
    // Overall CPU usage header
    Text {
        id: cpuHeader
        text: `CPU: ${Math.round(root.cpuUsage)}%`
        font.family: root.fontFamily
        font.pixelSize: root.fontSize + 2
        font.bold: true
        color: root.textColor
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    // EQ Visualizer bars
    Item {
        id: eqContainer
        width: Math.max(250, root.coreUsages.length * (20 + root.barSpacing) + 40)
        height: root.maxBarHeight + 80
        anchors.horizontalCenter: parent.horizontalCenter
        
        Row {
            anchors.centerIn: parent
            spacing: root.barSpacing
            
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
}