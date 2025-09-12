import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    property bool shouldShowOsd: false
    property bool watchedMuted: watchedSink && watchedSink.audio ? watchedSink.audio.muted : false
    property var watchedSink: Pipewire.defaultAudioSink
    property real watchedVolume: watchedSink && watchedSink.audio ? watchedSink.audio.volume : 0

    onWatchedMutedChanged: {
        root.shouldShowOsd = true;
        hideTimer.restart();
    }
    onWatchedVolumeChanged: {
        root.shouldShowOsd = true;
        hideTimer.restart();
    }

    Colors {
        id: colors

    }

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
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
            color: "transparent"
            exclusiveZone: 0
            implicitHeight: 60
            implicitWidth: 350
            margins.bottom: screen.height / 4

            // An empty click mask prevents the window from blocking mouse events
            mask: Region {
            }

            Rectangle {
                anchors.fill: parent
                border.color: colors.surface
                border.width: 1
                color: colors.base
                radius: 12

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 15
                        rightMargin: 15
                    }
                    Text {
                        Layout.preferredWidth: 40
                        color: root.watchedMuted ? colors.red : colors.text
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: colors.iconSize
                        horizontalAlignment: Text.AlignHCenter
                        text: {
                            if (root.watchedMuted)
                                return "󰖁";

                            const volume = root.watchedVolume;
                            if (volume === 0)
                                return "󰕿";
                            if (volume < 0.33)
                                return "󰖀";
                            if (volume < 0.66)
                                return "󰕾";
                            return "󰕾";
                        }
                    }
                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Rectangle {
                            color: colors.surface
                            height: 8
                            radius: 4
                            width: parent.width

                            Rectangle {
                                color: {
                                    const sink = Pipewire.defaultAudioSink;
                                    if (!sink || !sink.audio)
                                        return colors.overlay;
                                    return sink.audio.muted ? colors.red : colors.sapphire;
                                }
                                radius: parent.radius
                                width: {
                                    const sink = Pipewire.defaultAudioSink;
                                    if (!sink || !sink.audio)
                                        return 0;
                                    return parent.width * sink.audio.volume;
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on width {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutQuad
                                    }
                                }

                                anchors {
                                    bottom: parent.bottom
                                    left: parent.left
                                    top: parent.top
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
