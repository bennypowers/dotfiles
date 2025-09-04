import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Rectangle {
    id: languageWidget
    height: 40
    color: "transparent"
    radius: 8

    property string currentLayout: "A"
    property string mainKeyboard: "diego-palacios-cantor-keyboard"

    Colors {
        id: colors
    }

    // Listen to Hyprland raw events
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            switch (event.name) {
                case "activelayout": {
                  const [, layoutName] = event.data.split(",")
                  languageWidget.updateLayoutDisplay(layoutName)
                }
            }
        }
    }

    // Get initial layout state
    Process {
        id: hyprctlProcess
        command: ["hyprctl", "devices", "-j"]
        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                try {
                    if (stdout && stdout.trim()) {
                        const devices = JSON.parse(stdout)
                        if (devices.keyboards && devices.keyboards.length > 0) {
                            const mainKeyboard = devices.keyboards.find(kb => kb.name === languageWidget.mainKeyboard) || devices.keyboards[0]
                            const activeLayout = mainKeyboard.active_keymap || "English (US)"
                            languageWidget.updateLayoutDisplay(activeLayout)
                        }
                    }
                } catch (e) {
                    console.log("❌ LanguageWidget Failed to parse hyprctl output:", e)
                    console.log("📄 Raw output:", stdout)
                }
            }
        }
    }

    function updateLayoutDisplay(layoutName) {
        // Map layout names to short codes
        if (layoutName.includes("English")) {
            currentLayout = "A"
        } else if (layoutName.includes("Hebrew")) {
            currentLayout = "א"
        } else {
            console.log("❓ Unknown layout, setting to ??")
            currentLayout = "??"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            switchProcess.running = true
        }
        hoverEnabled: true

        onEntered: {
            parent.color = colors.surface
        }

        onExited: {
            parent.color = "transparent"
        }
    }

    Text {
        anchors.centerIn: parent
        text: languageWidget.currentLayout
        color: colors.text
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: colors.iconSize
        font.bold: true
    }

    Process {
        id: switchProcess
        command: ["hyprctl", "switchxkblayout", "diego-palacios-cantor-keyboard", "next"]
    }

    Component.onCompleted: {
        // Get initial layout
        hyprctlProcess.running = true
    }
}
