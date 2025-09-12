import QtQuick
import Quickshell.Io
import Quickshell.Wayland

WlrLayershell {
    id: powerOverlay

    property var actions: [
        {
            name: "Logout",
            icon: "󰍃",
            color: colors.yellow,
            action: function () {
                logoutProcess.running = true;
                powerOverlay.hide();
            }
        },
        {
            name: "Suspend",
            icon: "󰐥",
            color: colors.blue,
            action: function () {
                suspendProcess.running = true;
                powerOverlay.hide();
            }
        },
        {
            name: "Restart",
            icon: "󰜉",
            color: colors.peach,
            action: function () {
                restartProcess.running = true;
                powerOverlay.hide();
            }
        },
        {
            name: "Shutdown",
            icon: "󰤂",
            color: colors.red,
            action: function () {
                shutdownProcess.running = true;
                powerOverlay.hide();
            }
        }
    ]
    property int animationDuration: 150
    property int borderRadius: 16
    property int borderWidth: 2
    property int currentIndex: 0
    property real highlightOpacity: 1.0

    // Layout configuration
    property int iconSize: 128
    property int itemSize: 200
    property int itemSpacing: 40
    property real normalOpacity: 0.8

    function hide() {
        visible = false;
    }
    function show() {
        visible = true;
        currentIndex = 0;
    }

    color: "#80000000"  // Semi-transparent black

    exclusiveZone: 0
    keyboardFocus: WlrKeyboardFocus.Exclusive
    layer: WlrLayer.Overlay
    namespace: "quickshell-power-overlay"
    visible: false

    onVisibleChanged: {
        console.log("PowerOverlay visibility changed to:", visible);
        if (visible) {
            // Force focus after a delay to ensure layer shell is ready
            Qt.callLater(function () {
                console.log("PowerOverlay forcing focus to keyHandler");
                keyHandler.forceActiveFocus();
            });
        }
    }

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    Colors {
        id: colors

    }

    // Invisible item to handle keyboard focus
    Item {
        id: keyHandler

        anchors.fill: parent
        focus: true

        Keys.onPressed: function (event) {
            console.log("PowerOverlay key pressed:", event.key, "text:", event.text);
            if (event.key === Qt.Key_Escape) {
                powerOverlay.hide();
                event.accepted = true;
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
                currentIndex = (currentIndex - 1 + actions.length) % actions.length;
                event.accepted = true;
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                currentIndex = (currentIndex + 1) % actions.length;
                event.accepted = true;
            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                currentIndex = (currentIndex - 1 + actions.length) % actions.length;
                event.accepted = true;
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_J) {
                currentIndex = (currentIndex + 1) % actions.length;
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                actions[currentIndex].action();
                event.accepted = true;
            }
        }
    }
    MouseArea {
        anchors.fill: parent

        onClicked: powerOverlay.hide()

        // Power actions row
        PowerActionsRow {
            actions: powerOverlay.actions
            anchors.centerIn: parent
            animationDuration: powerOverlay.animationDuration
            borderRadius: powerOverlay.borderRadius
            borderWidth: powerOverlay.borderWidth
            currentIndex: powerOverlay.currentIndex
            highlightOpacity: powerOverlay.highlightOpacity
            iconSize: powerOverlay.iconSize
            itemSize: powerOverlay.itemSize
            itemSpacing: powerOverlay.itemSpacing
            normalOpacity: powerOverlay.normalOpacity
            showBorders: true

            onActionTriggered: function (index, action) {
                powerOverlay.currentIndex = index;
                action.action();
            }
            onCurrentIndexChanged: {
                powerOverlay.currentIndex = currentIndex;
            }
        }
    }

    // System action processes
    Process {
        id: logoutProcess

        command: ["hyprctl", "dispatch", "exit"]
    }
    Process {
        id: suspendProcess

        command: ["systemctl", "suspend"]
    }
    Process {
        id: restartProcess

        command: ["systemctl", "reboot"]
    }
    Process {
        id: shutdownProcess

        command: ["systemctl", "poweroff"]
    }
}
