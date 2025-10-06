import QtQuick
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: cornerInset

    property int radius: 16
    property color fillColor: "#000000"

    color: "transparent"
    implicitHeight: radius
    implicitWidth: radius

    Shape {
        anchors.fill: parent

        ShapePath {
            fillColor: cornerInset.fillColor
            strokeColor: "transparent"

            startX: 0
            startY: 0

            PathArc {
                radiusX: cornerInset.radius
                radiusY: cornerInset.radius
                x: cornerInset.radius
                y: cornerInset.radius
            }
            PathLine {
                x: cornerInset.radius
                y: 0
            }
            PathLine {
                x: 0
                y: 0
            }
        }
    }
}
