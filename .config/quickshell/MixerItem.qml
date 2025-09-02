import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

Rectangle {
    id: mixerItem
    color: mouseArea.containsMouse ? colors.surface : "transparent"
    radius: 6
    border.color: colors.overlay
    border.width: mouseArea.containsMouse ? 1 : 0

    required property var node
    property real iconSize: 20
    property real volumeSliderHeight: 8
    property real muteButtonSize: 24
    property int animationDuration: 200

    Colors {
        id: colors
    }

    // Smart anchor utility
    SmartAnchor {
        id: smartAnchor
    }

    // Bind the node so we can read its properties
    PwObjectTracker { 
        objects: [node] 
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Behavior on color {
        ColorAnimation { duration: mixerItem.animationDuration }
    }

    Behavior on border.width {
        NumberAnimation { duration: mixerItem.animationDuration }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        // Application icon
        Rectangle {
            Layout.preferredWidth: mixerItem.iconSize
            Layout.preferredHeight: mixerItem.iconSize
            color: "transparent"

            Image {
                id: appIcon
                anchors.centerIn: parent
                width: mixerItem.iconSize
                height: mixerItem.iconSize
                smooth: true
                fillMode: Image.PreserveAspectFit

                source: {
                    if (!mixerItem.node || !mixerItem.node.properties) return ""
                    const icon = mixerItem.node.properties["application.icon-name"] ?? "audio-volume-high-symbolic"
                    return `image://icon/${icon}`
                }

                // Fallback text if icon fails to load
                Rectangle {
                    anchors.fill: parent
                    color: colors.blue
                    radius: 3
                    visible: appIcon.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        text: {
                            if (!mixerItem.node) return "?"
                            if (!mixerItem.node.properties) {
                                return mixerItem.node.name ? mixerItem.node.name.charAt(0).toUpperCase() : "?"
                            }
                            const appName = mixerItem.node.properties["application.name"] ?? mixerItem.node.name
                            return appName ? appName.charAt(0).toUpperCase() : "?"
                        }
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        // Application name and media info
        Column {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                width: parent.width
                text: {
                    if (!mixerItem.node) return "Unknown"

                    // Determine device type and name
                    var deviceType = ""
                    var deviceName = ""

                    if (mixerItem.node.isSource) {
                        deviceType = "🎤 "  // Microphone icon for input
                    } else if (mixerItem.node.isSink) {
                        deviceType = "🔊 "  // Speaker icon for output
                    }

                    if (!mixerItem.node.properties) {
                        deviceName = mixerItem.node.description || mixerItem.node.name || "Unknown"
                    } else {
                        const app = mixerItem.node.properties["application.name"] ?? 
                                   (mixerItem.node.description !== "" ? mixerItem.node.description : mixerItem.node.name)
                        const media = mixerItem.node.properties["media.name"]
                        deviceName = media !== undefined && media !== "" ? `${app}` : app
                    }

                    return deviceType + deviceName
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                font.bold: true
                color: colors.text
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: {
                    if (!mixerItem.node || !mixerItem.node.properties) return ""
                    const media = mixerItem.node.properties["media.name"]
                    return media !== undefined && media !== "" ? media : ""
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 8
                color: colors.subtext
                elide: Text.ElideRight
                visible: text !== ""
            }
        }

        // Volume percentage display
        Text {
            Layout.preferredWidth: 35
            text: {
                if (!mixerItem.node || !mixerItem.node.audio) return "0%"
                const volume = mixerItem.node.audio.volume
                if (isNaN(volume)) return "---"
                return `${Math.floor(volume * 100)}%`
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 9
            color: colors.subtext
            horizontalAlignment: Text.AlignRight
        }

        // Volume slider
        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: mixerItem.volumeSliderHeight
            Layout.alignment: Qt.AlignVCenter
            color: colors.surface
            radius: mixerItem.volumeSliderHeight / 2
            border.color: colors.overlay
            border.width: 1

            Rectangle {
                id: volumeFill
                height: parent.height
                width: {
                    if (!mixerItem.node || !mixerItem.node.audio) return 0
                    const volume = mixerItem.node.audio.volume
                    if (isNaN(volume)) return 0
                    return parent.width * volume
                }
                color: mixerItem.node && mixerItem.node.audio && mixerItem.node.audio.muted ? colors.overlay : colors.mauve
                radius: parent.radius

                Behavior on width {
                    NumberAnimation { duration: mixerItem.animationDuration }
                }

                Behavior on color {
                    ColorAnimation { duration: mixerItem.animationDuration }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: function(mouse) {
                    if (mixerItem.node && mixerItem.node.audio) {
                        const newVolume = mouse.x / width
                        mixerItem.node.audio.volume = Math.max(0, Math.min(1, newVolume))
                    }
                }

                onWheel: function(wheel) {
                    if (mixerItem.node && mixerItem.node.audio) {
                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                        const newVolume = Math.max(0, Math.min(1, mixerItem.node.audio.volume + delta))
                        mixerItem.node.audio.volume = newVolume
                    }
                }

                hoverEnabled: true
                onEntered: {
                    // Find the tooltip in the parent MixerWidget
                    var mixerWidget = mixerItem.parent
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        var anchorInfo = smartAnchor.calculateTooltipPosition(mixerItem, 200, 60)
                        mixerWidget.tooltip.showAt(anchorInfo.x, anchorInfo.y, "Click to set volume, scroll to adjust")
                    }
                }
                onExited: {
                    var mixerWidget = mixerItem.parent
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        mixerWidget.tooltip.hide()
                    }
                }
            }
        }

        // Mute button
        Rectangle {
            Layout.preferredWidth: mixerItem.muteButtonSize
            Layout.preferredHeight: mixerItem.muteButtonSize
            color: muteMouseArea.containsMouse ? colors.surface : "transparent"
            radius: 4
            border.color: colors.overlay
            border.width: muteMouseArea.containsMouse ? 1 : 0

            Behavior on color {
                ColorAnimation { duration: mixerItem.animationDuration }
            }

            Text {
                anchors.centerIn: parent
                text: {
                    if (!mixerItem.node || !mixerItem.node.audio) return "󰝟"
                    return mixerItem.node.audio.muted ? "󰝟" : "󰕾"
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                color: {
                    if (!mixerItem.node || !mixerItem.node.audio) return colors.overlay
                    return mixerItem.node.audio.muted ? colors.red : colors.green
                }

                Behavior on color {
                    ColorAnimation { duration: mixerItem.animationDuration }
                }
            }

            MouseArea {
                id: muteMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (mixerItem.node && mixerItem.node.audio) {
                        mixerItem.node.audio.muted = !mixerItem.node.audio.muted
                    }
                }

                onEntered: {
                    var mixerWidget = mixerItem.parent
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        var anchorInfo = smartAnchor.calculateTooltipPosition(mixerItem, 200, 60)
                        var tooltipText = mixerItem.node && mixerItem.node.audio && mixerItem.node.audio.muted ? 
                                "Click to unmute" : "Click to mute"
                        mixerWidget.tooltip.showAt(anchorInfo.x, anchorInfo.y, tooltipText)
                    }
                }
                onExited: {
                    var mixerWidget = mixerItem.parent
                    while (mixerWidget && !mixerWidget.hasOwnProperty('tooltip')) {
                        mixerWidget = mixerWidget.parent
                    }
                    if (mixerWidget && mixerWidget.tooltip) {
                        mixerWidget.tooltip.hide()
                    }
                }
            }
        }
    }
}
