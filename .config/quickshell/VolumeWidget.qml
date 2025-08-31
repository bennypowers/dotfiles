import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io
import Quickshell
import Quickshell._Window

Rectangle {
    id: volumeWidget
    height: 60
    color: "transparent"
    radius: 8

    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource
    property real currentVolume: defaultSink && defaultSink.ready && defaultSink.audio && !isNaN(defaultSink.audio.volume) ? defaultSink.audio.volume : 0.5
    property bool isMuted: defaultSink && defaultSink.ready && defaultSink.audio ? defaultSink.audio.muted : false
    property real currentMicVolume: defaultSource && defaultSource.ready && defaultSource.audio && !isNaN(defaultSource.audio.volume) ? defaultSource.audio.volume : 0.5
    property bool isMicMuted: defaultSource && defaultSource.ready && defaultSource.audio ? defaultSource.audio.muted : false
    property bool micActive: false  // Will be monitored via process checking
    property bool cameraActive: false  // Will be monitored via process checking

    // Configurable appearance parameters
    property real knobSize: 32
    property real knobRadius: 16
    property real arcRadius: 12
    property real arcLineWidth: 3
    property real volumeIconSize: 16
    property real percentageSize: 10
    property int colorAnimationDuration: 150
    property real volumeStepSize: 0.05

    // Volume level thresholds for icon selection
    property real highVolumeThreshold: 0.7
    property real mediumVolumeThreshold: 0.3

    // Mic/Camera monitoring parameters
    property int deviceCheckInterval: 2000

    // Mixer popup properties
    property bool mixerVisible: false

    Colors {
        id: colors
    }

    // Tooltip for mic/camera indicators (defined early to avoid reference errors)
    SimpleTooltip {
        id: tooltip
        backgroundColor: colors.surface
        borderColor: colors.overlay
        textColor: colors.text
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

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
                width: volumeWidget.knobSize
                height: volumeWidget.knobSize
                radius: volumeWidget.knobRadius
                color: colors.surface
                border.color: colors.overlay
                border.width: 1

                Behavior on color {
                    ColorAnimation { duration: volumeWidget.colorAnimationDuration }
                }
            }

            // Circular mouse area for hover effect
            MouseArea {
                anchors.centerIn: parent
                width: 36
                height: 36
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onEntered: {
                    knobBackground.color = colors.surface
                    var tooltipText = "<b>Volume Control</b><br/>Left click: Toggle speaker mute<br/>Right click: Open mixer<br/>Scroll: Adjust speaker volume"
                    if (volumeWidget.defaultSource) {
                        tooltipText += "<br/><br/><b>Dual Volume Display:</b><br/>Outer arc: Speaker volume (purple)<br/>Inner arc: Microphone volume (green)"
                    }
                    tooltip.showAt(
                        volumeWidget.mapToGlobal(volumeWidget.width, 0).x,
                        volumeWidget.mapToGlobal(0, 0).y,
                        tooltipText
                    )
                }

                onExited: {
                    knobBackground.color = colors.surface
                    tooltip.hide()
                }

                onClicked: function(mouse) {
                  switch (mouse.button) {
                    case Qt.LeftButton:
                        // Left click: toggle mute
                        console.log("Left click - toggling mute")
                        if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                            volumeWidget.defaultSink.audio.muted = !volumeWidget.isMuted
                        }
                        break;
                    case Qt.RightButton:
                      console.log("Right click - showing mixer popup")
                      // Right click: show/hide mixer popup
                      if (volumeWidget.mixerVisible) {
                          console.log("Hiding mixer popup")
                          mixerPopup.visible = false
                      } else {
                        console.log("Showing mixer popup")
                        showMixerPopup()
                      }
                  }
                }

                onWheel: function(wheel) {
                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                        const delta = wheel.angleDelta.y > 0 ? volumeWidget.volumeStepSize : -volumeWidget.volumeStepSize
                        const newVolume = Math.max(0, Math.min(1, volumeWidget.currentVolume + delta))
                        volumeWidget.defaultSink.audio.volume = newVolume
                    }
                }
            }

            // Volume arc
            Canvas {
                id: volumeArc
                anchors.centerIn: parent
                width: volumeWidget.knobSize
                height: volumeWidget.knobSize

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var centerX = width / 2
                    var centerY = height / 2
                    var baseRadius = volumeWidget.arcRadius
                    var arcSpacing = 3  // Space between speaker and mic arcs
                    var speakerRadius = baseRadius
                    var micRadius = baseRadius - arcSpacing - (volumeWidget.arcLineWidth / 2)
                    
                    var startAngle = Math.PI * 0.75  // Start at 135 degrees
                    var maxAngle = Math.PI * 1.5     // 270 degrees max span

                    // Draw speaker volume arc (outer)
                    var speakerEndAngle = startAngle + (maxAngle * volumeWidget.currentVolume)
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, speakerRadius, startAngle, speakerEndAngle)
                    ctx.lineWidth = volumeWidget.arcLineWidth
                    ctx.strokeStyle = volumeWidget.isMuted ? colors.overlay : colors.mauve
                    ctx.stroke()

                    // Draw microphone volume arc (inner) - only if mic exists
                    if (volumeWidget.defaultSource) {
                        var micEndAngle = startAngle + (maxAngle * volumeWidget.currentMicVolume)
                        ctx.beginPath()
                        ctx.arc(centerX, centerY, micRadius, startAngle, micEndAngle)
                        ctx.lineWidth = volumeWidget.arcLineWidth
                        ctx.strokeStyle = volumeWidget.isMicMuted ? colors.overlay : colors.green
                        ctx.stroke()
                    }
                }
            }

            // Volume icon in center
            Text {
                text: volumeWidget.isMuted ? "󰝟" : ""
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: volumeWidget.volumeIconSize
                color: volumeWidget.isMuted ? colors.overlay : colors.text
                anchors.centerIn: parent
            }
        }

        // Volume percentage
        Text {
            text: Math.round(volumeWidget.currentVolume * 100) + "%"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: volumeWidget.percentageSize
            color: colors.subtext
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Mic and Camera status indicators
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            // Microphone indicator
            Item {
                width: 16
                height: 16

                Text {
                    text: {
                        // Show muted icon if mic is muted, otherwise show based on activity
                        if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted) {
                            return "󰍭"  // Muted mic icon
                        }
                        return volumeWidget.micActive ? "󰍬" : "󰍭"  // Active/inactive based on app usage
                    }
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: {
                        // Red if muted, green if active and unmuted, gray if inactive
                        if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted) {
                            return colors.red
                        }
                        return volumeWidget.micActive ? colors.green : colors.overlay
                    }
                    anchors.centerIn: parent

                    Behavior on color {
                        ColorAnimation { duration: volumeWidget.colorAnimationDuration }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        var status = ""
                        if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted) {
                            status = "<b>Microphone:</b> Muted"
                        } else if (volumeWidget.micActive) {
                            status = "<b>Microphone:</b> Active (in use)"
                        } else {
                            status = "<b>Microphone:</b> Available (not in use)"
                        }

                        tooltip.showAt(
                            volumeWidget.mapToGlobal(parent.x + parent.width, parent.y).x,
                            volumeWidget.mapToGlobal(parent.x, parent.y).y,
                            status
                        )
                    }
                    onExited: {
                        tooltip.hide()
                    }
                }
            }

            // Camera indicator  
            Item {
                width: 16
                height: 16

                Text {
                    text: volumeWidget.cameraActive ? "󰄀" : "󰄁"  // Camera on/off icons
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: volumeWidget.cameraActive ? colors.red : colors.overlay
                    anchors.centerIn: parent

                    Behavior on color {
                        ColorAnimation { duration: volumeWidget.colorAnimationDuration }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        tooltip.showAt(
                            volumeWidget.mapToGlobal(parent.x + parent.width, parent.y).x,
                            volumeWidget.mapToGlobal(parent.x, parent.y).y,
                            volumeWidget.cameraActive ? 
                                "<b>Camera:</b> Active (in use)" : 
                                "<b>Camera:</b> Inactive"
                        )
                    }
                    onExited: {
                        tooltip.hide()
                    }
                }
            }
        }
    }

    // Redraw arc when volume changes
    onCurrentVolumeChanged: volumeArc.requestPaint()
    onIsMutedChanged: volumeArc.requestPaint()
    onCurrentMicVolumeChanged: volumeArc.requestPaint()
    onIsMicMutedChanged: volumeArc.requestPaint()

    // Camera monitoring process - checks for active camera processes
    Process {
        id: cameraCheckProcess
        command: ["sh", "-c", "lsof /dev/video* 2>/dev/null | grep -v 'COMMAND' | wc -l"]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    var activeCount = parseInt(data.trim())
                    volumeWidget.cameraActive = activeCount > 0
                }
            }
        }
        onExited: function(exitCode) {
            // lsof returns 1 if no processes found, which is normal
            if (exitCode === 1) {
                volumeWidget.cameraActive = false
            }
        }
    }

    // Microphone monitoring process - checks for processes actively recording audio
    Process {
        id: micCheckProcess
        command: ["sh", "-c", "pactl list short source-outputs | wc -l"]
        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    var activeCount = parseInt(data.trim())
                    volumeWidget.micActive = activeCount > 0
                }
            }
        }
        onExited: function(exitCode) {
            if (exitCode !== 0) {
                volumeWidget.micActive = false
            }
        }
    }

    // Timer for periodic camera/mic checks
    Timer {
        id: deviceCheckTimer
        interval: volumeWidget.deviceCheckInterval
        running: true
        repeat: true
        onTriggered: {
            cameraCheckProcess.running = true
            micCheckProcess.running = true
        }
    }

    // Start monitoring immediately
    Component.onCompleted: {
        cameraCheckProcess.running = true
        micCheckProcess.running = true
    }

    // Function to show mixer popup
    function showMixerPopup() {
        try {
            console.log("showMixerPopup called")
            // Get the correct window reference
            var window = volumeWidget.QsWindow
            console.log("QsWindow:", window)
            if (window && window.window) {
                mixerPopup.anchor.window = window.window
                console.log("Set anchor window to:", window.window)
            } else if (window) {
                mixerPopup.anchor.window = window
                console.log("Set anchor window to:", window)
            } else {
                console.log("No window found, trying without anchor")
            }

            // Position the popup next to the volume widget
            console.log("Getting global position...")
            var globalPos = volumeWidget.mapToGlobal(volumeWidget.width + 10, 0)
            console.log("Global position:", globalPos.x, globalPos.y)
            mixerPopup.anchor.rect.x = globalPos.x
            mixerPopup.anchor.rect.y = globalPos.y

            console.log("Setting popup visible to true")
            mixerPopup.visible = true
            volumeWidget.mixerVisible = true
            console.log("Mixer visible set to:", volumeWidget.mixerVisible)
            console.log("showMixerPopup completed successfully")
        } catch (error) {
            console.log("Error in showMixerPopup:", error)
        }
    }

    // Mixer popup window
    PopupWindow {
        id: mixerPopup
        anchor {
            rect.x: 0
            rect.y: 0
            rect.width: 10
            rect.height: 10
        }

        property int availableChannels: {
            var count = 0
            if (volumeWidget.defaultSink) count++
            if (volumeWidget.defaultSource) count++
            return count
        }

        implicitWidth: 350
        implicitHeight: {
            var baseHeight = 80  // Header + margins + padding
            var channelHeight = 70  // Height per audio channel
            return baseHeight + (availableChannels * channelHeight)
        }


        onVisibleChanged: {
            volumeWidget.mixerVisible = visible
        }

        Rectangle {
            id: popupContent
            anchors.fill: parent
            color: colors.base
            radius: 8
            border.color: colors.overlay
            border.width: 2

            // MouseArea to keep popup open when clicking inside and detect hover
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onPressed: function(mouse) {
                    mouse.accepted = false  // Let child elements handle the click
                }
            }

            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                text: "🎚️ Audio Mixer"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                font.bold: true
                color: colors.text
            }

            Column {
                anchors.centerIn: parent
                anchors.margins: 16
                spacing: 24
                width: parent.width - 32

                // Speaker controls
                Column {
                    width: parent.width
                    spacing: 8
                    visible: volumeWidget.defaultSink !== null

                    Text {
                        text: "🔊 " + (volumeWidget.defaultSink ? volumeWidget.defaultSink.description : "No Speaker")
                        color: colors.text
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Row {
                        width: parent.width
                        spacing: 12

                        // Volume percentage
                        Text {
                            width: 35
                            text: volumeWidget.defaultSink && volumeWidget.defaultSink.audio ? Math.round(volumeWidget.defaultSink.audio.volume * 100) + "%" : "0%"
                            color: colors.subtext
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignRight
                        }

                        // Volume slider
                        Rectangle {
                            width: parent.width - 35 - 24 - 24 // minus percentage, spacing, mute button
                            height: 8
                            color: colors.surface
                            radius: 4
                            border.color: colors.overlay
                            border.width: 1

                            Rectangle {
                                height: parent.height
                                width: volumeWidget.defaultSink && volumeWidget.defaultSink.audio ? parent.width * volumeWidget.defaultSink.audio.volume : 0
                                color: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? colors.overlay : colors.mauve
                                radius: parent.radius
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: function(mouse) {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const newVolume = mouse.x / width
                                        volumeWidget.defaultSink.audio.volume = Math.max(0, Math.min(1, newVolume))
                                    }
                                }

                                onPositionChanged: function(mouse) {
                                    if (pressed && volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const newVolume = mouse.x / width
                                        volumeWidget.defaultSink.audio.volume = Math.max(0, Math.min(1, newVolume))
                                    }
                                }

                                onWheel: function(wheel) {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                                        const newVolume = Math.max(0, Math.min(1, volumeWidget.defaultSink.audio.volume + delta))
                                        volumeWidget.defaultSink.audio.volume = newVolume
                                    }
                                }
                            }
                        }

                        // Mute button
                        Rectangle {
                            width: 24
                            height: 24
                            color: muteMouseArea.containsMouse ? colors.surface : "transparent"
                            radius: 4
                            border.color: colors.overlay
                            border.width: muteMouseArea.containsMouse ? 1 : 0

                            Text {
                                anchors.centerIn: parent
                                text: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? "󰝟" : "󰕾"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                color: volumeWidget.defaultSink && volumeWidget.defaultSink.audio && volumeWidget.defaultSink.audio.muted ? colors.red : colors.green
                            }

                            MouseArea {
                                id: muteMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (volumeWidget.defaultSink && volumeWidget.defaultSink.audio) {
                                        volumeWidget.defaultSink.audio.muted = !volumeWidget.defaultSink.audio.muted
                                    }
                                }
                            }
                        }
                    }
                }

                // Microphone controls
                Column {
                    width: parent.width
                    spacing: 8
                    visible: volumeWidget.defaultSource !== null

                    Text {
                        text: "🎤 " + (volumeWidget.defaultSource ? volumeWidget.defaultSource.description : "No Microphone")
                        color: colors.text
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Row {
                        width: parent.width
                        spacing: 12

                        // Volume percentage
                        Text {
                            width: 35
                            text: volumeWidget.defaultSource && volumeWidget.defaultSource.audio ? Math.round(volumeWidget.defaultSource.audio.volume * 100) + "%" : "0%"
                            color: colors.subtext
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignRight
                        }

                        // Volume slider
                        Rectangle {
                            width: parent.width - 35 - 24 - 24
                            height: 8
                            color: colors.surface
                            radius: 4
                            border.color: colors.overlay
                            border.width: 1

                            Rectangle {
                                height: parent.height
                                width: volumeWidget.defaultSource && volumeWidget.defaultSource.audio ? parent.width * volumeWidget.defaultSource.audio.volume : 0
                                color: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? colors.overlay : colors.mauve
                                radius: parent.radius
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: function(mouse) {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const newVolume = mouse.x / width
                                        volumeWidget.defaultSource.audio.volume = Math.max(0, Math.min(1, newVolume))
                                    }
                                }

                                onPositionChanged: function(mouse) {
                                    if (pressed && volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const newVolume = mouse.x / width
                                        volumeWidget.defaultSource.audio.volume = Math.max(0, Math.min(1, newVolume))
                                    }
                                }

                                onWheel: function(wheel) {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                                        const newVolume = Math.max(0, Math.min(1, volumeWidget.defaultSource.audio.volume + delta))
                                        volumeWidget.defaultSource.audio.volume = newVolume
                                    }
                                }
                            }
                        }

                        // Mute button
                        Rectangle {
                            width: 24
                            height: 24
                            color: micMuteMouseArea.containsMouse ? colors.surface : "transparent"
                            radius: 4
                            border.color: colors.overlay
                            border.width: micMuteMouseArea.containsMouse ? 1 : 0

                            Text {
                                anchors.centerIn: parent
                                text: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? "󰍭" : "󰍬"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                color: volumeWidget.defaultSource && volumeWidget.defaultSource.audio && volumeWidget.defaultSource.audio.muted ? colors.red : colors.green
                            }

                            MouseArea {
                                id: micMuteMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (volumeWidget.defaultSource && volumeWidget.defaultSource.audio) {
                                        volumeWidget.defaultSource.audio.muted = !volumeWidget.defaultSource.audio.muted
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
