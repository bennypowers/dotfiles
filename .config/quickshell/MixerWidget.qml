import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "."

Rectangle {
    id: mixerWidget
    color: colors.base
    radius: 8
    border.color: colors.overlay
    border.width: 1

    Component.onCompleted: {
        console.log("MixerWidget created, size:", width, "x", height)
        console.log("MixerWidget visible:", visible)
    }

    onWidthChanged: console.log("MixerWidget width changed to:", width)
    onHeightChanged: console.log("MixerWidget height changed to:", height)
    onVisibleChanged: console.log("MixerWidget visible changed to:", visible)

    // Configurable parameters
    property int maxVisibleItems: 6
    property real itemHeight: 50
    property real iconSize: 20
    property real volumeSliderHeight: 8
    property real muteButtonSize: 24
    property int animationDuration: 200

    Colors {
        id: colors
    }

    // Track all Pipewire objects and default devices
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource
        ].concat(Pipewire.objects || [])
    }

    // Tooltip
    SimpleTooltip {
        id: tooltip
        backgroundColor: colors.surface
        borderColor: colors.overlay
        textColor: colors.text
    }

    Column {
        anchors.fill: parent
        spacing: 4

        // Header
        Text {
            text: "🎚️ Audio Mixer"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            font.bold: true
            color: colors.text
            anchors.horizontalCenter: parent.horizontalCenter
        }


        // Scrollable list of audio nodes
        ScrollView {
            width: parent.width
            height: Math.min(mixerWidget.maxVisibleItems * mixerWidget.itemHeight, audioList.contentHeight)
            clip: true

            ListView {
                id: audioList
                width: parent.width
                height: contentHeight
                spacing: 2
                interactive: contentHeight > height

                // Use actual audio nodes (sinks for outputs, sources for inputs)
                model: {
                    var nodes = []

                    // Add default sink (main audio output)
                    if (Pipewire.defaultAudioSink) {
                        console.log("Adding default sink to mixer:", Pipewire.defaultAudioSink.description)
                        nodes.push(Pipewire.defaultAudioSink)
                    } else {
                        console.log("No default sink available")
                    }

                    // Add default source (main audio input/microphone)
                    if (Pipewire.defaultAudioSource) {
                        console.log("Adding default source to mixer:", Pipewire.defaultAudioSource.description)
                        nodes.push(Pipewire.defaultAudioSource)
                    } else {
                        console.log("No default source available")
                    }

                    console.log("MixerWidget model has", nodes.length, "nodes")
                    return nodes
                }

                delegate: MixerItem {
                    width: audioList.width
                    height: mixerWidget.itemHeight
                    node: modelData
                    iconSize: mixerWidget.iconSize
                    volumeSliderHeight: mixerWidget.volumeSliderHeight
                    muteButtonSize: mixerWidget.muteButtonSize
                    animationDuration: mixerWidget.animationDuration

                    Component.onCompleted: {
                        console.log("MixerItem delegate created for node:", modelData ? modelData.description : "null")
                    }
                }
            }
        }
    }
}
