import QtQuick
import QtQuick.Window

Window {
    id: popover

    property int popoverPadding: 16
    property int popoverWidth: 380
    property int sectionSpacing: 12
    property var triggerButton: null

    // Position popover to the left of the trigger button
    function updatePosition() {
        if (!triggerButton)
            return;

        // Get button's screen position
        const buttonGlobal = triggerButton.mapToGlobal(0, 0);

        // Position to the left of the button with a small gap
        x = buttonGlobal.x - width - 12;
        y = buttonGlobal.y;
    }

    color: "transparent"
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    height: contentColumn.height + popoverPadding * 2
    width: popoverWidth

    onVisibleChanged: {
        if (visible) {
            updatePosition();
            scalableContainer.opacity = 0;
            showAnimation.start();
        } else {
            hideAnimation.start();
        }
    }

    Colors {
        id: colors

    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        opacity: 0
        transformOrigin: Item.Right

        // Background with rounded corners
        Rectangle {
            id: background

            anchors.fill: parent
            color: colors.base

            // Drop shadow effect (simplified)
            layer.enabled: true
            radius: 16
        }

        // Content column
        Column {
            id: contentColumn

            anchors.left: parent.left
            anchors.leftMargin: popoverPadding
            anchors.right: parent.right
            anchors.rightMargin: popoverPadding
            anchors.top: parent.top
            anchors.topMargin: popoverPadding
            spacing: sectionSpacing

            // Volume Section
            SystemMenuVolumeSection {
                id: volumeSection

                width: parent.width
            }

            // Network Section
            SystemMenuNetworkSection {
                id: networkSection

                width: parent.width
            }

            // Language Section
            SystemMenuLanguageSection {
                id: languageSection

                width: parent.width
            }
            // Workmode Section
            SystemMenuWorkmodeSection {
                id: workmodeSection

                width: parent.width
            }

            // Power Section
            SystemMenuPowerSection {
                id: powerSection

                width: parent.width
            }
        }
    }

    // Show animation
    PropertyAnimation {
        id: showAnimation

        duration: 150
        easing.type: Easing.OutQuad
        from: 0
        properties: "opacity"
        target: scalableContainer
        to: 1
    }
    // Hide animation
    PropertyAnimation {
        id: hideAnimation

        duration: 150
        easing.type: Easing.InQuad
        from: 1
        properties: "opacity"
        target: scalableContainer
        to: 0
    }

    // Click outside to close
    MouseArea {
        anchors.fill: parent
        z: -1

        onClicked: {
            if (triggerButton) {
                triggerButton.popoverVisible = false;
            }
        }
    }
}
