import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "."

Rectangle {
    id: mixerWidget

    property int animationDuration: 200
    property real iconSize: 20
    property real itemHeight: 50

    // Configurable parameters
    property int maxVisibleItems: 6
    property real muteButtonSize: 24
    property real volumeSliderHeight: 8

    border.color: colors.overlay
    border.width: 1
    color: colors.base
    radius: 8

    Component.onCompleted: {
        console.log("MixerWidget created, size:", width, "x", height);
        console.log("MixerWidget visible:", visible);
    }
    onHeightChanged: console.log("MixerWidget height changed to:", height)
    onVisibleChanged: console.log("MixerWidget visible changed to:", visible)
    onWidthChanged: console.log("MixerWidget width changed to:", width)

    Colors {
        id: colors

    }

    // Track all Pipewire objects and default devices
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].concat(Pipewire.objects || [])
    }

    // Tooltip
    Tooltip {
        id: tooltip

    }
    Column {
        anchors.fill: parent
        spacing: 4

        // Header
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.text
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            text: "🎚️ Audio Mixer"
        }

        // Scrollable list of audio nodes
        ScrollView {
            clip: true
            height: Math.min(mixerWidget.maxVisibleItems * mixerWidget.itemHeight, audioList.contentHeight)
            width: parent.width

            ListView {
                id: audioList

                height: contentHeight
                interactive: contentHeight > height

                // Use actual audio nodes (sinks for outputs, sources for inputs)
                model: {
                    var nodes = [];

                    // Add default sink (main audio output)
                    if (Pipewire.defaultAudioSink) {
                        console.log("Adding default sink to mixer:", Pipewire.defaultAudioSink.description);
                        nodes.push(Pipewire.defaultAudioSink);
                    } else {
                        console.log("No default sink available");
                    }

                    // Add default source (main audio input/microphone)
                    if (Pipewire.defaultAudioSource) {
                        console.log("Adding default source to mixer:", Pipewire.defaultAudioSource.description);
                        nodes.push(Pipewire.defaultAudioSource);
                    } else {
                        console.log("No default source available");
                    }

                    console.log("MixerWidget model has", nodes.length, "nodes");
                    return nodes;
                }
                spacing: 2
                width: parent.width

                delegate: MixerItem {
                    animationDuration: mixerWidget.animationDuration
                    height: mixerWidget.itemHeight
                    iconSize: mixerWidget.iconSize
                    muteButtonSize: mixerWidget.muteButtonSize
                    node: modelData
                    volumeSliderHeight: mixerWidget.volumeSliderHeight
                    width: audioList.width

                    Component.onCompleted: {
                        console.log("MixerItem delegate created for node:", modelData ? modelData.description : "null");
                    }
                }
            }
        }
    }
}
