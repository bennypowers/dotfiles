import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
            implicitHeight: 24

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
                id: volumeHandle
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: 16
                height: 16
                radius: 8
                color: colors.text
                border.color: colors.blue
                border.width: 2

                // Tooltip on handle
                Rectangle {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: tooltipText.width + 12
                    height: tooltipText.height + 8
                    radius: 4
                    color: colors.surface
                    border.color: colors.blue
                    border.width: 1
                    visible: volumeSlider.pressed || volumeSlider.hovered

                    Text {
                        id: tooltipText
                        anchors.centerIn: parent
                        color: colors.text
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: Math.round(currentVolume * 100) + "%"
                    }
                }
            }
        }

        // Mute button (moved from header)
        Rectangle {
            id: volumeMuteButton

            anchors.verticalCenter: parent.verticalCenter
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

    // Microphone slider
    Row {
        width: parent.width
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: isMicMuted ? colors.red : colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            text: isMicMuted ? "󰍭" : "󰍬"
        }

        Slider {
            id: micSlider

            property real currentMicVolume: defaultSource && defaultSource.ready && defaultSource.audio && !isNaN(defaultSource.audio.volume) ? defaultSource.audio.volume : 0.5

            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 60
            implicitHeight: 24

            from: 0
            to: 1
            value: currentMicVolume

            onMoved: {
                if (defaultSource && defaultSource.audio) {
                    defaultSource.audio.volume = value
                }
            }

            background: Rectangle {
                x: micSlider.leftPadding
                y: micSlider.topPadding + micSlider.availableHeight / 2 - height / 2
                width: micSlider.availableWidth
                height: 4
                radius: 2
                color: colors.surface

                Rectangle {
                    width: micSlider.visualPosition * parent.width
                    height: parent.height
                    color: colors.green
                    radius: 2
                }
            }

            handle: Rectangle {
                id: micHandle
                x: micSlider.leftPadding + micSlider.visualPosition * (micSlider.availableWidth - width)
                y: micSlider.topPadding + micSlider.availableHeight / 2 - height / 2
                width: 16
                height: 16
                radius: 8
                color: colors.text
                border.color: colors.green
                border.width: 2

                // Tooltip on handle
                Rectangle {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: micTooltipText.width + 12
                    height: micTooltipText.height + 8
                    radius: 4
                    color: colors.surface
                    border.color: colors.green
                    border.width: 1
                    visible: micSlider.pressed || micSlider.hovered

                    Text {
                        id: micTooltipText
                        anchors.centerIn: parent
                        color: colors.text
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: Math.round(micSlider.currentMicVolume * 100) + "%"
                    }
                }
            }
        }

        // Mic mute button (moved from header)
        Rectangle {
            id: micMuteButtonInline

            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 24
            radius: 12
            color: isMicMuted ? colors.red : colors.green

            Text {
                anchors.centerIn: parent
                color: isMicMuted ? colors.text : colors.base
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
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
