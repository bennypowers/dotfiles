import QtQuick
import Quickshell

PanelWindow {
    id: cornerInset

    property int radius: 16
    property color fillColor: "#000000"

    color: "transparent"
    implicitHeight: radius
    implicitWidth: radius

    CornerShape {
        anchors.fill: parent
        fillColor: cornerInset.fillColor
        radius: cornerInset.radius
    }
}
