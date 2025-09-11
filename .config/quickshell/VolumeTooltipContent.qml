pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "."

Item {
    id: root
    width: 280
    height: 120
    
    required property var colors
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 12
    property string textColor: "#cdd6f4"
    
    Component.onCompleted: {
        console.log("VolumeTooltipContent created, width:", width, "height:", height)
        console.log("Sink available:", Pipewire.defaultAudioSink !== null)
        console.log("Source available:", Pipewire.defaultAudioSource !== null)
    }
    
    onWidthChanged: console.log("VolumeTooltipContent width changed:", width)
    onHeightChanged: console.log("VolumeTooltipContent height changed:", height)
    
    
    // Overall hover area to keep tooltip open and handle all interactions
    MouseArea {
        id: self
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        
        Component.onCompleted: {
            console.log("MouseArea dimensions - width:", width, "height:", height)
            console.log("MouseArea position - x:", x, "y:", y)
        }
        
        onWidthChanged: console.log("MouseArea width changed:", width)
        onHeightChanged: console.log("MouseArea height changed:", height)
        
        onEntered: {
            console.log("VolumeTooltipContent MouseArea entered")
            // Stop the check timer and let tooltip handle hover state
            checkExitTimer.stop()
            // Access the tooltip window through the Window object
            var tooltip = root.Window.window
            if (tooltip && tooltip.hasOwnProperty('tooltipHovered')) {
                console.log("Setting tooltipHovered to true")
                tooltip.tooltipHovered = true
                if (tooltip.hideDelay) tooltip.hideDelay.stop()
                if (tooltip.hideAnimation) tooltip.hideAnimation.stop()
            }
        }
        
        onExited: {
            console.log("VolumeTooltipContent MouseArea exited - starting check timer")
            checkExitTimer.start()
        }
        
        
        Timer {
            id: checkExitTimer
            interval: 200
            repeat: true
            onTriggered: {
                // Check if mouse is still inside this MouseArea
                if (!self.containsMouse) {
                    console.log("Mouse confirmed outside tooltip - using proper hide mechanism")
                    stop()
                    var tooltip = root.Window.window
                    if (tooltip && tooltip.hasOwnProperty('tooltipHovered')) {
                        tooltip.tooltipHovered = false
                        var triggerHovered = tooltip.triggerWidget ? tooltip.triggerWidget.hovered : false
                        if (!tooltip.triggerWidget || !triggerHovered) {
                            console.log("Delegating to tooltip's hide system")
                            // Let the tooltip handle its own delay and animation
                            tooltip.hide()
                        }
                    }
                } else {
                    console.log("Mouse still in tooltip - keeping open")
                }
            }
        }
        
        onClicked: function(mouse) {
            // Determine which control was clicked based on mouse position
            if (mouse.y >= 25 && mouse.y <= 65) { // Speaker area
                if (mouse.x >= 68 && mouse.x <= 218) { // Volume slider area
                    if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                        const newVolume = (mouse.x - 68) / 150
                        Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, newVolume))
                    }
                } else if (mouse.x >= 238 && mouse.x <= 258) { // Mute button area
                    if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                        Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
                    }
                }
            } else if (mouse.y >= 73 && mouse.y <= 113) { // Microphone area
                if (mouse.x >= 68 && mouse.x <= 218) { // Volume slider area
                    if (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio) {
                        const newVolume = (mouse.x - 68) / 150
                        Pipewire.defaultAudioSource.audio.volume = Math.max(0, Math.min(1, newVolume))
                    }
                } else if (mouse.x >= 238 && mouse.x <= 258) { // Mute button area
                    if (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio) {
                        Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted
                    }
                }
            }
        }
        
        onWheel: function(wheel) {
            // Determine which control to adjust based on wheel position
            if (wheel.y >= 25 && wheel.y <= 65) { // Speaker area
                if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                    const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                    const newVolume = Math.max(0, Math.min(1, Pipewire.defaultAudioSink.audio.volume + delta))
                    Pipewire.defaultAudioSink.audio.volume = newVolume
                }
            } else if (wheel.y >= 73 && wheel.y <= 113) { // Microphone area
                if (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio) {
                    const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                    const newVolume = Math.max(0, Math.min(1, Pipewire.defaultAudioSource.audio.volume + delta))
                    Pipewire.defaultAudioSource.audio.volume = newVolume
                }
            }
        }
    }

Column {
    anchors.fill: parent
    spacing: 8
    
    Component.onCompleted: {
        console.log("Column dimensions - width:", width, "height:", height)
        console.log("Column position - x:", x, "y:", y)
    }
    
    onWidthChanged: console.log("Column width changed:", width)
    onHeightChanged: console.log("Column height changed:", height)

    // Track all Pipewire objects and default devices
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource
        ].concat(Pipewire.objects || [])
    }

    // Header
    Text {
        text: "🎚️ Audio Mixer"
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        font.bold: true
        color: root.textColor
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Speaker control
    Rectangle {
        width: 280
        height: 40
        color: "transparent"
        border.color: root.colors.overlay
        border.width: 1
        radius: 4
        
        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8
            
            Text {
                width: 60
                anchors.verticalCenter: parent.verticalCenter
                text: "🔊 " + (Pipewire.defaultAudioSink ? Math.round(Pipewire.defaultAudioSink.audio?.volume * 100 || 0) + "%" : "N/A")
                color: root.textColor
                font.pixelSize: 10
            }
            
            // Volume slider
            Rectangle {
                width: 150
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                color: root.colors.surface
                radius: 3
                border.color: root.colors.overlay
                border.width: 1
                
                Rectangle {
                    height: parent.height
                    width: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio ? parent.width * Pipewire.defaultAudioSink.audio.volume : 0
                    color: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio && Pipewire.defaultAudioSink.audio.muted ? root.colors.overlay : root.colors.mauve
                    radius: parent.radius
                }
                
            }
            
            // Mute button
            Rectangle {
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                radius: 4
                border.color: root.colors.overlay
                border.width: 0
                
                Text {
                    anchors.centerIn: parent
                    text: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio && Pipewire.defaultAudioSink.audio.muted ? "󰝟" : "󰕾"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 10
                    color: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio && Pipewire.defaultAudioSink.audio.muted ? root.colors.red : root.colors.green
                }
                
            }
        }
    }

    // Microphone control  
    Rectangle {
        width: 280
        height: 40
        color: "transparent"
        border.color: root.colors.overlay
        border.width: 1
        radius: 4
        
        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8
            
            Text {
                width: 60
                anchors.verticalCenter: parent.verticalCenter
                text: "🎤 " + (Pipewire.defaultAudioSource ? Math.round(Pipewire.defaultAudioSource.audio?.volume * 100 || 0) + "%" : "N/A")
                color: root.textColor
                font.pixelSize: 10
            }
            
            // Volume slider
            Rectangle {
                width: 150
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                color: root.colors.surface
                radius: 3
                border.color: root.colors.overlay
                border.width: 1
                
                Rectangle {
                    height: parent.height
                    width: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio ? parent.width * Pipewire.defaultAudioSource.audio.volume : 0
                    color: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio && Pipewire.defaultAudioSource.audio.muted ? root.colors.overlay : root.colors.green
                    radius: parent.radius
                }
                
            }
            
            // Mute button
            Rectangle {
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                radius: 4
                border.color: root.colors.overlay
                border.width: 0
                
                Text {
                    anchors.centerIn: parent
                    text: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio && Pipewire.defaultAudioSource.audio.muted ? "󰍭" : "󰍬"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 10
                    color: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio && Pipewire.defaultAudioSource.audio.muted ? root.colors.red : root.colors.green
                }
                
            }
        }
    }
}
}