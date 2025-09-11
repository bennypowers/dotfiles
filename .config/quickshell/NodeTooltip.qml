import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow

    property alias transientParent: tooltipWindow.transientParent
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property string backgroundColor: "#45475a"
    property string borderColor: "#6c7086"
    property string textColor: "#cdd6f4"
    
    // Connection properties
    property int connectionX: 0  // X position relative to tooltip where stem connects
    property int connectionY: 0  // Y position relative to tooltip where stem connects
    property int stemLength: 20  // Length of connecting stem
    property int stemWidth: 6    // Width of connecting stem
    property string connectionSide: "top"  // "top", "bottom", "left", "right"
    
    // Content
    property Item contentItem: null
    
    readonly property int padding: 16
    readonly property int radius: 12
    
    width: contentItem ? contentItem.width + padding : 200
    height: contentItem ? contentItem.height + padding : 160

    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowTransparentForInput
    color: "transparent"

    // Scalable container for growth animation
    Item {
        id: scalableContainer
        anchors.fill: parent
        scale: 0
        
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
    }

    // Connection stem that grows from the tooltip toward the parent widget
    Canvas {
        id: connectionStem
        anchors.fill: parent
        z: 10  // Above other content
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Calculate stem position based on connection side
            var startX, startY, endX, endY
            
            switch (tooltipWindow.connectionSide) {
                case "top":
                    startX = tooltipWindow.connectionX
                    startY = 0
                    endX = startX
                    endY = -tooltipWindow.stemLength
                    break
                case "bottom":
                    startX = tooltipWindow.connectionX
                    startY = height
                    endX = startX
                    endY = height + tooltipWindow.stemLength
                    break
                case "left":
                    startX = 0
                    startY = tooltipWindow.connectionY
                    endX = -tooltipWindow.stemLength
                    endY = startY
                    break
                case "right":
                    startX = width
                    startY = tooltipWindow.connectionY
                    endX = width + tooltipWindow.stemLength
                    endY = startY
                    break
            }
            
            // Draw the connecting stem
            ctx.strokeStyle = tooltipWindow.borderColor
            ctx.fillStyle = tooltipWindow.backgroundColor
            ctx.lineWidth = tooltipWindow.stemWidth
            ctx.lineCap = "round"
            
            // Create a smooth curved connection
            var controlOffset = tooltipWindow.stemLength * 0.6
            var controlX, controlY
            
            if (tooltipWindow.connectionSide === "top" || tooltipWindow.connectionSide === "bottom") {
                controlX = startX
                controlY = startY + (endY - startY) * 0.3
            } else {
                controlX = startX + (endX - startX) * 0.3
                controlY = startY
            }
            
            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.quadraticCurveTo(controlX, controlY, endX, endY)
            ctx.stroke()
        }
    }

    // Content container inside scalable container
    Item {
        id: contentContainer
        parent: scalableContainer
        anchors.fill: parent
        anchors.margins: tooltipWindow.padding / 2
        
        onChildrenChanged: {
            if (children.length > 0 && !tooltipWindow.contentItem) {
                tooltipWindow.contentItem = children[0]
            }
        }
    }
    
    function setTransformOrigin() {
        // Set transform origin to the exact connection point
        scalableContainer.transformOriginX = connectionX
        scalableContainer.transformOriginY = connectionY
    }
    
    // Growth animation
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
        onFinished: tooltipWindow.visible = false
    }
    
    Timer {
        id: hideDelay
        interval: 100
        onTriggered: hideAnimation.start()
    }

    function showAt(x, y, side, connX, connY) {
        hideDelay.stop()  // Cancel any pending hide
        hideAnimation.stop()  // Stop hide animation if running
        
        connectionSide = side || "top"
        connectionX = connX || width / 2
        connectionY = connY || height / 2
        
        setTransformOrigin()  // Set transform origin based on connection side
        
        tooltipWindow.x = x
        tooltipWindow.y = y
        
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