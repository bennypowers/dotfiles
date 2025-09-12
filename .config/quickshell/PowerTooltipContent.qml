import QtQuick

Item {
    id: root
    width: 200
    height: 40
    
    Colors { id: colors }
    
    // Signal to communicate action triggers back to parent
    signal actionRequested(int actionIndex)
    
    Row {
        anchors.centerIn: parent
        spacing: 8
        
        Repeater {
            model: [
                { icon: "󰍃", color: colors.yellow },
                { icon: "󰐥", color: colors.blue },
                { icon: "󰜉", color: colors.peach },
                { icon: "󰤂", color: colors.red }
            ]
            
            Rectangle {
                width: colors.iconSize + 8
                height: colors.iconSize + 8
                color: "transparent"
                radius: 4
                
                Text {
                    anchors.centerIn: parent
                    text: modelData.icon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: colors.iconSize
                    color: modelData.color
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.actionRequested(index)
                    }
                    onEntered: {
                        parent.color = colors.overlay
                    }
                    onExited: {
                        parent.color = "transparent"
                    }
                }
            }
        }
    }
}