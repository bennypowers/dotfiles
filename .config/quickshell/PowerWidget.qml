import QtQuick
import Quickshell

BaseWidget {
    id: powerWidget

    Component.onCompleted: {
        console.log("🔧 PowerWidget completed. shellRoot:", !!shellRoot);
    }

    // Create our own overlay instance
    PowerOverlay {
        id: powerOverlay

    }
    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: powerOverlay.visible ? colors.green : colors.overlay
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.iconSize
            text: "⏻"  // Power on/off icons
        }
    }
    MouseArea {
        id: mouseArea

        property bool hovered: false

        function createTooltipContent() {
            console.log("Creating PowerTooltipContent...");
            var component = Qt.createComponent("PowerTooltipContent.qml");
            console.log("Component status:", component.status);
            if (component.status === Component.Ready) {
                console.log("Component ready, creating object...");
                var contentItem = component.createObject(tooltip.contentContainer, {
                    colors: colors
                });
                if (contentItem) {
                    console.log("TooltipContent created successfully");
                    tooltip.contentItem = contentItem;
                    // Connect the tooltip content's action requests to actual power actions
                    contentItem.actionRequested.connect(function (actionIndex) {
                        console.log("Action requested:", actionIndex);
                        if (powerOverlay.actions && powerOverlay.actions[actionIndex]) {
                            powerOverlay.actions[actionIndex].action();
                        }
                    });
                    tooltip.disableInternalHover = false;
                } else {
                    console.error("Failed to create tooltipContent object");
                }
            } else if (component.status === Component.Error) {
                console.error("Failed to create PowerTooltipContent:", component.errorString());
            } else {
                console.log("Component not ready yet, status:", component.status);
            }
        }
        function showTooltip() {
            if (!tooltip.visible) {
                createTooltipContent();
                tooltip.showForWidget(mouseArea);
            }
        }

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            console.log("PowerWidget clicked, overlay exists:", !!powerOverlay);
            if (powerOverlay.visible) {
                console.log("Hiding power overlay");
                powerOverlay.hide();
            } else {
                console.log("Showing power overlay");
                powerOverlay.show();
            }
        }
        onEntered: {
            hovered = true;
            parent.color = colors.surface;
            showTooltip();
        }
        onExited: {
            hovered = false;
            parent.color = "transparent";
            tooltip.hide();
        }
    }
}
