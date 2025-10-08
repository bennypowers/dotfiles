import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

WlrLayershell {
    id: container

    property int contentCount: 0  // Explicit counter for visibility

    property int cornerRadius: 16
    property var notificationContents: []
    property var notificationServer: null
    property int notificationSpacing: 0  // No spacing between notifications
    property int popoverWidth: 380
    property bool showNotificationCenter: false
    property int totalContentHeight: 0  // Explicit height tracker

    function addNotification(contentItem) {
        console.log("Adding notification to container");
        notificationContents.push(contentItem);
        contentItem.parent = scalableContainer;
        contentItem.visible = true;
        contentCount = notificationContents.length;

        // Connect to height changes
        contentItem.heightChanged.connect(function () {
            updateLayout();
        });

        // Wait for layout to settle before updating
        Qt.callLater(function () {
            updateLayout();
        });

        // Trigger show animation if this is first notification
        if (contentCount === 1) {
            scalableContainer.scale = 0;
            showAnimation.start();
        }
    }
    function calculateTotalHeight() {
        var total = 0;

        // Include notification center height if visible
        if (showNotificationCenter && notificationCenterContent.item) {
            total += notificationCenterContent.item.implicitHeight;
        }

        // Add notification popup heights
        for (var i = 0; i < notificationContents.length; i++) {
            if (notificationContents[i] && notificationContents[i].visible) {
                total += notificationContents[i].height;
                if (i < notificationContents.length - 1) {
                    total += notificationSpacing;
                }
            }
        }
        return total > 0 ? total + cornerRadius : 0;
    }
    function removeNotification(contentItem) {
        console.log("Removing notification from container");
        var index = notificationContents.indexOf(contentItem);
        if (index >= 0) {
            notificationContents.splice(index, 1);
            contentCount = notificationContents.length;
            contentItem.destroy();
            updateLayout();

            // Update height
            implicitHeight = calculateTotalHeight();
        }
    }
    function updateLayout() {
        // Start after notification center if it's visible
        var yOffset = showNotificationCenter && notificationCenterContent.item ? notificationCenterContent.item.implicitHeight : 0;
        var contentHeight = yOffset;

        for (var i = 0; i < notificationContents.length; i++) {
            if (notificationContents[i] && notificationContents[i].visible) {
                notificationContents[i].y = yOffset;
                notificationContents[i].x = 0;
                yOffset += notificationContents[i].height;
                contentHeight += notificationContents[i].height;
                if (i < notificationContents.length - 1) {
                    yOffset += notificationSpacing;
                    contentHeight += notificationSpacing;
                }
            }
        }
        totalContentHeight = contentHeight;
        implicitHeight = calculateTotalHeight();
        console.log("Layout updated: totalContentHeight =", totalContentHeight);
    }

    color: "transparent"
    exclusiveZone: 0
    implicitHeight: calculateTotalHeight()
    implicitWidth: popoverWidth + cornerRadius
    keyboardFocus: WlrKeyboardFocus.None
    layer: WlrLayer.Overlay
    namespace: "notification-popup-container"
    visible: contentCount > 0 || showNotificationCenter

    onShowNotificationCenterChanged: {
        console.log("Container: showNotificationCenter changed to", showNotificationCenter);
        console.log("Container: visible should be", (contentCount > 0 || showNotificationCenter));
        updateLayout();
        implicitHeight = calculateTotalHeight();
    }

    anchors {
        left: true
        top: true
    }
    margins {
        left: 0
        top: 0
    }

    // Show animation
    NumberAnimation {
        id: showAnimation

        duration: 150
        easing.type: Easing.OutQuad
        from: 0
        property: "scale"
        target: scalableContainer
        to: 1
    }
    Colors {
        id: colors

    }

    // Animated container
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 1
        transformOrigin: Item.TopLeft

        // Top-right corner (only at very top)
        CornerShape {
            fillColor: colors.black
            height: cornerRadius
            radius: cornerRadius
            rotation: 270
            visible: contentCount > 0
            width: cornerRadius
            x: popoverWidth
            y: 0
        }

        // Bottom-left corner (only at very bottom)
        CornerShape {
            fillColor: colors.black
            height: cornerRadius
            radius: cornerRadius
            rotation: 270
            visible: contentCount > 0
            width: cornerRadius
            x: 0
            y: totalContentHeight
        }

        // Background rectangle
        Rectangle {
            id: background

            bottomLeftRadius: 0  // Square - corner inset fills this
            bottomRightRadius: 16
            color: colors.black
            height: totalContentHeight
            radius: 16
            topLeftRadius: 16
            topRightRadius: 0  // Square - corner inset fills this
            width: popoverWidth
            x: 0
            y: 0
            z: -1  // Behind notification content
        }

        // Notification Center Content
        Loader {
            id: notificationCenterContent

            active: showNotificationCenter
            visible: showNotificationCenter
            width: popoverWidth
            x: 0
            y: 0

            sourceComponent: Component {
                NotificationCenterContent {
                    notificationServer: container.notificationServer
                    width: popoverWidth
                }
            }

            onLoaded: {
                if (item) {
                    item.implicitHeightChanged.connect(function () {
                        updateLayout();
                        implicitHeight = calculateTotalHeight();
                    });
                    updateLayout();
                    implicitHeight = calculateTotalHeight();
                }
            }
        }
    }
}
