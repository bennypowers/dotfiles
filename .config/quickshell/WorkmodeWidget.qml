import QtQuick
import Quickshell.Io

Rectangle {
    id: workmodeWidget
    color: "transparent"
    radius: 8

    property bool vmRunning: false
    property bool viewerActive: false
    property bool initializing: false  // No longer need startup delay
    property string vmName: "silverblue"

    // Configurable parameters
    property int statusCheckInterval: 5000
    property int viewerWorkspace: 10
    property int viewerStartDelay: 2000
    property int vmStartupCheckDelay: 1000

    Colors {
        id: colors
    }

    // Smart anchor utility
    SmartAnchor {
        id: smartAnchor
    }


    Component.onCompleted: {
        // Start status checking immediately - no longer need delay for safety
        statusTimer.start()
        vmStatusProcess.running = true
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: {
                if (workmodeWidget.vmRunning && workmodeWidget.viewerActive) {
                    return "󰃖"  // Briefcase icon (on)
                } else if (workmodeWidget.vmRunning) {
                    return ""  // Briefcase icon (on)
                } else {
                    return ""  // Sleep/suspended icon for stopped VM
                }
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.iconSize
            color: workmodeWidget.vmRunning ? colors.green : colors.overlay
            anchors.horizontalCenter: parent.horizontalCenter

            // No spinning animation - it's annoying
        }
    }

    function generateTooltipText() {
        let text = `<b>Workmode VM (${workmodeWidget.vmName})</b><br/>`

        if (workmodeWidget.vmRunning && workmodeWidget.viewerActive) {
            text += `<b>Status:</b> <span style="color: ${colors.green};">Running with viewer</span><br/>`
            text += `<b>Action:</b> Click to suspend VM and close viewer`
        } else if (workmodeWidget.vmRunning) {
            text += `<b>Status:</b> <span style="color: ${colors.yellow};">Running (no viewer)</span><br/>`
            text += `<b>Action:</b> Click to launch viewer on workspace ${workmodeWidget.viewerWorkspace}`
        } else {
            text += `<b>Status:</b> <span style="color: ${colors.overlay};">Stopped/Suspended</span><br/>`
            text += `<b>Action:</b> Click to start/resume VM and launch viewer`
        }

        return text
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (workmodeWidget.vmRunning && workmodeWidget.viewerActive) {
                // VM is running and viewer is active -> suspend and kill viewer
                console.log("WorkmodeWidget: User requested VM suspend and viewer close")
                vmSuspendProcess.running = true
            } else {
                // VM is stopped/suspended -> start/resume and launch viewer
                console.log("WorkmodeWidget: User requested VM start/resume and viewer launch")
                vmStartProcess.running = true
            }
        }
        hoverEnabled: true
        onEntered: {
            parent.color = colors.surface
            try {
                var anchorInfo = smartAnchor.calculateTooltipPosition(workmodeWidget, 200, 100)
                tooltip.showAt(anchorInfo.x, anchorInfo.y, generateTooltipText())
            } catch (e) {
                tooltip.showAt(workmodeWidget.mapToGlobal(workmodeWidget.width, 0).x, workmodeWidget.mapToGlobal(0, 0).y, generateTooltipText())
            }
        }
        onExited: {
            parent.color = "transparent"
            tooltip.hide()
        }
    }

    // Tooltip
    SimpleTooltip {
        id: tooltip
    }

    // Check VM status (read-only monitoring, never affects running VMs)
    Process {
        id: vmStatusProcess
        command: ["virsh", "domstate", workmodeWidget.vmName]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    const wasRunning = workmodeWidget.vmRunning
                    workmodeWidget.vmRunning = (state === "running" || state === "paused")

                    // Log state changes for debugging
                    if (wasRunning !== workmodeWidget.vmRunning) {
                        console.log("WorkmodeWidget: VM state changed to:", state)
                    }

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
            onRead: function(data) {
                workmodeWidget.viewerActive = data && data.trim().length > 0
            }
        }
        onExited: function(exitCode) {
            // pgrep returns 1 if no processes found
            if (exitCode === 1) {
                workmodeWidget.viewerActive = false
            }
        }
    }

    // Regular status checking timer
    Timer {
        id: statusTimer
        interval: workmodeWidget.statusCheckInterval
        running: false  // Started in Component.onCompleted
        repeat: true
        onTriggered: vmStatusProcess.running = true
    }

    // VM suspend process (only runs on user action, never automatically)
    Process {
        id: vmSuspendProcess
        command: ["virsh", "suspend", workmodeWidget.vmName]
        onStarted: {
            console.log("WorkmodeWidget: Suspending VM:", workmodeWidget.vmName)
        }
        onExited: {
            console.log("WorkmodeWidget: VM suspend completed, killing viewer")
            // After suspending, kill virt-viewer
            killViewerProcess.running = true
        }
    }

    // VM start/resume process
    Process {
        id: vmStartProcess
        command: ["bash", "-c", "state=$(virsh domstate " + workmodeWidget.vmName + "); if [ \"$state\" = \"shut off\" ]; then virsh start " + workmodeWidget.vmName + "; elif [ \"$state\" = \"paused\" ]; then virsh resume " + workmodeWidget.vmName + "; fi"]
        onExited: {
            // After starting/resuming, launch virt-viewer on workspace 10
            launchViewerProcess.running = true
        }
    }

    // Kill virt-viewer process (only runs on user action, never automatically)
    Process {
        id: killViewerProcess
        command: ["pkill", "-f", "virt-viewer"]
        onStarted: {
            console.log("WorkmodeWidget: Killing virt-viewer processes")
        }
        onExited: {
            console.log("WorkmodeWidget: virt-viewer processes killed, refreshing status")
            // Refresh status after killing viewer
            vmStatusProcess.running = true
        }
    }

    // Launch virt-viewer completely detached from quickshell
    Process {
        id: launchViewerProcess
        command: ["setsid", "-f", "/home/bennyp/.config/quickshell/launch-virt-viewer.sh", workmodeWidget.vmName, workmodeWidget.viewerWorkspace.toString(), (workmodeWidget.viewerStartDelay / 1000).toString(), (workmodeWidget.vmStartupCheckDelay / 1000).toString()]
        onExited: function(exitCode) {
            console.log("WorkmodeWidget: virt-viewer launcher detached with code:", exitCode)
            // Refresh status after launching viewer
            vmStatusProcess.running = true
        }
    }
}
