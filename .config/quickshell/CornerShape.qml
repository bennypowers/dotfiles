import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    property int radius: 16
    property color fillColor: "#000000"

    ShapePath {
        fillColor: root.fillColor
        strokeColor: "transparent"

        startX: 0
        startY: 0

        PathArc {
            radiusX: root.radius
            radiusY: root.radius
            x: root.radius
            y: root.radius
        }
        PathLine {
            x: root.radius
            y: 0
        }
        PathLine {
            x: 0
            y: 0
        }
    }
}
