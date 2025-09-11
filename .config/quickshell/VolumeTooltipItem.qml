import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Rectangle {
    id: tooltipItem
    color: "transparent"  // No background for tooltip items
    radius: 6

    required property var node
    property real iconSize: 18
    property real volumeSliderHeight: 6
    property real muteButtonSize: 20
    property var colors

    Colors {
        id: defaultColors
    }

    // Bind the node so we can read its properties
    PwObjectTracker { 
        objects: [node] 
    }

    // No MouseArea here to avoid hover conflicts with tooltip

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 10

        // Application icon
        Rectangle {
            Layout.preferredWidth: tooltipItem.iconSize
            Layout.preferredHeight: tooltipItem.iconSize
            color: "transparent"

            Image {
                id: appIcon
                anchors.centerIn: parent
                width: tooltipItem.iconSize
                height: tooltipItem.iconSize
                smooth: true
                fillMode: Image.PreserveAspectFit

                source: {
                    if (!tooltipItem.node || !tooltipItem.node.properties) return ""
                    const icon = tooltipItem.node.properties["application.icon-name"] ?? "audio-volume-high-symbolic"
                    return `image://icon/${icon}`
                }

                // Fallback text if icon fails to load
                Rectangle {
                    anchors.fill: parent
                    color: (tooltipItem.colors || defaultColors).blue
                    radius: 3
                    visible: appIcon.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        text: {
                            if (!tooltipItem.node) return "?"
                            if (!tooltipItem.node.properties) {
                                return tooltipItem.node.name ? tooltipItem.node.name.charAt(0).toUpperCase() : "?"
                            }
                            const appName = tooltipItem.node.properties["application.name"] ?? tooltipItem.node.name
                            return appName ? appName.charAt(0).toUpperCase() : "?"
                        }
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 8
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
            spacing: 1

            Text {
                width: parent.width
                text: {
                    if (!tooltipItem.node) return "Unknown"

                    // Determine device type and name
                    var deviceType = ""
                    var deviceName = ""

                    if (tooltipItem.node.isSource) {
                        deviceType = "🎤 "  // Microphone icon for input
                    } else if (tooltipItem.node.isSink) {
                        deviceType = "🔊 "  // Speaker icon for output
                    }

                    if (!tooltipItem.node.properties) {
                        deviceName = tooltipItem.node.description || tooltipItem.node.name || "Unknown"
                    } else {
                        const app = tooltipItem.node.properties["application.name"] ?? 
                                   (tooltipItem.node.description !== "" ? tooltipItem.node.description : tooltipItem.node.name)
                        const media = tooltipItem.node.properties["media.name"]
                        deviceName = media !== undefined && media !== "" ? `${app}` : app
                    }

                    return deviceType + deviceName
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 9
                font.bold: true
                color: (tooltipItem.colors || defaultColors).text
                elide: Text.ElideRight
            }
        }

        // Volume percentage display
        Text {
            Layout.preferredWidth: 30
            text: {
                if (!tooltipItem.node || !tooltipItem.node.audio) return "0%"
                const volume = tooltipItem.node.audio.volume
                if (isNaN(volume)) return "---"
                return `${Math.floor(volume * 100)}%`
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 8
            color: (tooltipItem.colors || defaultColors).subtext
            horizontalAlignment: Text.AlignRight
        }

        // Volume slider (display only, no interaction)
        Rectangle {
            Layout.preferredWidth: 60
            Layout.preferredHeight: tooltipItem.volumeSliderHeight
            Layout.alignment: Qt.AlignVCenter
            color: (tooltipItem.colors || defaultColors).surface
            radius: tooltipItem.volumeSliderHeight / 2
            border.color: (tooltipItem.colors || defaultColors).overlay
            border.width: 1

            Rectangle {
                id: volumeFill
                height: parent.height
                width: {
                    if (!tooltipItem.node || !tooltipItem.node.audio) return 0
                    const volume = tooltipItem.node.audio.volume
                    if (isNaN(volume)) return 0
                    return parent.width * volume
                }
                color: tooltipItem.node && tooltipItem.node.audio && tooltipItem.node.audio.muted ? 
                       (tooltipItem.colors || defaultColors).overlay : (tooltipItem.colors || defaultColors).mauve
                radius: parent.radius
            }
        }

        // Mute button (display only, no interaction)
        Rectangle {
            Layout.preferredWidth: tooltipItem.muteButtonSize
            Layout.preferredHeight: tooltipItem.muteButtonSize
            color: "transparent"
            radius: 4

            Text {
                anchors.centerIn: parent
                text: {
                    if (!tooltipItem.node || !tooltipItem.node.audio) return "󰝟"
                    return tooltipItem.node.audio.muted ? "󰝟" : "󰕾"
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                color: {
                    if (!tooltipItem.node || !tooltipItem.node.audio) return (tooltipItem.colors || defaultColors).overlay
                    return tooltipItem.node.audio.muted ? (tooltipItem.colors || defaultColors).red : (tooltipItem.colors || defaultColors).green
                }
            }
        }
    }
}