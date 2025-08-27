import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray as ST

Column {
    id: systemTray
    spacing: 4

    Repeater {
        model: ST.SystemTray.items

        Rectangle {
            width: 32
            height: 32
            color: "transparent"
            radius: 4

            Image {
                source: modelData.icon
                width: 20
                height: 20
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()
                    } else if (mouse.button === Qt.RightButton) {
                        modelData.openContextMenu()
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate()
                    }
                }

                hoverEnabled: true

                onEntered: {
                    parent.color = "#313244"
                }

                onExited: {
                    parent.color = "transparent"
                }
            }

            ToolTip {
                visible: parent.hovered
                text: modelData.tooltip || modelData.title || ""
            }
        }
    }
}
