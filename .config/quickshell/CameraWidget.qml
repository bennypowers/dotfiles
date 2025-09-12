import QtQuick
import Quickshell.Io

Rectangle {
    id: cameraWidget

    // Property to receive shell root reference
    property var shellRoot: null

    property bool cameraActive: false
    property int colorAnimationDuration: 150
    property int deviceCheckInterval: 2000
    property int iconSize: 26

    color: "transparent"
    height: 40
    radius: 8

    Component.onCompleted: {
        cameraCheckProcess.running = true;
    }

    Colors {
        id: colors

    }
    Tooltip {
        id: tooltip

    }
    Item {
        anchors.centerIn: parent
        height: cameraWidget.iconSize
        width: cameraWidget.iconSize

        Text {
            anchors.centerIn: parent
            color: cameraWidget.cameraActive ? colors.red : colors.overlay
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: cameraWidget.iconSize
            text: cameraWidget.cameraActive ? "󰄀" : "󰄁"  // Camera on/off icons

            Behavior on color {
                ColorAnimation {
                    duration: cameraWidget.colorAnimationDuration
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                var tooltipText = cameraWidget.cameraActive ? "<b>Camera:</b> Active (in use)" : "<b>Camera:</b> Inactive";
                tooltip.showForWidget(cameraWidget, tooltipText);
            }
            onExited: {
                tooltip.hide();
            }
        }
    }

    // Camera monitoring process - checks for active camera processes
    Process {
        id: cameraCheckProcess

        command: ["sh", "-c", "lsof /dev/video* 2>/dev/null | grep -v 'COMMAND' | wc -l"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    var activeCount = parseInt(data.trim());
                    cameraWidget.cameraActive = activeCount > 0;
                } catch (e) {
                    console.log("CameraWidget: Error parsing camera status:", e);
                }
            }
        }

        onExited: {
            if (exitCode === 1) {
                cameraWidget.cameraActive = false;
            }
        }
    }

    // Timer for periodic camera checks
    Timer {
        id: deviceCheckTimer

        interval: cameraWidget.deviceCheckInterval
        repeat: true
        running: true

        onTriggered: {
            cameraCheckProcess.running = true;
        }
    }
}
