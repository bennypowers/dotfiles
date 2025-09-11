import QtQuick
import Quickshell.Io

Rectangle {
    id: cameraWidget
    height: 40
    color: "transparent"
    radius: 8
    property int iconSize: 26

    property bool cameraActive: false
    property int deviceCheckInterval: 2000
    property int colorAnimationDuration: 150

    Colors {
        id: colors
    }

    Tooltip {
        id: tooltip
    }

    Item {
        width: cameraWidget.iconSize
        height: cameraWidget.iconSize
        anchors.centerIn: parent

        Text {
            text: cameraWidget.cameraActive ? "󰄀" : "󰄁"  // Camera on/off icons
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: cameraWidget.iconSize
            color: cameraWidget.cameraActive ? colors.red : colors.overlay
            anchors.centerIn: parent
            Behavior on color {
                ColorAnimation { duration: cameraWidget.colorAnimationDuration }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                var tooltipText = cameraWidget.cameraActive ?
                    "<b>Camera:</b> Active (in use)" :
                    "<b>Camera:</b> Inactive"
                tooltip.showForWidget(cameraWidget, tooltipText)
            }
            onExited: {
                tooltip.hide()
            }
        }
    }

    // Camera monitoring process - checks for active camera processes
    Process {
        id: cameraCheckProcess
        command: ["sh", "-c", "lsof /dev/video* 2>/dev/null | grep -v 'COMMAND' | wc -l"]
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    var activeCount = parseInt(data.trim())
                    cameraWidget.cameraActive = activeCount > 0
                } catch (e) {
                    console.log("CameraWidget: Error parsing camera status:", e)
                }
            }
        }

        onExited: {
            if (exitCode === 1) {
                cameraWidget.cameraActive = false
            }
        }
    }

    // Timer for periodic camera checks
    Timer {
        id: deviceCheckTimer
        interval: cameraWidget.deviceCheckInterval
        running: true
        repeat: true
        onTriggered: {
            cameraCheckProcess.running = true
        }
    }

    Component.onCompleted: {
        cameraCheckProcess.running = true
    }
}
