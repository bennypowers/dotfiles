import QtQuick
import Quickshell.Io
import Quickshell.Wayland

WlrLayershell {
    id: powerOverlay

    function show() {
        visible = true
        currentIndex = 0
    }

    function hide() {
        visible = false
    }

    namespace: "quickshell-power-overlay"
    layer: WlrLayer.Overlay
    exclusiveZone: 0
    keyboardFocus: WlrKeyboardFocus.Exclusive
    visible: false

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "#80000000"  // Semi-transparent black

    onVisibleChanged: {
        console.log("PowerOverlay visibility changed to:", visible)
        if (visible) {
            // Force focus after a delay to ensure layer shell is ready
            Qt.callLater(function() {
                console.log("PowerOverlay forcing focus to keyHandler")
                keyHandler.forceActiveFocus()
            })
        }
    }

    // Layout configuration
    property int iconSize: 128
    property int itemSize: 200
    property int itemSpacing: 40
    property int borderRadius: 16
    property int borderWidth: 2
    property int animationDuration: 150
    property real normalOpacity: 0.8
    property real highlightOpacity: 1.0

    property int currentIndex: 0
    property var actions: [
        { name: "Logout", icon: "󰍃", color: colors.yellow, action: function() { logoutProcess.running = true; powerOverlay.hide() } },
        { name: "Suspend", icon: "󰐥", color: colors.blue, action: function() { suspendProcess.running = true; powerOverlay.hide() } },
        { name: "Restart", icon: "󰜉", color: colors.peach, action: function() { restartProcess.running = true; powerOverlay.hide() } },
        { name: "Shutdown", icon: "󰤂", color: colors.red, action: function() { shutdownProcess.running = true; powerOverlay.hide() } }
    ]

    Colors {
        id: colors
    }

    // Invisible item to handle keyboard focus
    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true

        Keys.onPressed: function(event) {
            console.log("PowerOverlay key pressed:", event.key, "text:", event.text)
            if (event.key === Qt.Key_Escape) {
                powerOverlay.hide()
                event.accepted = true
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
                currentIndex = (currentIndex - 1 + actions.length) % actions.length
                event.accepted = true
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                currentIndex = (currentIndex + 1) % actions.length
                event.accepted = true
            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                currentIndex = (currentIndex - 1 + actions.length) % actions.length
                event.accepted = true
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_J) {
                currentIndex = (currentIndex + 1) % actions.length
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                actions[currentIndex].action()
                event.accepted = true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: powerOverlay.hide()

        // Power actions row
        PowerActionsRow {
            anchors.centerIn: parent
            
            actions: powerOverlay.actions
            iconSize: powerOverlay.iconSize
            itemSpacing: powerOverlay.itemSpacing
            itemSize: powerOverlay.itemSize
            showBorders: true
            borderRadius: powerOverlay.borderRadius
            borderWidth: powerOverlay.borderWidth
            animationDuration: powerOverlay.animationDuration
            normalOpacity: powerOverlay.normalOpacity
            highlightOpacity: powerOverlay.highlightOpacity
            currentIndex: powerOverlay.currentIndex
            
            onActionTriggered: function(index, action) {
                powerOverlay.currentIndex = index
                action.action()
            }
            
            onCurrentIndexChanged: {
                powerOverlay.currentIndex = currentIndex
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
