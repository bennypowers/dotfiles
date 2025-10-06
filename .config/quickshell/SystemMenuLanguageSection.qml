import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

Column {
    id: languageSection

    property string currentLayout: "A"
    property var languages: [
        { glyph: "A", name: "English (US)", color: colors.blue, layoutKey: "English" },
        { glyph: "א", name: "Hebrew", color: colors.green, layoutKey: "Hebrew" }
    ]
    property string mainKeyboard: "diego-palacios-cantor-keyboard"

    function updateLayoutDisplay(layoutName) {
        if (layoutName.includes("English")) {
            currentLayout = "A"
        } else if (layoutName.includes("Hebrew")) {
            currentLayout = "א"
        } else {
            currentLayout = "??"
        }
    }

    function switchLayout() {
        switchProcess.running = true
    }

    spacing: 0

    Component.onCompleted: {
        hyprctlProcess.running = true
    }

    Colors {
        id: colors
    }

    // Listen to Hyprland raw events for layout changes
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const [, layoutName] = event.data.split(",")
                languageSection.updateLayoutDisplay(layoutName)
            }
        }
    }

    // Get initial layout state
    Process {
        id: hyprctlProcess

        command: ["/bin/bash", "-c", `hyprctl devices -j | jq -r '.keyboards[] | select(.name == "${mainKeyboard}") | .active_keymap'`]
        running: false

        stdout: SplitParser {
            onRead: function (data) {
                const layout = data.trim()
                languageSection.updateLayoutDisplay(layout)
            }
        }
    }

    // Switch layout process
    Process {
        id: switchProcess

        command: ["/bin/bash", "-c", `hyprctl switchxkblayout ${mainKeyboard} next`]
        running: false
    }

    // Action button style
    Rectangle {
        width: parent.width
        height: 64
        radius: 12
        color: languageMouseArea.containsMouse ? colors.surface : colors.mantle

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // Current layout glyph
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                radius: 18
                color: currentLayout === "A" ? colors.blue : colors.green

                Text {
                    anchors.centerIn: parent
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    font.bold: true
                    text: currentLayout
                }
            }

            // Layout name
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    color: colors.text
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.bold: true
                    text: currentLayout === "A" ? "English (US)" : currentLayout === "א" ? "Hebrew" : "Unknown"
                }

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: "Keyboard"
                }
            }

            Item {
                width: parent.width - 200
                height: 1
            }

            // Chevron
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: "󰅂"
            }
        }

        MouseArea {
            id: languageMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                languageSection.switchLayout()
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}
