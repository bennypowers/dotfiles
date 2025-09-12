import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

Rectangle {
    id: micWidget

    // Property to receive shell root reference
    property var shellRoot: null

    property int colorAnimationDuration: 150
    property var defaultSource: Pipewire.defaultAudioSource
    property int deviceCheckInterval: 2000
    property int iconSize: 26
    property bool isMicMuted: defaultSource && defaultSource.ready && defaultSource.audio ? defaultSource.audio.muted : false
    property bool micActive: false

    color: "transparent"
    height: 40
    radius: 8

    Component.onCompleted: {
        micCheckProcess.running = true;
    }

    Colors {
        id: colors

    }
    Tooltip {
        id: tooltip

    }
    Item {
        anchors.centerIn: parent
        height: micWidget.iconSize
        width: micWidget.iconSize

        Text {
            anchors.centerIn: parent
            color: {
                // Red if muted, green if active and unmuted, gray if inactive
                if (micWidget.defaultSource && micWidget.defaultSource.audio && micWidget.defaultSource.audio.muted) {
                    return colors.red;
                }
                return micWidget.micActive ? colors.green : colors.overlay;
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: micWidget.iconSize
            text: {
                // Show muted icon if mic is muted, otherwise show based on activity
                if (micWidget.defaultSource && micWidget.defaultSource.audio && micWidget.defaultSource.audio.muted) {
                    return "󰍭";  // Muted mic icon
                }
                return micWidget.micActive ? "󰍬" : "󰍭";  // Active/inactive based on app usage
            }

            Behavior on color {
                ColorAnimation {
                    duration: micWidget.colorAnimationDuration
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                var status = "";
                if (micWidget.defaultSource && micWidget.defaultSource.audio && micWidget.defaultSource.audio.muted) {
                    status = "<b>Microphone:</b> Muted";
                } else if (micWidget.micActive) {
                    status = "<b>Microphone:</b> Active (in use)";
                } else {
                    status = "<b>Microphone:</b> Available (not in use)";
                }
                tooltip.showForWidget(micWidget, status);
            }
            onExited: {
                tooltip.hide();
            }
        }
    }

    // Microphone monitoring process - checks for processes actively recording audio
    Process {
        id: micCheckProcess

        command: ["sh", "-c", "pactl list short source-outputs | wc -l"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    var activeCount = parseInt(data.trim());
                    micWidget.micActive = activeCount > 0;
                } catch (e) {
                    console.log("MicWidget: Error parsing mic status:", e);
                }
            }
        }

        onExited: {
            if (exitCode !== 0) {
                micWidget.micActive = false;
            }
        }
    }

    // Timer for periodic mic checks
    Timer {
        id: deviceCheckTimer

        interval: micWidget.deviceCheckInterval
        repeat: true
        running: true

        onTriggered: {
            micCheckProcess.running = true;
        }
    }
}
