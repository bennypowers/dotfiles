pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Column {
    id: workspaceIndicator
    spacing: 8

    property int rectHeight: 32
    property int rectRadius: 6

    Colors {
        id: colors
    }

    Repeater {
        id: repeater
        model: Hyprland.workspaces

        Rectangle {
            id: ws
            width: parent.width - workspaceIndicator.spacing
            height: workspaceIndicator.rectHeight
            radius: workspaceIndicator.rectRadius

            Layout.leftMargin: workspaceIndicator.spacing
            Layout.rightMargin: workspaceIndicator.spacing

            required property HyprlandWorkspace modelData
            property bool hovered: false
            property bool isSpecial: modelData.name && modelData.name.toString().includes("special")

            color: {
                if (isSpecial) {
                    return ws.modelData.active ? colors.mauve : colors.peach
                } else if (ws.modelData.active) {
                    return colors.sapphire
                } else if (hovered) {
                    return colors.overlay
                } else {
                    return colors.surface
                }
            }

            Text {
                anchors.centerIn: parent
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                font.bold: ws.modelData.active
                text:
                    ws.isSpecial ? "S"
                  : ws.modelData.name || ws.modelData.id
                color:
                    ws.isSpecial ? colors.surface
                  : ws.modelData.active ? colors.crust
                  : colors.text
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (ws.isSpecial) {
                        Hyprland.dispatch("workspace " + ws.modelData.name)
                    } else {
                        Hyprland.dispatch("workspace " + ws.modelData.id)
                    }
                }
                hoverEnabled: true

                onEntered: {
                    ws.hovered = true
                }

                onExited: {
                    ws.hovered = false
                }
            }
        }
    }
}
