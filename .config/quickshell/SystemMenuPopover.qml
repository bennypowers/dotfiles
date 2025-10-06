import QtQuick
import Quickshell.Wayland

WlrLayershell {
    id: popover

    property int cornerRadius: 16
    property int panelRightMargin: 22
    property int popoverPadding: 16
    property int popoverWidth: 380
    property int rightPanelWidth: 80
    property int screenWidth: 0
    property int sectionSpacing: 12
    property int topPanelHeight: 48

    color: "transparent"
    exclusiveZone: 0
    height: contentColumn.height + popoverPadding * 2
    layer: WlrLayer.Overlay
    namespace: "quickshell-system-menu"
    visible: false
    width: popoverWidth

    onVisibleChanged: {
        if (visible) {
            scalableContainer.scale = 0;
            showAnimation.start();
            // Trigger margin animations by changing values
            topLeftInset.margins.right = popoverWidth;
            bottomRightInset.margins.top = contentColumn.height + popoverPadding * 2;
        } else {
            hideAnimation.start();
            // Reset margins for next show
            topLeftInset.margins.right = 0;
            bottomRightInset.margins.top = 0;
        }
    }

    anchors {
        right: true
        top: true
    }
    margins {
        right: 0
        top: 0
    }
    Colors {
        id: colors

    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: Item.TopRight

        // Background with rounded corners
        Rectangle {
            id: background

            anchors.fill: parent
            bottomLeftRadius: 16
            bottomRightRadius: 0
            color: colors.black

            // Drop shadow effect (simplified)
            layer.enabled: true
            topLeftRadius: 0
            topRightRadius: 16
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
            popover.visible = false;
        }
    }

    // Top-left corner inset to join popover with top panel
    WlrLayershell {
        id: topLeftInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-system-menu-corner-tl"
        visible: popover.visible
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
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }

    // Bottom-right corner inset to join popover with right panel
    WlrLayershell {
        id: bottomRightInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-system-menu-corner-br"
        visible: popover.visible
        width: cornerRadius

        anchors {
            right: true
            top: true
        }
        margins {
            right: 0
            top: 0

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
