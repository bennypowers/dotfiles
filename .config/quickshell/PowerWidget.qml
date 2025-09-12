import QtQuick
import Quickshell

Rectangle {
    id: powerWidget
    color: "transparent"
    radius: 8

    // Create our own overlay instance
    PowerOverlay {
        id: powerOverlay
    }

    Colors {
        id: colors
    }

    // Tooltip for power actions
    Tooltip { id: tooltip }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: "⏻"  // Power on/off icons
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.iconSize
            color: powerOverlay.visible ? colors.green : colors.overlay
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        property bool hovered: false

        onClicked: {
            console.log("PowerWidget clicked, overlay exists:", !!powerOverlay)
            if (powerOverlay.visible) {
                console.log("Hiding power overlay")
                powerOverlay.hide()
            } else {
                console.log("Showing power overlay")
                powerOverlay.show()
            }
        }
        onEntered: {
            hovered = true
            parent.color = colors.surface
            showTooltip()
        }
        onExited: {
            hovered = false
            parent.color = "transparent"
            tooltip.hide()
        }

        function showTooltip() {
            if (!tooltip.visible) {
                createTooltipContent()
                tooltip.showForWidget(mouseArea)
            }
        }

        function createTooltipContent() {
            console.log("Creating PowerTooltipContent...")
            var component = Qt.createComponent("PowerTooltipContent.qml")
            console.log("Component status:", component.status)
            if (component.status === Component.Ready) {
                console.log("Component ready, creating object...")
                var contentItem = component.createObject(tooltip.contentContainer, {
                    colors: colors
                })
                if (contentItem) {
                    console.log("TooltipContent created successfully")
                    tooltip.contentItem = contentItem
                    // Connect the tooltip content's action requests to actual power actions
                    contentItem.actionRequested.connect(function(actionIndex) {
                        console.log("Action requested:", actionIndex)
                        if (powerOverlay.actions && powerOverlay.actions[actionIndex]) {
                            powerOverlay.actions[actionIndex].action()
                        }
                    })
                    tooltip.disableInternalHover = false
                } else {
                    console.error("Failed to create tooltipContent object")
                }
            } else if (component.status === Component.Error) {
                console.error("Failed to create PowerTooltipContent:", component.errorString())
            } else {
                console.log("Component not ready yet, status:", component.status)
            }
        }
    }
}
