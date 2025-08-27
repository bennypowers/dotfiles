import QtQuick
import QtQuick.Window

Window {
    id: tooltipWindow

    property string tooltipText: ""
    property alias transientParent: tooltipWindow.transientParent
    property string fontFamily: "Liberation Mono"
    property int fontSize: 14
    property string backgroundColor: "#45475a"
    property string borderColor: "#6c7086"
    property string textColor: "#cdd6f4"

    width: tooltipContent.width + 16
    height: tooltipContent.height + 12

    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.BypassWindowManagerHint | Qt.WindowDoesNotAcceptFocus
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: tooltipWindow.backgroundColor
        border.color: tooltipWindow.borderColor
        border.width: 1
        radius: 6

        Text {
            id: tooltipContent
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
        }
    }

    function showAt(x, y, text) {
        tooltipText = text
        // Position tooltip with bottom-left anchor
        tooltipWindow.x = x
        tooltipWindow.y = y - height
        visible = true
    }

    function updateText(text) {
        tooltipText = text
    }

    function hide() {
        visible = false
    }
}
