import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow

    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property string backgroundColor: "#45475a"
    property string borderColor: "#6c7086"
    property string textColor: "#cdd6f4"
    
    readonly property int padding: 16
    readonly property int radius: 12
    readonly property int stemLength: 20
    readonly property int stemWidth: 6
    
    // Content properties
    property Item contentItem: null
    
    // Auto-sizing based on content
    width: contentItem ? contentItem.width + padding : 100
    height: contentItem ? contentItem.height + padding : 50

    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowTransparentForInput
    color: "transparent"

    // Scalable container for growth animation from panel edge
    Item {
        id: scalableContainer
        anchors.fill: parent
        scale: 0
        transformOrigin: Item.Right  // Grow from right edge (connection to right-side panel)
        
        // Main tooltip body with rounded corners
        Rectangle {
            id: tooltipBody
            anchors.fill: parent
            color: tooltipWindow.backgroundColor
            border.color: tooltipWindow.borderColor
            border.width: 1
            radius: tooltipWindow.radius
            
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
                if (children.length > 0 && !tooltipWindow.contentItem) {
                    tooltipWindow.contentItem = children[0]
                }
            }
        }
    }
    
    // Expose contentContainer for external access
    property alias contentContainer: contentContainer

    // Connection stem that grows from the tooltip toward the panel edge
    Canvas {
        id: connectionStem
        anchors.fill: parent
        z: 10  // Above other content
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Draw stem from right edge of tooltip towards the right-side panel
            var startX = width
            var startY = height / 2
            var endX = width + stemLength
            var endY = startY
            
            // Draw the connecting stem
            ctx.strokeStyle = tooltipWindow.borderColor
            ctx.fillStyle = tooltipWindow.backgroundColor
            ctx.lineWidth = tooltipWindow.stemWidth
            ctx.lineCap = "round"
            
            // Horizontal line pointing right towards panel
            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.lineTo(endX, endY)
            ctx.stroke()
        }
    }
    
    // Growth animation - bouncy emergence from panel
    SequentialAnimation {
        id: showAnimation
        PropertyAnimation {
            target: scalableContainer
            property: "scale"
            from: 0
            to: 1.05
            duration: 200
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }
        PropertyAnimation {
            target: scalableContainer
            property: "scale"
            from: 1.05
            to: 1.0
            duration: 100
            easing.type: Easing.OutQuad
        }
    }
    
    PropertyAnimation {
        id: hideAnimation
        target: scalableContainer
        property: "scale"
        from: 1
        to: 0
        duration: 150
        easing.type: Easing.InBack
        onFinished: {
            tooltipWindow.visible = false
            // Clean up any corrupted content
            if (contentItem) {
                contentItem.destroy()
                contentItem = null
            }
        }
    }
    
    Timer {
        id: hideDelay
        interval: 200  // Longer delay to prevent flicker
        onTriggered: hideAnimation.start()
    }

    // Generic show function - calculates position relative to any widget
    function showForWidget(widget) {
        if (!widget) return
        
        // Calculate position to the left of the right-side panel
        var widgetCenter = widget.mapToGlobal(widget.width/2, widget.height/2)
        var widgetRightEdge = widget.mapToGlobal(widget.width, widget.height/2)
        
        // Position tooltip to the left of the right-side panel
        var tooltipX = widgetCenter.x - width - stemLength  // Left of the widget, accounting for stem
        var tooltipY = widgetCenter.y - height/2
        
        hideDelay.stop()
        hideAnimation.stop()
        
        tooltipWindow.x = tooltipX
        tooltipWindow.y = tooltipY
        
        visible = true
        connectionStem.requestPaint()
        showAnimation.start()
    }

    function hide() {
        hideDelay.start()
    }
    
    onVisibleChanged: {
        if (visible) {
            connectionStem.requestPaint()
        }
    }
}