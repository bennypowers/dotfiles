import QtQuick
import Quickshell.Io

Item {
    id: cameraIndicator

    property bool cameraActive: false
    property bool shouldDisplay: cameraActive  // Only show when camera is active
    property int deviceCheckInterval: 2000

    property string cameraIcon: cameraActive ? "󰄀" : "󰄁"

    Component.onCompleted: {
        cameraCheckProcess.running = true
    }

    // Camera monitoring process
    Process {
        id: cameraCheckProcess

        command: ["sh", "-c", "lsof /dev/video* 2>/dev/null | grep -v 'COMMAND' | wc -l"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    var activeCount = parseInt(data.trim())
                    cameraActive = activeCount > 0
                } catch (e) {
                    console.log("CameraIndicator: Error parsing camera status:", e)
                }
            }
        }

        onExited: function (exitCode) {
            if (exitCode === 1) {
                cameraActive = false
            }
        }
    }

    Timer {
        id: cameraCheckTimer

        interval: deviceCheckInterval
        repeat: true
        running: true

        onTriggered: {
            cameraCheckProcess.running = true
        }
    }
}
