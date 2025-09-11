import QtQuick
import Quickshell.Io

Rectangle {
    id: workmodeWidget
    color: "transparent"
    radius: 8

    property bool initializing: false  // No longer need startup delay
    property string vmName: "silverblue"

    property string iconOn: "󰃖"  // Green filled briefcase (workmode ON)
    property string iconOff: "󰠔"  // Grey empty outlined briefcase (workmode OFF)

    // State tracking
    property bool vmRunning: false
    property bool viewerActive: false

    // Configurable parameters
    property int statusCheckInterval: 5000
    property int viewerStartDelay: 2000
    property int vmStartupCheckDelay: 1000

    Colors { id: colors }
    Tooltip { id: tooltip }

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
                if (vmRunning && viewerActive) {
                    return workmodeWidget.iconOn
                } else {
                    return workmodeWidget.iconOff
                }
            }
            font.family: colors.fontFamily
            font.pixelSize: colors.iconSize
            color: (vmRunning && viewerActive) ? colors.green : colors.overlay
            anchors.horizontalCenter: parent.horizontalCenter

            // No spinning animation - it's annoying
        }
    }

    function generateTooltipText() {
        let text = `<b>Workmode VM (${workmodeWidget.vmName})</b><br/>`

        if (vmRunning && viewerActive) {
            text += `<b>Status:</b> <span style="color: ${colors.green};">ON (running + viewer)</span><br/>`
            text += `<b>Action:</b> Click to turn OFF (suspend VM)`
        } else {
            text += `<b>Status:</b> <span style="color: ${colors.overlay};">OFF (suspended)</span><br/>`
            text += `<b>Action:</b> Click to turn ON (resume VM + launch viewer)`
        }

        return text
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property bool hovered: false
        hoverEnabled: true

        onClicked: {
            if (vmRunning && viewerActive) {
                // Workmode ON -> turn OFF (suspend VM, which will also kill viewer)
                console.log("💼: User requested workmode OFF")
                vmSuspendProcess.running = true
            } else {
                // Workmode OFF -> turn ON (start/resume VM and launch viewer)
                console.log("💼: User requested workmode ON")
                vmStartProcess.running = true
            }
        }

        onEntered: {
            hovered = true
            parent.color = colors.surface
            showTooltip()
        }

        onExited: {
            hovered = false
            parent.color = "transparent"
            tooltip.hide()
        }

        function showTooltip() {
            tooltip.showForWidget(mouseArea, generateTooltipText())
        }
    }

    // Check VM status and enforce clean state management
    Process {
        id: vmStatusProcess
        command: ["virsh", "domstate", workmodeWidget.vmName]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    const wasRunning = workmodeWidget.vmRunning
                    workmodeWidget.vmRunning = (state === "running")

                    // Log state changes for debugging
                    if (wasRunning !== workmodeWidget.vmRunning) {
                        console.log("💼: VM state changed to:", state)
                    }

                    // After checking VM, check virt-viewer
                    viewerCheckProcess.running = true
                }
            }
        }
    }

    // Check virt-viewer status and enforce clean state management
    Process {
        id: viewerCheckProcess
        command: ["pgrep", "-f", "virt-viewer"]
        stdout: SplitParser {
            onRead: function(data) {
                const wasViewerActive = workmodeWidget.viewerActive
                workmodeWidget.viewerActive = data && data.trim().length > 0

                // Auto-suspend VM if viewer was closed but VM is still running
                if (wasViewerActive && !workmodeWidget.viewerActive && workmodeWidget.vmRunning) {
                    console.log("💼: Viewer closed, auto-suspending VM to maintain clean state")
                    vmSuspendProcess.running = true
                }
            }
        }
        onExited: function(exitCode) {
            // pgrep returns 1 if no processes found
            const wasViewerActive = workmodeWidget.viewerActive
            if (exitCode === 1) {
                workmodeWidget.viewerActive = false
            }

            // Auto-suspend VM if viewer was closed but VM is still running
            if (wasViewerActive && !workmodeWidget.viewerActive && workmodeWidget.vmRunning) {
                console.log("💼: Viewer closed, auto-suspending VM to maintain clean state")
                vmSuspendProcess.running = true
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
            console.log("💼: Suspending VM:", workmodeWidget.vmName)
        }
        onExited: {
            console.log("💼: VM suspend completed, killing viewer")
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
            console.log("💼: Killing virt-viewer processes")
        }
        onExited: {
            console.log("💼: virt-viewer processes killed, refreshing status")
            // Refresh status after killing viewer
            vmStatusProcess.running = true
        }
    }

    // Launch virt-viewer completely detached from quickshell
    Process {
        id: launchViewerProcess
        command: ["setsid", "-f", "/home/bennyp/.config/quickshell/launch-virt-viewer.sh", workmodeWidget.vmName, "workmode", (workmodeWidget.viewerStartDelay / 1000).toString(), (workmodeWidget.vmStartupCheckDelay / 1000).toString()]
        onExited: function(exitCode) {
            console.log("💼: virt-viewer launcher detached with code:", exitCode)
            // Refresh status after launching viewer
            vmStatusProcess.running = true
        }
    }
}
