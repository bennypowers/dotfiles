import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow

    Colors { id: color }

    property alias transientParent: tooltipWindow.transientParent
    property string fontFamily: "JetBrainsMono Nerd Font Mono"
    property int fontSize: 14
    property string backgroundColor: color.base
    property string borderColor: color.crust
    property string textColor: color.text

    // Connection properties for positioning stem
    property int connectionX: 0  // X position relative to tooltip where stem connects
    property int connectionY: 0  // Y position relative to tooltip where stem connects
    property int stemLength: 20  // Length of connecting stem
    property int stemWidth: 6    // Width of connecting stem
    property string connectionSide: "top"  // "top", "bottom", "left", "right"

    // Content properties
    property Item contentItem: null
    property string tooltipText: ""  // For simple text tooltips

    readonly property int padding: 16
    readonly property int radius: 12

    // Auto-sizing based on content
    property real contentWidth: {
        if (contentItem && contentItem !== textContent) {
            return contentItem.width
        } else if (tooltipText) {
            return Math.min(300, textContent.implicitWidth)
        }
        return 200
    }
    property real contentHeight: {
        if (contentItem && contentItem !== textContent) {
            return contentItem.height
        } else if (tooltipText) {
            return textContent.implicitHeight
        }
        return 100
    }

    width: contentWidth + padding
    height: contentHeight + padding

    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus
    color: "transparent"

    // Hover management
    property bool tooltipHovered: false
    property var triggerWidget: null

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

        // Content container inside scalable container
        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: tooltipWindow.padding / 2

            // Default text content for simple tooltips
            Text {
                id: textContent
                parent: contentContainer
                anchors.centerIn: parent
                text: tooltipWindow.tooltipText
                font.family: tooltipWindow.fontFamily
                font.pixelSize: tooltipWindow.fontSize
                color: tooltipWindow.textColor
                horizontalAlignment: Text.AlignLeft
                textFormat: Text.RichText
                font.bold: false
                font.italic: false
                font.styleName: ""
                wrapMode: Text.WordWrap
                width: Math.min(300, implicitWidth)
                visible: tooltipWindow.tooltipText && (!tooltipWindow.contentItem || tooltipWindow.contentItem === textContent)
            }

            onChildrenChanged: {
                // Find the first non-textContent child as contentItem
                for (var i = 0; i < children.length; i++) {
                    if (children[i] !== textContent && !tooltipWindow.contentItem) {
                        tooltipWindow.contentItem = children[i]
                        break
                    }
                }
            }

            // Mouse area to detect hover on tooltip content
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton

                onEntered: {
                    console.log("🔵 Tooltip MouseArea entered - tooltipHovered set to true")
                    tooltipWindow.tooltipHovered = true
                    hideDelay.stop()
                    hideAnimation.stop()
                }

                onExited: {
                    console.log("🔴 Tooltip MouseArea exited - tooltipHovered set to false")
                    tooltipWindow.tooltipHovered = false
                    var triggerHovered = tooltipWindow.triggerWidget ? tooltipWindow.triggerWidget.hovered : false
                    console.log("🔍 Trigger widget hovered state:", triggerHovered)
                    if (!tooltipWindow.triggerWidget || !triggerHovered) {
                        console.log("🔴 Starting hideDelay because trigger widget not hovered")
                        hideDelay.start()
                    } else {
                        console.log("🟢 Keeping tooltip visible because trigger widget is still hovered")
                    }
                }
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

    // Expose contentContainer for external access
    property alias contentContainer: contentContainer

    function setTransformOrigin() {
        // For right-side bar tooltips: grow from top-right (right-to-left)
        scalableContainer.transformOrigin = Item.TopRight
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
        onFinished: {
            tooltipWindow.visible = false
            // Clean up any dynamic content (but not textContent)
            if (tooltipWindow.contentItem && tooltipWindow.contentItem !== textContent) {
                tooltipWindow.contentItem.destroy()
                tooltipWindow.contentItem = null
            }
        }
    }

    Timer {
        id: hideDelay
        interval: 500  // Longer delay to allow mouse transition from widget to tooltip
        onTriggered: {
            if (!tooltipHovered && (!triggerWidget || !triggerWidget.hovered)) {
                hideAnimation.start()
            }
        }
    }

    // Simple text tooltip method
    function showAt(x, y, text, side, connX, connY) {
        if (text) {
            tooltipText = text
        }

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

    // Smart positioning method for widgets
    function showForWidget(widget, text) {
        if (!widget) return

        // Store reference to trigger widget for hover coordination
        triggerWidget = widget

        if (text) {
            tooltipText = text
        }

        // Calculate position relative to widget
        var widgetCenter, widgetLeftEdge
        if (widget.mapToGlobal) {
            widgetCenter = widget.mapToGlobal(widget.width/2, widget.height/2)
            widgetLeftEdge = widget.mapToGlobal(0, widget.height/2)
        } else {
            // For MouseArea and other items without mapToGlobal, use parent
            widgetCenter = widget.parent.mapToGlobal(widget.x + widget.width/2, widget.y + widget.height/2)
            widgetLeftEdge = widget.parent.mapToGlobal(widget.x, widget.y + widget.height/2)
        }

        var tooltipX, tooltipY
        var connectionSide = "left"  // Default assumption: tooltip to the right of widget

        // For right-side panel: position tooltip to the LEFT of the panel
        // Right edge of tooltip should align with left edge of bar, growing leftward
        tooltipX = widgetLeftEdge.x - width  // Right edge of tooltip at left edge of bar
        tooltipY = widgetCenter.y - height/2
        connectionSide = "right"  // Stem points right toward the panel

        // Final bounds checking
        if (tooltipY < 10) {
            tooltipY = 10
        }
        if (tooltipY + height > 1080) {  // Assume 1080p screen height
            tooltipY = 1080 - height - 10
        }

        showAt(tooltipX, tooltipY, text || tooltipText, "right", width, height/2)
    }

    function hide() {
        // Only hide if neither the trigger widget nor the tooltip itself is hovered
        if (!tooltipHovered && (!triggerWidget || !triggerWidget.hovered)) {
            hideDelay.start()
        }
    }

    function forceHide() {
        hideDelay.start()
    }

    function updateText(text) {
        tooltipText = text
    }

    onVisibleChanged: {
        if (visible) {
            connectionStem.requestPaint()
        }
    }
}
