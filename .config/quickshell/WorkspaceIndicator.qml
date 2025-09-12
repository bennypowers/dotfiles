pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

Column {
    id: workspaceIndicator

    property string iconWorkmodeOff: "󰠔"  // Grey empty outlined briefcase (workmode OFF)

    property string iconWorkmodeOn: "󰃖"  // Green filled briefcase (workmode ON)

    // Properties to track special workspace visibility
    property bool magicVisible: false
    property int rectHeight: 32
    property int rectRadius: 6
    property bool specialActive: magicVisible || workmodeVisible
    property bool viewerActive: false

    // Workmode state tracking (same as WorkmodeWidget)
    property string vmName: "silverblue"
    property bool vmRunning: false
    property bool workmodeVisible: false

    spacing: 8

    // VM state checking processes (same as WorkmodeWidget)
    Component.onCompleted: {
        statusTimer.start();
        vmStatusProcess.running = true;
    }

    Colors {
        id: colors

    }

    // Listen to Hyprland events to update special workspace visibility
    Connections {
        function onRawEvent(event) {
            switch (event.name) {
            case "activespecial":
                const [specialData] = event.data.split(","); // Get workspace name part

                if (specialData === "special:magic") {
                    workspaceIndicator.magicVisible = true;
                    workspaceIndicator.workmodeVisible = false;
                } else if (specialData === "special:workmode") {
                    workspaceIndicator.magicVisible = false;
                    workspaceIndicator.workmodeVisible = true;
                } else if (specialData === "") {
                    // Empty means special workspace closed
                    workspaceIndicator.magicVisible = false;
                    workspaceIndicator.workmodeVisible = false;
                }
                break;
            }
        }

        target: Hyprland
    }
    Process {
        id: vmStatusProcess

        command: ["virsh", "domstate", workspaceIndicator.vmName]

        stdout: SplitParser {
            onRead: function (data) {
                if (data && data.trim()) {
                    const state = data.trim();
                    workspaceIndicator.vmRunning = (state === "running");
                    viewerCheckProcess.running = true;
                }
            }
        }
    }
    Process {
        id: viewerCheckProcess

        command: ["pgrep", "-f", "virt-viewer"]

        stdout: SplitParser {
            onRead: function (data) {
                workspaceIndicator.viewerActive = data && data.trim().length > 0;
            }
        }

        onExited: function (exitCode) {
            if (exitCode === 1) {
                workspaceIndicator.viewerActive = false;
            }
        }
    }
    Timer {
        id: statusTimer

        interval: 5000
        repeat: true
        running: false

        onTriggered: vmStatusProcess.running = true
    }

    // First show magic special workspace if it exists
    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            property bool hovered: false
            required property HyprlandWorkspace modelData

            color: workspaceIndicator.magicVisible ? colors.mauve : colors.overlay
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius
            visible: modelData.name === "special:magic"
            width: visible ? parent.width - workspaceIndicator.spacing : 0

            Text {
                anchors.centerIn: parent
                color: colors.surface
                font.bold: workspaceIndicator.magicVisible
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                text: workspaceIndicator.magicVisible ? "" : ""
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: Hyprland.dispatch("togglespecialworkspace magic")
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }

    // Then show regular workspaces
    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            property bool hovered: false
            required property HyprlandWorkspace modelData

            color: {
                if (modelData.active) {
                    // Use dimmed sapphire when any special workspace is active
                    return workspaceIndicator.specialActive ? colors.surface : colors.sapphire;
                } else if (hovered) {
                    return colors.overlay;
                } else {
                    return colors.surface;
                }
            }
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius
            visible: modelData.id > 0
            width: visible ? parent.width - workspaceIndicator.spacing : 0

            Text {
                anchors.centerIn: parent
                color: parent.modelData.active ? colors.crust : colors.text
                font.bold: parent.modelData.active
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                text: parent.modelData.name || parent.modelData.id
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: Hyprland.dispatch("workspace " + parent.modelData.id)
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }

    // Finally show workmode special workspace if it exists
    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            property bool hovered: false
            required property HyprlandWorkspace modelData

            color: workspaceIndicator.workmodeVisible ? colors.mauve : colors.overlay
            height: visible ? workspaceIndicator.rectHeight : 0
            radius: workspaceIndicator.rectRadius
            visible: modelData.name === "special:workmode"
            width: visible ? parent.width - workspaceIndicator.spacing : 0

            Text {
                anchors.centerIn: parent
                color: {
                    if (workspaceIndicator.vmRunning) {
                        // When workspace is active (purple background), use darker green for contrast
                        return workspaceIndicator.workmodeVisible ? colors.surface : colors.green;
                    } else {
                        return colors.overlay;
                    }
                }
                font.bold: workspaceIndicator.workmodeVisible
                font.family: colors.fontFamily
                font.pixelSize: colors.iconSize
                text: {
                    if (workspaceIndicator.vmRunning && workspaceIndicator.viewerActive) {
                        return workspaceIndicator.iconWorkmodeOn;
                    } else {
                        return workspaceIndicator.iconWorkmodeOff;
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: Hyprland.dispatch("togglespecialworkspace workmode")
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
            }
        }
    }
}
