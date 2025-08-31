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
            property bool isSpecial: modelData.name && modelData.name.toString().includes("special")

            color: {
                if (isSpecial) {
                    // Special workspace gets pink color
                    return modelData.active ? colors.mauve : colors.peach
                }
                if (modelData.active) return colors.sapphire
                if (hovered) return colors.overlay
                return colors.surface
            }

            Text {
                text: {
                    if (isSpecial) {
                        console.log("Special workspace found - name:", modelData.name, "id:", modelData.id)
                        return "S"
                    }
                    return modelData.name || modelData.id
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: colors.textSize
                font.bold: modelData.active
                color:
                  isSpecial ? colors.surface
                : modelData.active ? colors.crust
                : colors.text
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Workspace clicked - name:", modelData.name, "id:", modelData.id, "isSpecial:", isSpecial)
                    if (isSpecial) {
                        // Special workspaces use the name (e.g., "special:magic")
                        console.log("Dispatching special workspace:", modelData.name)
                        Hyprland.dispatch("workspace " + modelData.name)
                    } else {
                        // Regular workspaces use the ID
                        console.log("Dispatching regular workspace:", modelData.id)
                        Hyprland.dispatch("workspace " + modelData.id)
                    }
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
