import QtQuick
import Quickshell.Io

Column {
    id: workmodeSection

    property string iconOff: "󰠔"  // Grey empty outlined briefcase (workmode OFF)
    property string iconOn: "󰃖"  // Green filled briefcase (workmode ON)
    property bool viewerActive: false
    property bool vmRunning: false
    property string vmName: "silverblue"
    property int statusCheckInterval: 5000
    property int viewerStartDelay: 2000
    property int vmStartupCheckDelay: 1000

    spacing: 0

    Component.onCompleted: {
        vmStatusProcess.running = true
        statusTimer.start()
    }

    Colors {
        id: colors
    }

    // Check VM status
    Process {
        id: vmStatusProcess

        command: ["virsh", "domstate", workmodeSection.vmName]

        stdout: SplitParser {
            onRead: function (data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    workmodeSection.vmRunning = (state === "running")
                    // After checking VM, check virt-viewer
                    viewerCheckProcess.running = true
                }
            }
        }
    }

    // Check virt-viewer status
    Process {
        id: viewerCheckProcess

        command: ["pgrep", "-f", "virt-viewer"]

        stdout: SplitParser {
            onRead: function (data) {
                const wasViewerActive = workmodeSection.viewerActive
                workmodeSection.viewerActive = data && data.trim().length > 0

                // Auto-suspend VM if viewer was closed but VM is still running
                if (wasViewerActive && !workmodeSection.viewerActive && workmodeSection.vmRunning) {
                    vmSuspendProcess.running = true
                }
            }
        }

        onExited: function (exitCode) {
            const wasViewerActive = workmodeSection.viewerActive
            if (exitCode === 1) {
                workmodeSection.viewerActive = false
            }

            // Auto-suspend VM if viewer was closed but VM is still running
            if (wasViewerActive && !workmodeSection.viewerActive && workmodeSection.vmRunning) {
                vmSuspendProcess.running = true
            }
        }
    }

    Timer {
        id: statusTimer

        interval: workmodeSection.statusCheckInterval
        repeat: true
        running: false

        onTriggered: vmStatusProcess.running = true
    }

    // VM suspend process
    Process {
        id: vmSuspendProcess

        command: ["virsh", "suspend", workmodeSection.vmName]

        onExited: {
            // After suspending, kill virt-viewer
            killViewerProcess.running = true
        }
    }

    // VM start/resume process
    Process {
        id: vmStartProcess

        command: ["bash", "-c", "state=$(virsh domstate " + workmodeSection.vmName + "); if [ \"$state\" = \"shut off\" ]; then virsh start " + workmodeSection.vmName + "; elif [ \"$state\" = \"paused\" ]; then virsh resume " + workmodeSection.vmName + "; fi"]

        onExited: {
            // After starting/resuming, launch virt-viewer
            launchViewerProcess.running = true
        }
    }

    // Kill virt-viewer process
    Process {
        id: killViewerProcess

        command: ["pkill", "-f", "virt-viewer"]

        onExited: {
            // Refresh status after killing viewer
            vmStatusProcess.running = true
        }
    }

    // Launch virt-viewer
    Process {
        id: launchViewerProcess

        command: ["setsid", "-f", "/home/bennyp/.config/quickshell/launch-virt-viewer.sh", workmodeSection.vmName, "workmode", (workmodeSection.viewerStartDelay / 1000).toString(), (workmodeSection.vmStartupCheckDelay / 1000).toString()]

        onExited: function (exitCode) {
            // Refresh status after launching viewer
            vmStatusProcess.running = true
        }
    }

    // Action button style
    Rectangle {
        width: parent.width
        height: 64
        radius: 12
        color: workmodeMouseArea.containsMouse ? colors.surface : colors.mantle

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // Workmode icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: (vmRunning && viewerActive) ? colors.green : colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                text: (vmRunning && viewerActive) ? iconOn : iconOff
            }

            // Workmode status
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.bold: true
                    text: "Workmode VM"
                }

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: (vmRunning && viewerActive) ? "Running" : "Suspended"
                }
            }

            Item {
                width: parent.width - 200
                height: 1
            }

            // Chevron
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: "󰅂"
            }
        }

        MouseArea {
            id: workmodeMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (vmRunning && viewerActive) {
                    // Workmode ON -> turn OFF
                    vmSuspendProcess.running = true
                } else {
                    // Workmode OFF -> turn ON
                    vmStartProcess.running = true
                }
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}
