import QtQuick

Row {
    id: powerActionsRow

    // Configurable properties
    property var actions: []
    property int animationDuration: 150
    property int borderRadius: 8
    property int borderWidth: 2

    // Current selection (for keyboard navigation)
    property int currentIndex: 0
    property real highlightOpacity: 1.0
    property int iconSize: 64
    property int itemSize: iconSize + 16
    property int itemSpacing: 20
    property real normalOpacity: 0.8
    property bool showBorders: false

    // Signal for when an action is triggered
    signal actionTriggered(int index, var action)

    spacing: itemSpacing

    Colors {
        id: colors

    }
    Repeater {
        model: powerActionsRow.actions

        Item {
            id: actionItem

            property bool isFocused: index === powerActionsRow.currentIndex
            property bool isHighlighted: isHovered || isFocused
            property bool isHovered: mouseArea.containsMouse

            height: itemSize
            width: itemSize

            // Highlight background (only shown if showBorders is true)
            Rectangle {
                anchors.fill: parent
                border.color: parent.isHighlighted ? colors.surface : "transparent"
                border.width: borderWidth
                color: "transparent"
                opacity: (parent.isHighlighted && showBorders) ? highlightOpacity : 0
                radius: borderRadius
                visible: showBorders

                Behavior on opacity {
                    NumberAnimation {
                        duration: animationDuration
                    }
                }
            }

            // Icon
            Text {
                anchors.centerIn: parent
                color: modelData.color
                font.family: colors.fontFamily
                font.pixelSize: iconSize
                opacity: parent.isHighlighted ? highlightOpacity : normalOpacity
                text: modelData.icon

                Behavior on opacity {
                    NumberAnimation {
                        duration: animationDuration
                    }
                }
            }
            MouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    powerActionsRow.currentIndex = index;
                    powerActionsRow.actionTriggered(index, modelData);
                }
                onEntered: powerActionsRow.currentIndex = index

                // Prevent clicks from propagating to background
                onPressed: function (mouse) {
                    mouse.accepted = true;
                }
            }
        }
    }
}
