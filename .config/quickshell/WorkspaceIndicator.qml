pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

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

    // Workmode state tracking (same as WorkmodeWidget)
    property string vmName: "silverblue"
    property bool vmRunning: false
    property bool viewerActive: false
    property string iconWorkmodeOn: "󰃖"  // Green filled briefcase (workmode ON)
    property string iconWorkmodeOff: "󰠔"  // Grey empty outlined briefcase (workmode OFF)

    // Listen to Hyprland events to update special workspace visibility
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            switch (event.name) {
                case "activespecial":
                    const [specialData] = event.data.split(",") // Get workspace name part

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

    // VM state checking processes (same as WorkmodeWidget)
    Component.onCompleted: {
        statusTimer.start()
        vmStatusProcess.running = true
    }

    Process {
        id: vmStatusProcess
        command: ["virsh", "domstate", workspaceIndicator.vmName]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    workspaceIndicator.vmRunning = (state === "running")
                    viewerCheckProcess.running = true
                }
            }
        }
    }

    Process {
        id: viewerCheckProcess
        command: ["pgrep", "-f", "virt-viewer"]
        stdout: SplitParser {
            onRead: function(data) {
                workspaceIndicator.viewerActive = data && data.trim().length > 0
            }
        }
        onExited: function(exitCode) {
            if (exitCode === 1) {
                workspaceIndicator.viewerActive = false
            }
        }
    }

    Timer {
        id: statusTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered: vmStatusProcess.running = true
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
                text: workspaceIndicator.magicVisible ? "":""
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
                text: {
                    if (workspaceIndicator.vmRunning && workspaceIndicator.viewerActive) {
                        return workspaceIndicator.iconWorkmodeOn
                    } else {
                        return workspaceIndicator.iconWorkmodeOff
                    }
                }
                color: {
                    if (workspaceIndicator.vmRunning) {
                        // When workspace is active (purple background), use darker green for contrast
                        return workspaceIndicator.workmodeVisible ? colors.surface : colors.green
                    } else {
                        return colors.overlay
                    }
                }
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
