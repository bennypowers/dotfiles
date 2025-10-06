import QtQuick
import Quickshell.Wayland

WlrLayershell {
    id: basePopover

    // Positioning properties
    property string anchorSide: "right"  // "left" or "right"
    property int leftMargin: 0
    property int rightMargin: 0
    property int topMargin: 0
    property int cornerTopMargin: topMargin  // Override for corner positioning (e.g., clock popover)

    // Appearance properties
    property int cornerRadius: 16
    property int popoverPadding: 16
    property int popoverWidth: 380

    // Corner configuration - which corners to create insets for
    property var cornerPositions: ["topLeft", "bottomRight"]  // or ["topLeft", "topRight"]

    // Background corner radii (computed based on corner positions)
    property int topLeftRadius: cornerPositions.indexOf("topLeft") >= 0 ? 0 : 16
    property int topRightRadius: cornerPositions.indexOf("topRight") >= 0 ? 0 : 16
    property int bottomLeftRadius: 16  // Always rounded on bottom left
    property int bottomRightRadius: cornerPositions.indexOf("bottomRight") >= 0 ? 0 : 16

    // Content area - for measuring height
    property alias contentHeight: contentContainer.height
    property alias contentItem: contentContainer

    // Expose colors to child components
    property alias colors: colors

    // Visibility state
    default property alias content: contentContainer.data

    color: "transparent"
    exclusiveZone: 0
    height: contentContainer.height + popoverPadding * 2
    layer: WlrLayer.Overlay
    visible: false
    width: popoverWidth

    anchors {
        left: anchorSide === "left"
        right: anchorSide === "right"
        top: true
    }
    margins {
        left: anchorSide === "left" ? leftMargin : 0
        right: anchorSide === "right" ? rightMargin : 0
        top: topMargin
    }

    onVisibleChanged: {
        if (visible) {
            scalableContainer.scale = 0;
            showAnimation.start();
            updateCornerPositions();
        } else {
            hideAnimation.start();
            resetCornerPositions();
        }
    }

    function updateCornerPositions() {
        if (topLeftCorner.visible) {
            if (anchorSide === "left") {
                topLeftCorner.margins.left = leftMargin - cornerRadius;
                topLeftCorner.margins.top = cornerTopMargin;
            } else {
                topLeftCorner.margins.right = popoverWidth;
                topLeftCorner.margins.top = cornerTopMargin;
            }
        }
        if (topRightCorner.visible) {
            topRightCorner.margins.left = leftMargin + popoverWidth;
            topRightCorner.margins.top = cornerTopMargin;
        }
        if (bottomRightCorner.visible) {
            bottomRightCorner.margins.right = rightMargin;
            bottomRightCorner.margins.top = cornerTopMargin + contentContainer.height + popoverPadding * 2;
        }
    }

    function resetCornerPositions() {
        if (topLeftCorner.visible) {
            topLeftCorner.margins.left = 0;
            topLeftCorner.margins.right = 0;
            topLeftCorner.margins.top = 0;
        }
        if (topRightCorner.visible) {
            topRightCorner.margins.left = 0;
            topRightCorner.margins.top = 0;
        }
        if (bottomRightCorner.visible) {
            bottomRightCorner.margins.right = 0;
            bottomRightCorner.margins.top = 0;
        }
    }

    Colors {
        id: colors
    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: anchorSide === "left" ? Item.Top : Item.TopRight

        // Background with rounded corners
        Rectangle {
            id: background

            anchors.fill: parent
            bottomLeftRadius: basePopover.bottomLeftRadius
            bottomRightRadius: basePopover.bottomRightRadius
            color: colors.black
            layer.enabled: true
            topLeftRadius: basePopover.topLeftRadius
            topRightRadius: basePopover.topRightRadius
        }

        // Content container
        Item {
            id: contentContainer

            anchors.left: parent.left
            anchors.leftMargin: popoverPadding
            anchors.right: parent.right
            anchors.rightMargin: popoverPadding
            anchors.top: parent.top
            anchors.topMargin: popoverPadding
            height: childrenRect.height
        }
    }

    // Show animation
    PropertyAnimation {
        id: showAnimation

        duration: 150
        easing.type: Easing.OutQuad
        from: 0
        properties: "scale"
        target: scalableContainer
        to: 1
    }

    // Hide animation
    PropertyAnimation {
        id: hideAnimation

        duration: 150
        easing.type: Easing.InQuad
        from: 1
        properties: "scale"
        target: scalableContainer
        to: 0
    }

    // Click outside to close
    MouseArea {
        anchors.fill: parent
        z: -1

        onClicked: {
            basePopover.visible = false;
        }
    }

    // Top-left corner inset
    WlrLayershell {
        id: topLeftCorner

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: basePopover.namespace + "-corner-tl"
        visible: basePopover.visible && cornerPositions.indexOf("topLeft") >= 0
        width: cornerRadius

        anchors {
            left: anchorSide === "left"
            right: anchorSide === "right"
            top: true
        }
        margins {
            left: 0
            right: 0
            top: 0

            Behavior on left {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on right {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }

    // Top-right corner inset
    WlrLayershell {
        id: topRightCorner

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: basePopover.namespace + "-corner-tr"
        visible: basePopover.visible && cornerPositions.indexOf("topRight") >= 0
        width: cornerRadius

        anchors {
            left: true
            top: true
        }
        margins {
            left: 0
            top: 0

            Behavior on left {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
            rotation: 270
        }
    }

    // Bottom-right corner inset
    WlrLayershell {
        id: bottomRightCorner

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: basePopover.namespace + "-corner-br"
        visible: basePopover.visible && cornerPositions.indexOf("bottomRight") >= 0
        width: cornerRadius

        anchors {
            right: true
            top: true
        }
        margins {
            right: 0
            top: 0

            Behavior on right {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }
}
