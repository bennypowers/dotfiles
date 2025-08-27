import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Column {
    id: workspaceIndicator
    spacing: 8

    Colors {
        id: colors
    }

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: workspaceRect
            width: 40
            height: 32
            radius: 6

            property bool hovered: false

            color: {
                if (modelData.active) return colors.sapphire
                if (hovered) return colors.overlay
                return colors.surface
            }

            Text {
                text: modelData.name || modelData.id
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: colors.textSize
                font.bold: modelData.active
                color: modelData.active ? colors.crust : colors.text
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Hyprland.dispatch("workspace " + modelData.id)
                }
                hoverEnabled: true

                onEntered: {
                    workspaceRect.hovered = true
                }

                onExited: {
                    workspaceRect.hovered = false
                }
            }
        }
    }
}
