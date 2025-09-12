import QtQuick

Row {
    id: powerActionsRow
    
    // Configurable properties
    property var actions: []
    property int iconSize: 64
    property int itemSpacing: 20
    property int itemSize: iconSize + 16
    property bool showBorders: false
    property int borderRadius: 8
    property int borderWidth: 2
    property int animationDuration: 150
    property real normalOpacity: 0.8
    property real highlightOpacity: 1.0
    
    // Current selection (for keyboard navigation)
    property int currentIndex: 0
    
    // Signal for when an action is triggered
    signal actionTriggered(int index, var action)
    
    Colors { id: colors }
    
    spacing: itemSpacing
    
    Repeater {
        model: powerActionsRow.actions
        
        Item {
            id: actionItem
            width: itemSize
            height: itemSize
            
            property bool isHovered: mouseArea.containsMouse
            property bool isFocused: index === powerActionsRow.currentIndex
            property bool isHighlighted: isHovered || isFocused
            
            // Highlight background (only shown if showBorders is true)
            Rectangle {
                anchors.fill: parent
                radius: borderRadius
                color: "transparent"
                border.color: parent.isHighlighted ? colors.surface : "transparent"
                border.width: borderWidth
                opacity: (parent.isHighlighted && showBorders) ? highlightOpacity : 0
                visible: showBorders
                
                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }
            
            // Icon
            Text {
                anchors.centerIn: parent
                text: modelData.icon
                font.family: colors.fontFamily
                font.pixelSize: iconSize
                color: modelData.color
                opacity: parent.isHighlighted ? highlightOpacity : normalOpacity
                
                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    powerActionsRow.currentIndex = index
                    powerActionsRow.actionTriggered(index, modelData)
                }
                onEntered: powerActionsRow.currentIndex = index
                
                // Prevent clicks from propagating to background
                onPressed: function(mouse) { mouse.accepted = true }
            }
        }
    }
}