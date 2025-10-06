import QtQuick

Rectangle {
    id: systemMenuButton

    property var shellRoot: null
    property bool popoverVisible: false

    signal clicked()

    color: "transparent"
    height: 50
    width: contentRow.width + 16  // Add padding
    radius: 8

    Colors {
        id: colors
    }

    // Indicator components - each manages its own state
    NetworkIndicator {
        id: networkIndicator
    }

    CameraIndicator {
        id: cameraIndicator
    }

    AudioIndicator {
        id: audioIndicator
    }

    MouseArea {
        id: mouseArea

        property bool hovered: false

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            systemMenuButton.clicked()
            systemMenuButton.popoverVisible = !systemMenuButton.popoverVisible
        }

        onEntered: {
            hovered = true
            parent.color = colors.surface
        }

        onExited: {
            hovered = false
            parent.color = "transparent"
        }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 8

        // Camera icon - only shown when camera is active
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: colors.red
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            text: cameraIndicator.cameraIcon
            visible: cameraIndicator.shouldDisplay
        }

        // Network icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: networkIndicator.isConnected ? colors.text : colors.overlay
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            text: networkIndicator.networkIcon
            visible: networkIndicator.shouldDisplay
        }

        // Volume icon with mic muted indicator
        Item {
            anchors.verticalCenter: parent.verticalCenter
            height: 18
            width: 18
            visible: audioIndicator.shouldDisplay

            Text {
                anchors.centerIn: parent
                color: audioIndicator.isMuted ? colors.overlay : colors.text
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
                text: audioIndicator.volumeIcon
            }

            // Mic muted indicator (red dot)
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                color: colors.red
                height: 6
                radius: 3
                visible: audioIndicator.isMicMuted
                width: 6
            }
        }
    }

    SystemMenuPopover {
        id: popover

        visible: systemMenuButton.popoverVisible
        triggerButton: systemMenuButton

        onVisibleChanged: {
            if (!visible) {
                systemMenuButton.popoverVisible = false
            }
        }
    }
}
