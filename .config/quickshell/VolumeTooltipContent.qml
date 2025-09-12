pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "."

Rectangle {
    id: root

    property int animationDuration: 200
    required property var colors
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 10
    property real itemHeight: 40
    property real muteButtonSize: 20
    property real volumeSliderHeight: 6

    color: "transparent"
    height: 120
    width: 280

    MouseArea {
        id: tooltipMouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            checkExitTimer.stop();
            var tooltip = root.Window.window;
            if (tooltip && tooltip.hasOwnProperty('tooltipHovered')) {
                tooltip.tooltipHovered = true;
                if (tooltip.hideDelay)
                    tooltip.hideDelay.stop();
                if (tooltip.hideAnimation)
                    tooltip.hideAnimation.stop();
            }
        }
        onExited: {
            checkExitTimer.start();
        }

        Timer {
            id: checkExitTimer

            interval: 200
            repeat: true

            onTriggered: {
                if (!tooltipMouseArea.containsMouse) {
                    stop();
                    var tooltip = root.Window.window;
                    if (tooltip && tooltip.hasOwnProperty('tooltipHovered')) {
                        tooltip.tooltipHovered = false;
                        var triggerHovered = tooltip.triggerWidget ? tooltip.triggerWidget.hovered : false;
                        if (!tooltip.triggerWidget || !triggerHovered) {
                            tooltip.hide();
                        }
                    }
                }
            }
        }
    }
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].concat(Pipewire.objects || [])
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        VolumeControlItem {
            Layout.fillWidth: true
            Layout.preferredHeight: root.itemHeight
            animationDuration: root.animationDuration
            colors: root.colors
            deviceType: "🔊"
            fontFamily: root.fontFamily
            fontSize: root.fontSize
            muteButtonSize: root.muteButtonSize
            node: Pipewire.defaultAudioSink
            volumeSliderHeight: root.volumeSliderHeight
        }
        VolumeControlItem {
            Layout.fillWidth: true
            Layout.preferredHeight: root.itemHeight
            animationDuration: root.animationDuration
            colors: root.colors
            deviceType: "🎤"
            fontFamily: root.fontFamily
            fontSize: root.fontSize
            muteButtonSize: root.muteButtonSize
            node: Pipewire.defaultAudioSource
            volumeSliderHeight: root.volumeSliderHeight
        }
    }

    component VolumeControlItem: Rectangle {
        property int animationDuration: 200
        property var colors
        property string deviceType: ""
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 10
        property real muteButtonSize: 20
        property var node
        property real volumeSliderHeight: 6

        color: "transparent"
        radius: 4

        PwObjectTracker {
            objects: [node]
        }
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                Layout.preferredWidth: 60
                color: colors.text
                font.family: fontFamily
                font.pixelSize: fontSize
                text: deviceType + " " + (node ? Math.round(node.audio?.volume * 100 || 0) + "%" : "N/A")
            }
            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.preferredHeight: volumeSliderHeight
                border.color: colors.overlay
                border.width: 1
                color: colors.surface
                radius: volumeSliderHeight / 2

                Rectangle {
                    color: node && node.audio && node.audio.muted ? colors.overlay : colors.mauve
                    height: parent.height
                    radius: parent.radius
                    width: node && node.audio ? parent.width * node.audio.volume : 0

                    Behavior on color {
                        ColorAnimation {
                            duration: animationDuration
                        }
                    }
                    Behavior on width {
                        NumberAnimation {
                            duration: animationDuration
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: function (mouse) {
                        if (node && node.audio) {
                            const newVolume = mouse.x / width;
                            node.audio.volume = Math.max(0, Math.min(1, newVolume));
                        }
                    }
                    onWheel: function (wheel) {
                        if (node && node.audio) {
                            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                            const newVolume = Math.max(0, Math.min(1, node.audio.volume + delta));
                            node.audio.volume = newVolume;
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredHeight: muteButtonSize
                Layout.preferredWidth: muteButtonSize
                border.color: colors.overlay
                border.width: muteMouseArea.containsMouse ? 1 : 0
                color: muteMouseArea.containsMouse ? colors.surface : "transparent"
                radius: 4

                Behavior on color {
                    ColorAnimation {
                        duration: animationDuration
                    }
                }

                Text {
                    anchors.centerIn: parent
                    color: {
                        if (!node || !node.audio)
                            return colors.overlay;
                        return node.audio.muted ? colors.red : colors.green;
                    }
                    font.family: fontFamily
                    font.pixelSize: fontSize
                    text: {
                        if (!node || !node.audio)
                            return "󰝟";
                        if (deviceType === "🎤") {
                            return node.audio.muted ? "󰍭" : "󰍬";
                        } else {
                            return node.audio.muted ? "󰝟" : "󰕾";
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: animationDuration
                        }
                    }
                }
                MouseArea {
                    id: muteMouseArea

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        if (node && node.audio) {
                            node.audio.muted = !node.audio.muted;
                        }
                    }
                }
            }
        }
    }
}
