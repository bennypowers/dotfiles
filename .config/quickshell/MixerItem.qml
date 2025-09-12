import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

Rectangle {
    id: mixerItem

    property int animationDuration: 200
    property real iconSize: 20
    property real muteButtonSize: 24
    required property var node
    property real volumeSliderHeight: 8

    border.color: colors.overlay
    border.width: mouseArea.containsMouse ? 1 : 0
    color: mouseArea.containsMouse ? colors.surface : "transparent"
    radius: 6

    Behavior on border.width {
        NumberAnimation {
            duration: mixerItem.animationDuration
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: mixerItem.animationDuration
        }
    }

    Colors {
        id: colors

    }

    // Bind the node so we can read its properties
    PwObjectTracker {
        objects: [node]
    }
    MouseArea {
        id: mouseArea

        acceptedButtons: Qt.NoButton  // Don't consume button events
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        // Application icon
        Rectangle {
            Layout.preferredHeight: mixerItem.iconSize
            Layout.preferredWidth: mixerItem.iconSize
            color: "transparent"

            Image {
                id: appIcon

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                height: mixerItem.iconSize
                smooth: true
                source: {
                    if (!mixerItem.node || !mixerItem.node.properties)
                        return "";
                    const icon = mixerItem.node.properties["application.icon-name"] ?? "audio-volume-high-symbolic";
                    return `image://icon/${icon}`;
                }
                width: mixerItem.iconSize

                // Fallback text if icon fails to load
                Rectangle {
                    anchors.fill: parent
                    color: colors.blue
                    radius: 3
                    visible: appIcon.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        text: {
                            if (!mixerItem.node)
                                return "?";
                            if (!mixerItem.node.properties) {
                                return mixerItem.node.name ? mixerItem.node.name.charAt(0).toUpperCase() : "?";
                            }
                            const appName = mixerItem.node.properties["application.name"] ?? mixerItem.node.name;
                            return appName ? appName.charAt(0).toUpperCase() : "?";
                        }
                    }
                }
            }
        }

        // Application name and media info
        Column {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 2

            Text {
                color: colors.text
                elide: Text.ElideRight
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                text: {
                    if (!mixerItem.node)
                        return "Unknown";

                    // Determine device type and name
                    var deviceType = "";
                    var deviceName = "";

                    if (mixerItem.node.isSource) {
                        deviceType = "🎤 ";  // Microphone icon for input
                    } else if (mixerItem.node.isSink) {
                        deviceType = "🔊 ";  // Speaker icon for output
                    }

                    if (!mixerItem.node.properties) {
                        deviceName = mixerItem.node.description || mixerItem.node.name || "Unknown";
                    } else {
                        const app = mixerItem.node.properties["application.name"] ?? (mixerItem.node.description !== "" ? mixerItem.node.description : mixerItem.node.name);
                        const media = mixerItem.node.properties["media.name"];
                        deviceName = media !== undefined && media !== "" ? `${app}` : app;
                    }

                    return deviceType + deviceName;
                }
                width: parent.width
            }
            Text {
                color: colors.subtext
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 8
                text: {
                    if (!mixerItem.node || !mixerItem.node.properties)
                        return "";
                    const media = mixerItem.node.properties["media.name"];
                    return media !== undefined && media !== "" ? media : "";
                }
                visible: text !== ""
                width: parent.width
            }
        }

        // Volume percentage display
        Text {
            Layout.preferredWidth: 35
            color: colors.subtext
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 9
            horizontalAlignment: Text.AlignRight
            text: {
                if (!mixerItem.node || !mixerItem.node.audio)
                    return "0%";
                const volume = mixerItem.node.audio.volume;
                if (isNaN(volume))
                    return "---";
                return `${Math.floor(volume * 100)}%`;
            }
        }

        // Volume slider
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: mixerItem.volumeSliderHeight
            Layout.preferredWidth: 80
            border.color: colors.overlay
            border.width: 1
            color: colors.surface
            radius: mixerItem.volumeSliderHeight / 2

            Rectangle {
                id: volumeFill

                color: mixerItem.node && mixerItem.node.audio && mixerItem.node.audio.muted ? colors.overlay : colors.mauve
                height: parent.height
                radius: parent.radius
                width: {
                    if (!mixerItem.node || !mixerItem.node.audio)
                        return 0;
                    const volume = mixerItem.node.audio.volume;
                    if (isNaN(volume))
                        return 0;
                    return parent.width * volume;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: mixerItem.animationDuration
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: mixerItem.animationDuration
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                hoverEnabled: true
                propagateComposedEvents: true

                onClicked: function (mouse) {
                    if (mixerItem.node && mixerItem.node.audio) {
                        const newVolume = mouse.x / width;
                        mixerItem.node.audio.volume = Math.max(0, Math.min(1, newVolume));
                    }
                }
                onEntered: {
                    // Find the tooltip in the parent MixerWidget
                    var mixerWidget = mixerItem.parent;
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent;
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        var tooltipWidth = 200;
                        var tooltipHeight = 60;
                        var widgetCenter = mixerItem.mapToGlobal(mixerItem.width / 2, mixerItem.height / 2);
                        var widgetLeftEdge = mixerItem.mapToGlobal(0, mixerItem.height / 2);

                        var tooltipX = widgetLeftEdge.x - tooltipWidth;
                        var tooltipY = widgetCenter.y - tooltipHeight / 2;

                        mixerWidget.tooltip.showAt(tooltipX, tooltipY, "Click to set volume, scroll to adjust", "right", tooltipWidth, tooltipHeight / 2);
                    }
                }
                onExited: {
                    var mixerWidget = mixerItem.parent;
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent;
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        mixerWidget.tooltip.hide();
                    }
                }
                onWheel: function (wheel) {
                    if (mixerItem.node && mixerItem.node.audio) {
                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                        const newVolume = Math.max(0, Math.min(1, mixerItem.node.audio.volume + delta));
                        mixerItem.node.audio.volume = newVolume;
                    }
                }
            }
        }

        // Mute button
        Rectangle {
            Layout.preferredHeight: mixerItem.muteButtonSize
            Layout.preferredWidth: mixerItem.muteButtonSize
            border.color: colors.overlay
            border.width: muteMouseArea.containsMouse ? 1 : 0
            color: muteMouseArea.containsMouse ? colors.surface : "transparent"
            radius: 4

            Behavior on color {
                ColorAnimation {
                    duration: mixerItem.animationDuration
                }
            }

            Text {
                anchors.centerIn: parent
                color: {
                    if (!mixerItem.node || !mixerItem.node.audio)
                        return colors.overlay;
                    return mixerItem.node.audio.muted ? colors.red : colors.green;
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                text: {
                    if (!mixerItem.node || !mixerItem.node.audio)
                        return "󰝟";
                    return mixerItem.node.audio.muted ? "󰝟" : "󰕾";
                }

                Behavior on color {
                    ColorAnimation {
                        duration: mixerItem.animationDuration
                    }
                }
            }
            MouseArea {
                id: muteMouseArea

                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true

                onClicked: {
                    if (mixerItem.node && mixerItem.node.audio) {
                        mixerItem.node.audio.muted = !mixerItem.node.audio.muted;
                    }
                }
                onEntered: {
                    var mixerWidget = mixerItem.parent;
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent;
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        var tooltipWidth = 200;
                        var tooltipHeight = 60;
                        var widgetCenter = mixerItem.mapToGlobal(mixerItem.width / 2, mixerItem.height / 2);
                        var widgetLeftEdge = mixerItem.mapToGlobal(0, mixerItem.height / 2);

                        var tooltipX = widgetLeftEdge.x - tooltipWidth;
                        var tooltipY = widgetCenter.y - tooltipHeight / 2;

                        var tooltipText = mixerItem.node && mixerItem.node.audio && mixerItem.node.audio.muted ? "Click to unmute" : "Click to mute";
                        mixerWidget.tooltip.showAt(tooltipX, tooltipY, tooltipText, "right", tooltipWidth, tooltipHeight / 2);
                    }
                }
                onExited: {
                    var mixerWidget = mixerItem.parent;
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent;
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        mixerWidget.tooltip.hide();
                    }
                }
            }
        }
    }
}
