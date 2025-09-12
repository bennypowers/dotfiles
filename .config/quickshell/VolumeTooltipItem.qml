import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Rectangle {
    id: tooltipItem

    property var colors
    property real iconSize: 18
    property real muteButtonSize: 20
    required property var node
    property real volumeSliderHeight: 6

    color: "transparent"  // No background for tooltip items
    radius: 6

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
            Layout.preferredHeight: tooltipItem.iconSize
            Layout.preferredWidth: tooltipItem.iconSize
            color: "transparent"

            Image {
                id: appIcon

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                height: tooltipItem.iconSize
                smooth: true
                source: {
                    if (!tooltipItem.node || !tooltipItem.node.properties)
                        return "";
                    const icon = tooltipItem.node.properties["application.icon-name"] ?? "audio-volume-high-symbolic";
                    return `image://icon/${icon}`;
                }
                width: tooltipItem.iconSize

                // Fallback text if icon fails to load
                Rectangle {
                    anchors.fill: parent
                    color: (tooltipItem.colors || defaultColors).blue
                    radius: 3
                    visible: appIcon.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 8
                        text: {
                            if (!tooltipItem.node)
                                return "?";
                            if (!tooltipItem.node.properties) {
                                return tooltipItem.node.name ? tooltipItem.node.name.charAt(0).toUpperCase() : "?";
                            }
                            const appName = tooltipItem.node.properties["application.name"] ?? tooltipItem.node.name;
                            return appName ? appName.charAt(0).toUpperCase() : "?";
                        }
                    }
                }
            }
        }

        // Volume percentage display
        Text {
            Layout.preferredWidth: 30
            color: (tooltipItem.colors || defaultColors).subtext
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 8
            horizontalAlignment: Text.AlignRight
            text: {
                if (!tooltipItem.node || !tooltipItem.node.audio)
                    return "0%";
                const volume = tooltipItem.node.audio.volume;
                if (isNaN(volume))
                    return "---";
                return `${Math.floor(volume * 100)}%`;
            }
        }

        // Volume slider (display only, no interaction)
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: tooltipItem.volumeSliderHeight
            Layout.preferredWidth: 60
            border.color: (tooltipItem.colors || defaultColors).overlay
            border.width: 1
            color: (tooltipItem.colors || defaultColors).surface
            radius: tooltipItem.volumeSliderHeight / 2

            Rectangle {
                id: volumeFill

                color: tooltipItem.node && tooltipItem.node.audio && tooltipItem.node.audio.muted ? (tooltipItem.colors || defaultColors).overlay : (tooltipItem.colors || defaultColors).mauve
                height: parent.height
                radius: parent.radius
                width: {
                    if (!tooltipItem.node || !tooltipItem.node.audio)
                        return 0;
                    const volume = tooltipItem.node.audio.volume;
                    if (isNaN(volume))
                        return 0;
                    return parent.width * volume;
                }
            }
        }

        // Mute button (display only, no interaction)
        Rectangle {
            Layout.preferredHeight: tooltipItem.muteButtonSize
            Layout.preferredWidth: tooltipItem.muteButtonSize
            color: "transparent"
            radius: 4

            Text {
                anchors.centerIn: parent
                color: {
                    if (!tooltipItem.node || !tooltipItem.node.audio)
                        return (tooltipItem.colors || defaultColors).overlay;
                    return tooltipItem.node.audio.muted ? (tooltipItem.colors || defaultColors).red : (tooltipItem.colors || defaultColors).green;
                }
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                text: {
                    if (!tooltipItem.node || !tooltipItem.node.audio)
                        return "󰝟";
                    return tooltipItem.node.audio.muted ? "󰝟" : "󰕾";
                }
            }
        }
    }
}
