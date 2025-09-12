import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io
import Quickshell
import Quickshell._Window

Rectangle {
    id: volumeWidget

    property real arcLineWidth: 3
    property real arcRadius: 16
    property int colorAnimationDuration: 150
    property real currentMicVolume: defaultSource && defaultSource.ready && defaultSource.audio && !isNaN(defaultSource.audio.volume) ? defaultSource.audio.volume : 0.5
    property real currentVolume: defaultSink && defaultSink.ready && defaultSink.audio && !isNaN(defaultSink.audio.volume) ? defaultSink.audio.volume : 0.5
    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource

    // Volume level thresholds for icon selection
    property real highVolumeThreshold: 0.7
    property bool isMicMuted: defaultSource && defaultSource.ready && defaultSource.audio ? defaultSource.audio.muted : false
    property bool isMuted: defaultSink && defaultSink.ready && defaultSink.audio ? defaultSink.audio.muted : false
    property real knobRadius: 100
    // Configurable appearance parameters
    property real knobSize: parent.width - spacing
    property real mediumVolumeThreshold: 0.3

    // Mixer popup properties
    property bool mixerVisible: false
    property real percentageSize: 10
    property int spacing: 8
    property real volumeIconSize: 18
    property real volumeStepSize: 0.05

    color: "transparent"
    height: 60
    radius: 8

    onCurrentMicVolumeChanged: volumeArc.requestPaint()

    // Redraw arc when volume changes
    onCurrentVolumeChanged: volumeArc.requestPaint()
    onIsMicMutedChanged: volumeArc.requestPaint()
    onIsMutedChanged: volumeArc.requestPaint()

    Colors {
        id: colors

    }

    // Smart anchor utility
    SmartAnchor {
        id: smartAnchor

    }

    // Tooltip for all hover information
    Tooltip {
        id: tooltip

    }
    Column {
        anchors.centerIn: parent
        spacing: 2

        // Circular volume knob
        Item {
            id: volumeKnob

            anchors.horizontalCenter: parent.horizontalCenter
            height: 48
            width: 48

            // Background circle with hover effect
            Rectangle {
                id: knobBackground

                anchors.centerIn: parent
                border.color: colors.overlay
                border.width: 1
                color: colors.surface
                height: volumeWidget.knobSize
                radius: volumeWidget.knobRadius
                width: volumeWidget.knobSize

                Behavior on color {
                    ColorAnimation {
                        duration: volumeWidget.colorAnimationDuration
                    }
                }
            }

            // Larger mouse area for easier hovering
            MouseArea {
                id: volumeMouseArea

                property bool hovered: false

                function createTooltipContent() {
                    var component = Qt.createComponent("VolumeTooltipContent.qml");
                    if (component.status === Component.Ready) {
                        console.log("Component ready, creating object...");
                        var contentItem = component.createObject(tooltip.contentContainer, {
                            colors: colors,
                            fontFamily: tooltip.fontFamily,
                            fontSize: tooltip.fontSize,
                            textColor: tooltip.textColor
                        });
                        tooltip.contentItem = contentItem;
                        // Allow tooltip to handle its own hide animation and delay
                        tooltip.disableInternalHover = false;
                    }
                }
                function hideTooltip() {
                    tooltip.hide();
                }
                function showTooltip() {
                    if (!tooltip.visible) {
                        createTooltipContent();
                        tooltip.showForWidget(volumeMouseArea);
                    }
                }

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.centerIn: parent
                height: 50
                hoverEnabled: true
                width: 50

                onClicked: function (mouse) {
                    switch (mouse.button) {
                    case Qt.LeftButton:
                        // Left click: toggle mute
                        if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                            volumeWidget.defaultSink.audio.muted = !volumeWidget.isMuted;
                        }
                        break;
                    }
                }
                onEntered: {
                    hovered = true;
                    knobBackground.color = colors.surface;
                    showTooltip();
                }
                onExited: {
                    hovered = false;
                    knobBackground.color = colors.surface;
                    hideTooltip();
                }
                onWheel: function (wheel) {
                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                        const delta = wheel.angleDelta.y > 0 ? volumeWidget.volumeStepSize : -volumeWidget.volumeStepSize;
                        const newVolume = Math.max(0, Math.min(1, volumeWidget.currentVolume + delta));
                        volumeWidget.defaultSink.audio.volume = newVolume;
                    }
                }
            }

            // Volume arc
            Canvas {
                id: volumeArc

                anchors.centerIn: parent
                height: volumeWidget.knobSize
                width: volumeWidget.knobSize

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var centerX = width / 2;
                    var centerY = height / 2;
                    var baseRadius = volumeWidget.arcRadius;
                    var arcSpacing = 3;  // Space between speaker and mic arcs
                    var speakerRadius = baseRadius;
                    var micRadius = baseRadius - arcSpacing - (volumeWidget.arcLineWidth / 2);

                    var startAngle = Math.PI * 0.75;  // Start at 135 degrees
                    var maxAngle = Math.PI * 1.5;     // 270 degrees max span

                    // Draw speaker volume arc (outer)
                    var speakerEndAngle = startAngle + (maxAngle * volumeWidget.currentVolume);
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, speakerRadius, startAngle, speakerEndAngle);
                    ctx.lineWidth = volumeWidget.arcLineWidth;
                    ctx.strokeStyle = volumeWidget.isMuted ? colors.overlay : colors.mauve;
                    ctx.stroke();

                    // Draw microphone volume arc (inner) - only if mic exists
                    if (volumeWidget.defaultSource) {
                        var micEndAngle = startAngle + (maxAngle * volumeWidget.currentMicVolume);
                        ctx.beginPath();
                        ctx.arc(centerX, centerY, micRadius, startAngle, micEndAngle);
                        ctx.lineWidth = volumeWidget.arcLineWidth;
                        ctx.strokeStyle = volumeWidget.isMicMuted ? colors.overlay : colors.green;
                        ctx.stroke();
                    }
                }
            }

            // Volume icon in center
            Text {
                anchors.centerIn: parent
                color: volumeWidget.isMuted ? colors.overlay : colors.text
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: volumeWidget.volumeIconSize
                text: volumeWidget.isMuted ? "󰝟" : ""
            }
        }
    }

    // Mixer popup window
    PopupWindow {
        id: mixerPopup

        property int availableChannels: {
            var count = 0;
            if (volumeWidget.defaultSink)
                count++;
            if (volumeWidget.defaultSource)
                count++;
            return count;
        }

        color: "transparent"
        height: 300
        width: 350

        onVisibleChanged: {
            volumeWidget.mixerVisible = visible;
        }

        anchor {
            rect.height: 10
            rect.width: 10
            rect.x: 0
            rect.y: 0
        }
    }

    // Pipewire object tracker to ensure proper binding
    PwObjectTracker {
        objects: [volumeWidget.defaultSink, volumeWidget.defaultSource]
    }
}
