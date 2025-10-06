import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire

Column {
    id: volumeSection

    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource
    property real currentVolume: defaultSink && defaultSink.ready && defaultSink.audio && !isNaN(defaultSink.audio.volume) ? defaultSink.audio.volume : 0.5
    property bool isMuted: defaultSink && defaultSink.ready && defaultSink.audio ? defaultSink.audio.muted : false
    property bool isMicMuted: defaultSource && defaultSource.ready && defaultSource.audio ? defaultSource.audio.muted : false

    spacing: 12

    Colors {
        id: colors
    }

    // Header with label and mute button
    Row {
        width: parent.width
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            font.bold: true
            text: "Volume"
        }

        Item {
            width: parent.width - muteButton.width - 100
            height: 1
        }

        // Mute button
        Rectangle {
            id: muteButton

            width: 36
            height: 24
            radius: 12
            color: isMuted ? colors.red : colors.surface

            Text {
                anchors.centerIn: parent
                color: colors.text
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                text: isMuted ? "󰝟" : "󰕾"
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (defaultSink && defaultSink.audio) {
                        defaultSink.audio.muted = !defaultSink.audio.muted
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

    // Volume slider
    Row {
        width: parent.width
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            text: isMuted ? "󰝟" : (currentVolume > 0.7 ? "󰕾" : currentVolume > 0.3 ? "󰖀" : "󰕿")
        }

        Slider {
            id: volumeSlider

            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 60

            from: 0
            to: 1
            value: currentVolume

            onMoved: {
                if (defaultSink && defaultSink.audio) {
                    defaultSink.audio.volume = value
                }
            }

            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: volumeSlider.availableWidth
                height: 4
                radius: 2
                color: colors.surface

                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: colors.blue
                    radius: 2
                }
            }

            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: 16
                height: 16
                radius: 8
                color: colors.text
                border.color: colors.blue
                border.width: 2
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: colors.subtext
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            text: Math.round(currentVolume * 100) + "%"
            width: 40
        }
    }

    // Microphone row
    Row {
        width: parent.width
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: isMicMuted ? colors.red : colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            text: "󰍬"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            text: "Microphone"
        }

        Item {
            width: parent.width - micMuteButton.width - 100
            height: 1
        }

        // Mic mute toggle
        Rectangle {
            id: micMuteButton

            width: 36
            height: 24
            radius: 12
            color: isMicMuted ? colors.red : colors.green

            Text {
                anchors.centerIn: parent
                color: colors.text
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                text: isMicMuted ? "󰍭" : "󰍬"
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (defaultSource && defaultSource.audio) {
                        defaultSource.audio.muted = !defaultSource.audio.muted
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
}
