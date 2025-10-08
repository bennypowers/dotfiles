import QtQuick
import Quickshell.Wayland

WlrLayershell {
    id: basePopover

    // Positioning properties
    property string anchorSide: "right"  // "left" or "right"
    property int leftMargin: 0
    property int rightMargin: 0
    property int topMargin: 0

    // Appearance properties
    property int cornerRadius: 16
    property int popoverPadding: 16
    property int popoverWidth: 380

    // Corner configuration - which corners to create insets for
    property var cornerPositions: ["topLeft", "bottomRight"]  // or ["topLeft", "topRight"]

    // Computed properties for corners
    property bool hasTopLeft: cornerPositions.indexOf("topLeft") >= 0
    property bool hasTopRight: cornerPositions.indexOf("topRight") >= 0
    property bool hasBottomRight: cornerPositions.indexOf("bottomRight") >= 0

    // Content offset (to make room for corners)
    property int contentXOffset: hasTopLeft ? cornerRadius : 0
    property int contentYOffset: 0

    // Background corner radii (computed based on corner positions)
    property int topLeftRadius: hasTopLeft ? 0 : 16
    property int topRightRadius: hasTopRight ? 0 : 16
    property int bottomLeftRadius: 16  // Always rounded on bottom left
    property int bottomRightRadius: hasBottomRight ? 0 : 16

    // Content area - for measuring height
    property alias contentHeight: contentContainer.height
    property alias contentItem: contentContainer

    // Expose colors to child components
    property alias colors: colors

    // Visibility state
    default property alias content: contentContainer.data

    // Signal emitted when backdrop is clicked
    signal closeRequested()

    color: "transparent"
    exclusiveZone: 0
    keyboardFocus: WlrKeyboardFocus.None
    layer: WlrLayer.Overlay
    visible: false

    // Dynamic width to encompass corners
    width: popoverWidth + (hasTopLeft ? cornerRadius : 0) + (hasTopRight ? cornerRadius : 0)

    // Dynamic height to encompass bottom corners
    height: contentContainer.height + popoverPadding * 2 + (hasBottomRight ? cornerRadius : 0)

    anchors {
        left: anchorSide === "left"
        right: anchorSide === "right"
        top: true
    }
    margins {
        left: anchorSide === "left" ? (leftMargin - (hasTopLeft ? cornerRadius : 0)) : 0
        right: anchorSide === "right" ? rightMargin : 0
        top: topMargin
    }

    onVisibleChanged: {
        console.log("🔔 BasePopover visible changed:", visible, "namespace:", namespace);

        if (visible) {
            scalableContainer.scale = 0;
            showAnimation.start();
            console.log("🟢 Creating backdrop for", namespace);
            Qt.callLater(function() {
                console.log("📦 Setting backdropLoader.active = true for", namespace);
                backdropLoader.active = true;
            });
        } else {
            hideAnimation.start();
            console.log("🔴 Destroying backdrop for", namespace);
            Qt.callLater(function() {
                console.log("📦 Setting backdropLoader.active = false for", namespace);
                backdropLoader.active = false;
            });
        }
    }

    Colors {
        id: colors
    }

    // Fullscreen backdrop to catch clicks outside
    Loader {
        id: backdropLoader

        active: false
        asynchronous: false

        onActiveChanged: {
            console.log("📦 Loader active changed:", active, "for", basePopover.namespace);
        }

        onLoaded: {
            console.log("✅ Backdrop loaded for", basePopover.namespace);
        }

        sourceComponent: Component {
            WlrLayershell {
                id: backdropShell

                anchors {
                    bottom: true
                    left: true
                    right: true
                    top: true
                }
                color: "transparent"
                exclusiveZone: 0
                keyboardFocus: WlrKeyboardFocus.None
                layer: WlrLayer.Top  // Below popover to avoid covering it
                namespace: basePopover.namespace + "-backdrop"

                MouseArea {
                    id: backdropMouseArea

                    anchors.fill: parent

                    onClicked: {
                        console.log("💥 Backdrop clicked for", basePopover.namespace, "- emitting closeRequested");
                        basePopover.closeRequested();
                    }
                }

                Component.onCompleted: {
                    console.log("🏗️  Backdrop WlrLayershell created for", basePopover.namespace);
                }

                Component.onDestruction: {
                    console.log("💀 Backdrop WlrLayershell destroyed for", basePopover.namespace);
                }
            }
        }
    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: anchorSide === "left" ? Item.TopLeft : Item.TopRight

        // Top-left corner (drawn inside window)
        CornerShape {
            fillColor: colors.black
            height: cornerRadius
            radius: cornerRadius
            visible: hasTopLeft
            width: cornerRadius
            x: 0
            y: 0
        }

        // Top-right corner (drawn inside window)
        CornerShape {
            fillColor: colors.black
            height: cornerRadius
            radius: cornerRadius
            rotation: 270
            visible: hasTopRight
            width: cornerRadius
            x: contentXOffset + popoverWidth
            y: 0
        }

        // Bottom-right corner (drawn inside window)
        CornerShape {
            fillColor: colors.black
            height: cornerRadius
            radius: cornerRadius
            visible: hasBottomRight
            width: cornerRadius
            x: contentXOffset + popoverWidth - cornerRadius
            y: contentContainer.height + popoverPadding * 2
        }

        // Background with rounded corners (positioned at content area)
        Rectangle {
            id: background

            bottomLeftRadius: basePopover.bottomLeftRadius
            bottomRightRadius: basePopover.bottomRightRadius
            color: colors.black
            height: contentContainer.height + popoverPadding * 2
            layer.enabled: true
            topLeftRadius: basePopover.topLeftRadius
            topRightRadius: basePopover.topRightRadius
            width: popoverWidth
            x: contentXOffset
            y: 0
        }

        // Content container
        Item {
            id: contentContainer

            height: childrenRect.height
            width: popoverWidth - popoverPadding * 2
            x: contentXOffset + popoverPadding
            y: popoverPadding
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
}
