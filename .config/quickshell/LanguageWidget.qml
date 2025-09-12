import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Rectangle {
    id: languageWidget

    property string currentLayout: "A"

    // Languages configuration array for easy maintenance
    property var languages: [
        {
            glyph: "A",
            name: "English (US)",
            color: colors.blue,
            layoutKey: "English"
        },
        {
            glyph: "א",
            name: "Hebrew",
            color: colors.green,
            layoutKey: "Hebrew"
        }
    ]
    property string mainKeyboard: "diego-palacios-cantor-keyboard"

    function generateTooltipText() {
        let text = `<b>Keyboard Layout</b><br/>`;

        if (currentLayout === "A") {
            text += `<b>Current:</b> English (US)<br/>`;
            text += `<b>Next:</b> Hebrew`;
        } else if (currentLayout === "א") {
            text += `<b>Current:</b> Hebrew<br/>`;
            text += `<b>Next:</b> English (US)`;
        } else {
            text += `<b>Current:</b> Unknown<br/>`;
            text += `<b>Action:</b> Click to switch`;
        }

        text += `<br/><br/><b>Click to switch layouts</b>`;

        return text;
    }
    function updateLayoutDisplay(layoutName) {
        // Map layout names to short codes
        if (layoutName.includes("English")) {
            currentLayout = "A";
        } else if (layoutName.includes("Hebrew")) {
            currentLayout = "א";
        } else {
            console.log("❓ Unknown layout, setting to ??");
            currentLayout = "??";
        }

        // Update tooltip content if it exists
        if (tooltip.contentItem) {
            tooltip.contentItem.currentLayout = currentLayout;
        }
    }

    color: "transparent"
    height: 40
    radius: 8

    Component.onCompleted: {
        // Get initial layout
        hyprctlProcess.running = true;
    }

    Colors {
        id: colors

    }
    Tooltip {
        id: tooltip

    }

    // Listen to Hyprland raw events
    Connections {
        function onRawEvent(event) {
            switch (event.name) {
            case "activelayout":
                {
                    const [, layoutName] = event.data.split(",");
                    languageWidget.updateLayoutDisplay(layoutName);
                }
            }
        }

        target: Hyprland
    }

    // Get initial layout state
    Process {
        id: hyprctlProcess

        command: ["hyprctl", "devices", "-j"]

        onExited: function (exitCode, exitStatus) {
            if (exitCode === 0) {
                try {
                    if (stdout && stdout.trim()) {
                        const devices = JSON.parse(stdout);
                        if (devices.keyboards && devices.keyboards.length > 0) {
                            const mainKeyboard = devices.keyboards.find(kb => kb.name === languageWidget.mainKeyboard) || devices.keyboards[0];
                            const activeLayout = mainKeyboard.active_keymap || "English (US)";
                            languageWidget.updateLayoutDisplay(activeLayout);
                        }
                    }
                } catch (e) {
                    console.log("❌ LanguageWidget Failed to parse hyprctl output:", e);
                    console.log("📄 Raw output:", stdout);
                }
            }
        }
    }
    MouseArea {
        id: mouseArea

        property bool hovered: false

        function createTooltipContent() {
            console.log("Creating LanguageTooltipContent...");
            var component = Qt.createComponent("LanguageTooltipContent.qml");
            console.log("Component status:", component.status);
            if (component.status === Component.Ready) {
                console.log("Component ready, creating object...");
                var contentItem = component.createObject(tooltip.contentContainer, {
                    colors: colors,
                    languages: languageWidget.languages,
                    currentLayout: languageWidget.currentLayout
                });
                if (contentItem) {
                    console.log("LanguageTooltipContent created successfully");
                    tooltip.contentItem = contentItem;
                    // Connect the tooltip content's language requests to switching
                    contentItem.languageRequested.connect(function (layoutKey) {
                        console.log("Language requested:", layoutKey);
                        switchToLanguage(layoutKey);
                    });
                    tooltip.disableInternalHover = false;
                } else {
                    console.error("Failed to create LanguageTooltipContent object");
                }
            } else if (component.status === Component.Error) {
                console.error("Failed to create LanguageTooltipContent:", component.errorString());
            } else {
                console.log("Component not ready yet, status:", component.status);
            }
        }
        function showTooltip() {
            if (!tooltip.visible) {
                createTooltipContent();
                tooltip.showForWidget(mouseArea);
            }
        }
        function switchToLanguage(layoutKey) {
            // For now, use the existing switch command (cycles through languages)
            // Could be enhanced later to switch directly to specific language
            switchProcess.running = true;
        }

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            switchProcess.running = true;
        }
        onEntered: {
            hovered = true;
            parent.color = colors.surface;
            showTooltip();
        }
        onExited: {
            hovered = false;
            parent.color = "transparent";
            tooltip.hide();
        }
    }
    Text {
        anchors.centerIn: parent
        color: colors.text
        font.bold: true
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: colors.iconSize
        text: languageWidget.currentLayout
    }
    Process {
        id: switchProcess

        command: ["hyprctl", "switchxkblayout", "diego-palacios-cantor-keyboard", "next"]
    }
}
