import QtQuick
import Quickshell.Io

Rectangle {
    id: workmodeWidget
    color: "transparent"
    radius: 8

    property bool vmRunning: false
    property bool viewerActive: false
    property string vmName: "silverblue"

    Colors {
        id: colors
    }

    Component.onCompleted: {
        vmStatusProcess.running = true
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: {
                if (workmodeWidget.vmRunning && workmodeWidget.viewerActive) {
                    return "󰍹"  // Desktop/monitor icon for active VM with viewer
                } else if (workmodeWidget.vmRunning) {
                    return "󰾔"  // Computer icon for running VM without viewer
                } else {
                    return ""  // Sleep/suspended icon for stopped VM
                }
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.iconSize
            color: workmodeWidget.vmRunning ? colors.green : colors.overlay
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    function generateTooltipText() {
        let text = `<b>Workmode VM (${workmodeWidget.vmName})</b><br/>`

        if (workmodeWidget.vmRunning && workmodeWidget.viewerActive) {
            text += `<b>Status:</b> <span style="color: ${colors.green};">Running with viewer</span><br/>`
            text += `<b>Action:</b> Click to suspend VM and close viewer`
        } else if (workmodeWidget.vmRunning) {
            text += `<b>Status:</b> <span style="color: ${colors.yellow};">Running (no viewer)</span><br/>`
            text += `<b>Action:</b> Click to launch viewer on workspace 10`
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
                vmSuspendProcess.running = true
            } else {
                // VM is stopped/suspended -> start/resume and launch viewer
                vmStartProcess.running = true
            }
        }
        hoverEnabled: true
        onEntered: {
            parent.color = colors.surface
            tooltip.showAt(workmodeWidget.mapToGlobal(workmodeWidget.width, 0).x, workmodeWidget.mapToGlobal(0, 0).y, generateTooltipText())
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

    // Check VM status
    Process {
        id: vmStatusProcess
        command: ["virsh", "domstate", workmodeWidget.vmName]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    workmodeWidget.vmRunning = (state === "running")
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

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: vmStatusProcess.running = true
    }

    // VM suspend process
    Process {
        id: vmSuspendProcess
        command: ["virsh", "suspend", workmodeWidget.vmName]
        onExited: {
            // After suspending, kill virt-viewer
            killViewerProcess.running = true
        }
    }

    // VM start/resume process
    Process {
        id: vmStartProcess
        command: ["bash", "-c", "virsh domstate " + workmodeWidget.vmName + " | grep -q 'shut off' && virsh start " + workmodeWidget.vmName + " || virsh resume " + workmodeWidget.vmName]
        onExited: {
            // After starting/resuming, launch virt-viewer on workspace 10
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

    // Launch virt-viewer on workspace 10
    Process {
        id: launchViewerProcess
        command: ["bash", "-c", "hyprctl dispatch workspace 10 && sleep 2 && until virsh domstate " + workmodeWidget.vmName + " | grep -q running; do sleep 1; done && virt-viewer --attach " + workmodeWidget.vmName]
        stderr: SplitParser {
            onRead: function(data) {
                console.log("WorkmodeWidget: virt-viewer stderr:", JSON.stringify(data))
            }
        }
        stdout: SplitParser {
            onRead: function(data) {
                console.log("WorkmodeWidget: virt-viewer stdout:", JSON.stringify(data))
            }
        }
        onExited: function(exitCode) {
            console.log("WorkmodeWidget: virt-viewer process exited with code:", exitCode)
            // Refresh status after launching viewer
            vmStatusProcess.running = true
        }
    }
}
