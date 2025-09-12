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

    // Function to show mixer popup
    function showMixerPopup() {
        try {
            // Get the correct window reference
            var window = volumeWidget.QsWindow;
            if (window && window.window) {
                mixerPopup.anchor.window = window.window;
            } else if (window) {
                mixerPopup.anchor.window = window;
            } else {
                console.log("volumeWidget: No window found, trying without anchor");
            }

            // Use smart anchor calculation for mixer popup positioning
            var anchorInfo = smartAnchor.calculateAnchor(volumeWidget, mixerPopup.implicitWidth, mixerPopup.implicitHeight);
            mixerPopup.anchor.rect.x = anchorInfo.x;
            mixerPopup.anchor.rect.y = anchorInfo.y;
            mixerPopup.visible = true;
            volumeWidget.mixerVisible = true;
        } catch (error) {
            console.log("Error in showMixerPopup:", error);
        }
    }

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
                    console.log("Creating VolumeTooltipContent...");
                    var component = Qt.createComponent("VolumeTooltipContent.qml");
                    console.log("Component status:", component.status);
                    if (component.status === Component.Ready) {
                        console.log("Component ready, creating object...");
                        var contentItem = component.createObject(tooltip.contentContainer, {
                            colors: colors,
                            fontFamily: tooltip.fontFamily,
                            fontSize: tooltip.fontSize,
                            textColor: tooltip.textColor
                        });
                        console.log("Created content item:", contentItem);
                        console.log("Content item width:", contentItem ? contentItem.width : "null");
                        console.log("Content item height:", contentItem ? contentItem.height : "null");
                        tooltip.contentItem = contentItem;
                        // Allow tooltip to handle its own hide animation and delay
                        tooltip.disableInternalHover = false;
                    } else if (component.status === Component.Error) {
                        console.log("VolumeWidget: Error creating tooltip component:", component.errorString());
                    } else {
                        console.log("VolumeWidget: Component not ready, status:", component.status);
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
                        console.log("Left click - toggling mute");
                        if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                            volumeWidget.defaultSink.audio.muted = !volumeWidget.isMuted;
                        }
                        break;
                    case Qt.RightButton:
                        console.log("Right click - showing mixer popup");
                        // Right click: show/hide mixer popup
                        if (volumeWidget.mixerVisible) {
                            console.log("Hiding mixer popup");
                            mixerPopup.visible = false;
                        } else {
                            console.log("Showing mixer popup");
                            showMixerPopup();
                        }
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

        // Volume percentage
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.subtext
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: volumeWidget.percentageSize
            text: Math.round(volumeWidget.currentVolume * 100) + "%"
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
        Rectangle {
            id: popupContent

            anchors.fill: parent
            border.color: colors.overlay
            border.width: 2
            color: colors.base
            radius: 8

            // clip: true

            // MouseArea to keep popup open when clicking inside and detect hover
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true

                onPressed: function (mouse) {
                    mouse.accepted = false;  // Let child elements handle the click
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                anchors.top: parent.top
                color: colors.text
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: "🎚️ Audio Mixer (DEBUG: Popup visible)"
            }
            Column {
                height: parent.height - 76
                spacing: 16
                width: parent.width - 32
                x: 16
                y: 60

                // Debug: Show what devices are available
                Text {
                    color: colors.text
                    font.pixelSize: 10
                    text: "Debug: defaultSink=" + (volumeWidget.defaultSink ? "YES" : "NO") + ", defaultSource=" + (volumeWidget.defaultSource ? "YES" : "NO")
                    width: parent.width
                }

                // Speaker controls
                Column {
                    spacing: 8
                    visible: volumeWidget.defaultSink !== null && volumeWidget.defaultSink !== undefined
                    width: parent.width

                    Rectangle {
                        color: "blue"
                        height: 40
                        opacity: 0.8
                        width: parent.width

                        Text {
                            anchors.centerIn: parent
                            color: "white"
                            font.pixelSize: 12
                            text: "SPEAKER SECTION DEBUG - visible: " + visible
                        }
                    }
                    Text {
                        color: colors.text
                        font.bold: true
                        font.pixelSize: 14
                        text: "🔊 " + (volumeWidget.defaultSink ? volumeWidget.defaultSink.description : "No Speaker")
                    }
                    Row {
                        spacing: 12
                        width: parent.width

                        // Volume percentage
                        Text {
                            color: colors.subtext
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignRight
                            text: volumeWidget.defaultSink && volumeWidget.defaultSink.audio ? Math.round(volumeWidget.defaultSink.audio.volume * 100) + "%" : "0%"
                            width: 35
                        }

                        // Volume slider
                        Rectangle {
                            border.color: colors.overlay
                            border.width: 1
                            color: colors.surface
                            height: 8
                            radius: 4
                            width: parent.width - 35 - 24 - 24 // minus percentage, spacing, mute button

                            Rectangle {
                                color: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? colors.overlay : colors.mauve
                                height: parent.height
                                radius: parent.radius
                                width: volumeWidget.defaultSink && volumeWidget.defaultSink.audio ? parent.width * volumeWidget.defaultSink.audio.volume : 0
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: function (mouse) {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const newVolume = mouse.x / width;
                                        volumeWidget.defaultSink.audio.volume = Math.max(0, Math.min(1, newVolume));
                                    }
                                }
                                onPositionChanged: function (mouse) {
                                    if (pressed && volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const newVolume = mouse.x / width;
                                        volumeWidget.defaultSink.audio.volume = Math.max(0, Math.min(1, newVolume));
                                    }
                                }
                                onWheel: function (wheel) {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                                        const newVolume = Math.max(0, Math.min(1, volumeWidget.defaultSink.audio.volume + delta));
                                        volumeWidget.defaultSink.audio.volume = newVolume;
                                    }
                                }
                            }
                        }

                        // Mute button
                        Rectangle {
                            border.color: colors.overlay
                            border.width: muteMouseArea.containsMouse ? 1 : 0
                            color: muteMouseArea.containsMouse ? colors.surface : "transparent"
                            height: 24
                            radius: 4
                            width: 24

                            Text {
                                anchors.centerIn: parent
                                color: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? colors.red : colors.green
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? "󰝟" : "󰕾"
                            }
                            MouseArea {
                                id: muteMouseArea

                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        volumeWidget.defaultSink.audio.muted = !volumeWidget.defaultSink.audio.muted;
                                    }
                                }
                            }
                        }
                    }
                }

                // Microphone controls
                Column {
                    spacing: 8
                    visible: volumeWidget.defaultSource !== null && volumeWidget.defaultSource !== undefined
                    width: parent.width

                    Text {
                        color: colors.text
                        font.bold: true
                        font.pixelSize: 14
                        text: "🎤 " + (volumeWidget.defaultSource ? volumeWidget.defaultSource.description : "No Microphone")
                    }
                    Row {
                        spacing: 12
                        width: parent.width

                        // Volume percentage
                        Text {
                            color: colors.subtext
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignRight
                            text: volumeWidget.defaultSource && volumeWidget.defaultSource.audio ? Math.round(volumeWidget.defaultSource.audio.volume * 100) + "%" : "0%"
                            width: 35
                        }

                        // Volume slider
                        Rectangle {
                            border.color: colors.overlay
                            border.width: 1
                            color: colors.surface
                            height: 8
                            radius: 4
                            width: parent.width - 35 - 24 - 24

                            Rectangle {
                                color: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? colors.overlay : colors.mauve
                                height: parent.height
                                radius: parent.radius
                                width: volumeWidget.defaultSource && volumeWidget.defaultSource.audio ? parent.width * volumeWidget.defaultSource.audio.volume : 0
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: function (mouse) {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const newVolume = mouse.x / width;
                                        volumeWidget.defaultSource.audio.volume = Math.max(0, Math.min(1, newVolume));
                                    }
                                }
                                onPositionChanged: function (mouse) {
                                    if (pressed && volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const newVolume = mouse.x / width;
                                        volumeWidget.defaultSource.audio.volume = Math.max(0, Math.min(1, newVolume));
                                    }
                                }
                                onWheel: function (wheel) {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                                        const newVolume = Math.max(0, Math.min(1, volumeWidget.defaultSource.audio.volume + delta));
                                        volumeWidget.defaultSource.audio.volume = newVolume;
                                    }
                                }
                            }
                        }

                        // Mute button
                        Rectangle {
                            border.color: colors.overlay
                            border.width: micMuteMouseArea.containsMouse ? 1 : 0
                            color: micMuteMouseArea.containsMouse ? colors.surface : "transparent"
                            height: 24
                            radius: 4
                            width: 24

                            Text {
                                anchors.centerIn: parent
                                color: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? colors.red : colors.green
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? "󰍭" : "󰍬"
                            }
                            MouseArea {
                                id: micMuteMouseArea

                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        volumeWidget.defaultSource.audio.muted = !volumeWidget.defaultSource.audio.muted;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Pipewire object tracker to ensure proper binding
    PwObjectTracker {
        objects: [volumeWidget.defaultSink, volumeWidget.defaultSource]
    }
}
