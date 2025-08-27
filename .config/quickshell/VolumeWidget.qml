import QtQuick
import Quickshell.Services.Pipewire

Rectangle {
    id: volumeWidget
    height: 60
    color: "transparent"
    radius: 8

    property var defaultSink: Pipewire.defaultAudioSink
    property real currentVolume: defaultSink && defaultSink.ready && defaultSink.audio && !isNaN(defaultSink.audio.volume) ? defaultSink.audio.volume : 0.5
    property bool isMuted: defaultSink && defaultSink.ready && defaultSink.audio ? defaultSink.audio.muted : false

    Colors {
        id: colors
    }


    property string volumeIcon: {
        if (isMuted) return ""
        if (currentVolume >= 0.7) return ""
        else if (currentVolume >= 0.3) return ""
        else return ""
    }


    Column {
        anchors.centerIn: parent
        spacing: 4

        // Circular volume knob
        Item {
            id: volumeKnob
            width: 36
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter

            // Background circle with hover effect
            Rectangle {
                id: knobBackground
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 16
                color: colors.surface
                border.color: colors.overlay
                border.width: 1

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Circular mouse area for hover effect
            MouseArea {
                anchors.centerIn: parent
                width: 36
                height: 36
                hoverEnabled: true

                onEntered: {
                    knobBackground.color = colors.surface
                }

                onExited: {
                    knobBackground.color = colors.surface
                }

                onClicked: {
                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                        volumeWidget.defaultSink.audio.muted = !volumeWidget.isMuted
                    }
                }

                onWheel: function(wheel) {
                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                        const newVolume = Math.max(0, Math.min(1, volumeWidget.currentVolume + delta))
                        volumeWidget.defaultSink.audio.volume = newVolume
                    }
                }
            }

            // Volume arc
            Canvas {
                id: volumeArc
                anchors.centerIn: parent
                width: 32
                height: 32

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var centerX = width / 2
                    var centerY = height / 2
                    var radius = 12
                    var startAngle = Math.PI * 0.75  // Start at 135 degrees
                    var endAngle = startAngle + (Math.PI * 1.5 * volumeWidget.currentVolume)  // 270 degrees max

                    // Draw volume arc
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                    ctx.lineWidth = 3
                    ctx.strokeStyle = volumeWidget.isMuted ? colors.overlay : colors.mauve
                    ctx.stroke()
                }
            }

            // Volume icon in center
            Text {
                text: volumeWidget.isMuted ? "󰝟" : volumeWidget.volumeIcon
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: volumeWidget.isMuted ? colors.smallIconSize : colors.textSize
                color: volumeWidget.isMuted ? colors.overlay : colors.text
                anchors.centerIn: parent
            }
        }

        // Volume percentage
        Text {
            text: Math.round(volumeWidget.currentVolume * 100) + "%"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.smallTextSize
            color: colors.subtext
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Redraw arc when volume changes
    onCurrentVolumeChanged: volumeArc.requestPaint()
    onIsMutedChanged: volumeArc.requestPaint()

    // Pipewire object tracker to ensure proper binding
    PwObjectTracker {
        objects: [volumeWidget.defaultSink]
    }
}
