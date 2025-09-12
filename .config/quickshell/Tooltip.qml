import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow
    
    property string debugId: "Tooltip_" + Math.random().toString(36).substr(2, 9)

    property string backgroundColor: color.base
    property string borderColor: color.crust
    property string connectionSide: "top"  // "top", "bottom", "left", "right"

    // Connection properties for positioning stem
    property int connectionX: 0  // X position relative to tooltip where stem connects
    property int connectionY: 0  // Y position relative to tooltip where stem connects

    // Expose contentContainer for external access
    property alias contentContainer: contentContainer
    property real contentHeight: {
        if (contentItem && contentItem !== textContent) {
            return contentItem.height;
        } else if (tooltipText) {
            return textContent.implicitHeight;
        }
        return 100;
    }

    // Content properties
    property Item contentItem: null

    // Auto-sizing based on content
    property real contentWidth: {
        if (contentItem && contentItem !== textContent) {
            return contentItem.width;
        } else if (tooltipText) {
            return Math.min(300, textContent.implicitWidth);
        }
        return 200;
    }
    property bool disableInternalHover: false
    property real dropletHeight: height
    property real dropletRadius: radius

    // Properties for droplet arc coordination with main shell
    property bool dropletVisible: visible
    property real dropletWidth: width
    property real dropletX: x
    property real dropletY: y
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    readonly property int padding: 16
    readonly property int radius: 12
    property int stemLength: 20  // Length of connecting stem
    property int stemWidth: 6    // Width of connecting stem
    property string textColor: color.text

    // Hover management
    property bool tooltipHovered: false
    property string tooltipText: ""  // For simple text tooltips

    property alias transientParent: tooltipWindow.transientParent
    property var triggerWidget: null

    function forceHide() {
        hideDelay.start();
    }
    function hide() {
        // Only hide if neither the trigger widget nor the tooltip itself is hovered
        if (!tooltipHovered && (!triggerWidget || !triggerWidget.hovered)) {
            hideDelay.start();
        }
    }
    function setTransformOrigin() {
        // For right-side bar tooltips: grow from center-right (horizontal scaling)
        scalableContainer.transformOrigin = Item.Right;
    }

    // Simple text tooltip method
    function showAt(x, y, text, side, connX, connY) {
        if (text) {
            tooltipText = text;
        }

        hideDelay.stop();  // Cancel any pending hide
        hideAnimation.stop();  // Stop hide animation if running

        connectionSide = side || "top";
        connectionX = connX || width / 2;
        connectionY = connY || height / 2;

        setTransformOrigin();  // Set transform origin based on connection side

        tooltipWindow.x = x;
        tooltipWindow.y = y;

        visible = true;
        showAnimation.start();
    }

    // Smart positioning method for widgets
    function showForWidget(widget, text) {
        console.log("🎯 [" + debugId + "] showForWidget called for widget:", widget);
        if (!widget)
            return;

        // Store reference to trigger widget for hover coordination
        triggerWidget = widget;

        if (text) {
            tooltipText = text;
        }

        // Calculate widget center for Y positioning
        var widgetCenter;
        if (widget.mapToGlobal) {
            widgetCenter = widget.mapToGlobal(widget.width / 2, widget.height / 2);
        } else {
            // For MouseArea and other items without mapToGlobal, use parent
            widgetCenter = widget.parent.mapToGlobal(widget.x + widget.width / 2, widget.y + widget.height / 2);
        }

        // Find the ColumnLayout parent (which is inside the bar Rectangle)
        var layoutParent = widget;
        while (layoutParent && layoutParent.toString().indexOf("ColumnLayout") === -1) {
            layoutParent = layoutParent.parent;
        }

        // Calculate bar position based on widget position
        // Since the layout parent is giving wrong coordinates, use widget position directly
        var widgetGlobalPos;
        if (widget.mapToGlobal) {
            widgetGlobalPos = widget.mapToGlobal(0, 0);
        } else {
            widgetGlobalPos = widget.parent.mapToGlobal(widget.x, widget.y);
        }
        console.log("🎯 Widget global position:", widgetGlobalPos.x, widgetGlobalPos.y);
        
        // Calculate bar left edge: widget is inside the bar, so bar left = widget global X - widget local X
        // But we need to account for the margins and layout offsets
        var barGlobalX = widgetGlobalPos.x - widget.x - 8; // 8px is the layout margin
        var barGlobalY = widgetGlobalPos.y - widget.y;
        var barLeftEdge = {x: barGlobalX, y: barGlobalY};
        console.log("🎯 Calculated bar position:", barLeftEdge.x, barLeftEdge.y);

        var tooltipX, tooltipY;
        var connectionSide = "left";  // Default assumption: tooltip to the right of widget

        // For right-side panel: position tooltip to the LEFT of the panel
        // Right edge of tooltip should align with left edge of bar
        tooltipX = barLeftEdge.x - width;  // Right edge of tooltip at left edge of bar
        tooltipY = widgetCenter.y - height / 2;
        connectionSide = "right";  // Connection side toward the panel

        // Final bounds checking
        if (tooltipY < 10) {
            tooltipY = 10;
        }
        // Remove restrictive height bounds check that was causing issues
        // Bottom widgets should be able to show tooltips properly

        console.log("🎯 Tooltip positioning - widgetCenter:", widgetCenter.x, widgetCenter.y, "barLeftEdge:", barLeftEdge.x, barLeftEdge.y);
        console.log("🎯 Final tooltip position:", tooltipX, tooltipY);
        showAt(tooltipX, tooltipY, text || tooltipText, "right", width, height / 2);
    }
    function updateText(text) {
        tooltipText = text;
    }

    color: "transparent"
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus
    height: contentHeight + padding
    width: contentWidth + padding

    onVisibleChanged:
    // Tooltip visibility changed - droplet arcs will be handled by main shell
    {}

    Colors {
        id: color

    }

    // Scalable container for growth animation
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0

        // Main tooltip body with asymmetric corners for droplet effect
        Rectangle {
            id: tooltipBody

            anchors.fill: parent
            bottomLeftRadius: tooltipWindow.radius
            bottomRightRadius: 0
            color: tooltipWindow.backgroundColor
            topLeftRadius: tooltipWindow.radius
            topRightRadius: 0

            // Subtle drop shadow effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                color: "black"
                opacity: 0.15
                radius: parent.radius
                z: -1
            }
        }

        // Content container inside scalable container
        Item {
            id: contentContainer

            anchors.fill: parent
            anchors.margins: tooltipWindow.padding / 2

            onChildrenChanged: {
                // Find the first non-textContent child as contentItem
                for (var i = 0; i < children.length; i++) {
                    if (children[i] !== textContent && !tooltipWindow.contentItem) {
                        tooltipWindow.contentItem = children[i];
                        break;
                    }
                }
            }

            // Default text content for simple tooltips
            Text {
                id: textContent

                anchors.centerIn: parent
                color: tooltipWindow.textColor
                font.bold: false
                font.family: tooltipWindow.fontFamily
                font.italic: false
                font.pixelSize: tooltipWindow.fontSize
                font.styleName: ""
                horizontalAlignment: Text.AlignLeft
                parent: contentContainer
                text: tooltipWindow.tooltipText
                textFormat: Text.RichText
                visible: tooltipWindow.tooltipText && (!tooltipWindow.contentItem || tooltipWindow.contentItem === textContent)
                width: Math.min(300, implicitWidth)
                wrapMode: Text.WordWrap
            }

            // Mouse area to detect hover on tooltip content
            MouseArea {
                acceptedButtons: Qt.NoButton
                anchors.fill: parent
                enabled: !tooltipWindow.disableInternalHover
                hoverEnabled: true

                onEntered: {
                    console.log("🔵 Tooltip MouseArea entered - tooltipHovered set to true");
                    tooltipWindow.tooltipHovered = true;
                    hideDelay.stop();
                    hideAnimation.stop();
                }
                onExited: {
                    console.log("🔴 Tooltip MouseArea exited - tooltipHovered set to false");
                    tooltipWindow.tooltipHovered = false;
                    var triggerHovered = tooltipWindow.triggerWidget ? tooltipWindow.triggerWidget.hovered : false;
                    console.log("🔍 Trigger widget hovered state:", triggerHovered);
                    if (!tooltipWindow.triggerWidget || !triggerHovered) {
                        console.log("🔴 Starting hideDelay because trigger widget not hovered");
                        hideDelay.start();
                    } else {
                        console.log("🟢 Keeping tooltip visible because trigger widget is still hovered");
                    }
                }
            }
        }
    }

    // Note: Connection stem removed - droplet arcs handled by main shell border system

    // Growth animation
    SequentialAnimation {
        id: showAnimation

        PropertyAnimation {
            duration: 200
            easing.overshoot: 1.2
            easing.type: Easing.OutBack
            from: 0
            property: "scale"
            target: scalableContainer
            to: 1.05
        }
        PropertyAnimation {
            duration: 100
            easing.type: Easing.OutQuad
            from: 1.05
            property: "scale"
            target: scalableContainer
            to: 1.0
        }
    }
    PropertyAnimation {
        id: hideAnimation

        duration: 150
        easing.type: Easing.InBack
        from: 1
        property: "scale"
        target: scalableContainer
        to: 0

        onFinished: {
            tooltipWindow.visible = false;
            // Clean up any dynamic content (but not textContent)
            if (tooltipWindow.contentItem && tooltipWindow.contentItem !== textContent) {
                tooltipWindow.contentItem.destroy();
                tooltipWindow.contentItem = null;
            }
        }
    }
    Timer {
        id: hideDelay

        interval: 500  // Longer delay to allow mouse transition from widget to tooltip

        onTriggered: {
            if (!tooltipHovered && (!triggerWidget || !triggerWidget.hovered)) {
                hideAnimation.start();
            }
        }
    }
}
