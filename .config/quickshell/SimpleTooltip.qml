import QtQuick

NodeTooltip {
    id: tooltipWindow

    property string tooltipText: ""

    Text {
        id: tooltipContent
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
    }

    function showAt(x, y, text, side, connX, connY) {
        tooltipText = text
        
        // Set connection properties and show
        connectionSide = side || "top"
        connectionX = connX || width / 2
        connectionY = connY || height / 2
        
        setTransformOrigin()
        
        tooltipWindow.x = x
        tooltipWindow.y = y
        
        visible = true
        connectionStem.requestPaint()
        showAnimation.start()
    }

    function updateText(text) {
        tooltipText = text
    }
}
