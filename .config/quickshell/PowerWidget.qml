import QtQuick
import Quickshell

Rectangle {
    id: powerWidget
    color: "transparent"
    radius: 8

    // Create our own overlay instance
    PowerOverlay {
        id: powerOverlay
    }

    Colors {
        id: colors
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: "⏻"  // Power on/off icons
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.iconSize
            color: powerOverlay.visible ? colors.green : colors.overlay
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            console.log("PowerWidget clicked, overlay exists:", !!powerOverlay)
            if (powerOverlay.visible) {
                console.log("Hiding power overlay")
                powerOverlay.hide()
            } else {
                console.log("Showing power overlay")
                powerOverlay.show()
            }
        }
        onEntered: {
            parent.color = colors.surface
        }
        onExited: {
            parent.color = "transparent"
        }
    }
}
