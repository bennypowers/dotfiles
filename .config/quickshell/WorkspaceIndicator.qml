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

    // Properties to track special workspace visibility
    property bool magicVisible: false
    property bool workmodeVisible: false

    property bool specialActive: magicVisible || workmodeVisible

    // Listen to Hyprland events to update special workspace visibility
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            switch (event.name) {
                case "activespecial":
                    const specialData = event.data.split(",")[0] // Get workspace name part

                    if (specialData === "special:magic") {
                        workspaceIndicator.magicVisible = true
                        workspaceIndicator.workmodeVisible = false
                    } else if (specialData === "special:workmode") {
                        workspaceIndicator.magicVisible = false
                        workspaceIndicator.workmodeVisible = true
                    } else if (specialData === "") {
                        // Empty means special workspace closed
                        workspaceIndicator.magicVisible = false
                        workspaceIndicator.workmodeVisible = false
                    }
                    break
            }
        }
    }

    // First show magic special workspace if it exists
    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            visible: modelData.name === "special:magic"
            width: visible ? parent.width - workspaceIndicator.spacing : 0
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius

            required property HyprlandWorkspace modelData
            property bool hovered: false

            color: workspaceIndicator.magicVisible ? colors.mauve : colors.overlay

            Text {
                anchors.centerIn: parent
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                font.bold: workspaceIndicator.magicVisible
                text: "S"
                color: colors.surface
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("togglespecialworkspace magic")
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }

    // Then show regular workspaces
    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            visible: modelData.id > 0
            width: visible ? parent.width - workspaceIndicator.spacing : 0
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius

            required property HyprlandWorkspace modelData
            property bool hovered: false

            color: {
                if (modelData.active) {
                    // Use dimmed sapphire when any special workspace is active
                    return workspaceIndicator.specialActive ? colors.surface : colors.sapphire
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
                font.bold: parent.modelData.active
                text: parent.modelData.name || parent.modelData.id
                color: parent.modelData.active ? colors.crust : colors.text
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + parent.modelData.id)
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }

    // Finally show workmode special workspace if it exists
    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            visible: modelData.name === "special:workmode"
            width: visible ? parent.width - workspaceIndicator.spacing : 0
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius

            required property HyprlandWorkspace modelData
            property bool hovered: false

            color: workspaceIndicator.workmodeVisible ? colors.mauve : colors.overlay

            Text {
                anchors.centerIn: parent
                font.family: colors.fontFamily
                font.pixelSize: colors.iconSize
                font.bold: workspaceIndicator.workmodeVisible
                text: "󰃖"  // Briefcase icon
                color: workspaceIndicator.workmodeVisible ? colors.green : colors.surface
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("togglespecialworkspace workmode")
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }

}
