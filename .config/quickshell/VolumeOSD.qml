import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    Colors {
        id: colors
    }

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    property var watchedSink: Pipewire.defaultAudioSink
    property real watchedVolume: watchedSink && watchedSink.audio ? watchedSink.audio.volume : 0
    property bool watchedMuted: watchedSink && watchedSink.audio ? watchedSink.audio.muted : false

    onWatchedVolumeChanged: {
        root.shouldShowOsd = true;
        hideTimer.restart();
    }

    onWatchedMutedChanged: {
        root.shouldShowOsd = true;
        hideTimer.restart();
    }

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }

    // The OSD window will be created and destroyed based on shouldShowOsd
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 4
            exclusiveZone: 0

            implicitWidth: 350
            implicitHeight: 60
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: colors.base
                border.color: colors.surface
                border.width: 1

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 15
                        rightMargin: 15
                    }

                    Text {
                        text: {
                            if (root.watchedMuted) return "󰖁"

                            const volume = root.watchedVolume
                            if (volume === 0) return "󰕿"
                            if (volume < 0.33) return "󰖀"
                            if (volume < 0.66) return "󰕾"
                            return "󰕾"
                        }
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: colors.iconSize
                        color: root.watchedMuted ? colors.red : colors.text
                        Layout.preferredWidth: 40
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Rectangle {
                            width: parent.width
                            height: 8
                            radius: 4
                            color: colors.surface

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }

                                width: {
                                    const sink = Pipewire.defaultAudioSink
                                    if (!sink || !sink.audio) return 0
                                    return parent.width * sink.audio.volume
                                }
                                radius: parent.radius
                                color: {
                                    const sink = Pipewire.defaultAudioSink
                                    if (!sink || !sink.audio) return colors.overlay
                                    return sink.audio.muted ? colors.red : colors.sapphire
                                }

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutQuad
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
                }
            }
        }
    }
}
