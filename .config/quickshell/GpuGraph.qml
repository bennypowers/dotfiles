import QtQuick

Item {
    id: graph

    property var dataPoints: []
    property string lineColor: "#89b4fa"
    property string fillColor: "#89b4fa"
    property real maxValue: 100
    property real minValue: 0
    property bool showFill: true
    property bool showGrid: true
    property int gridLines: 4
    property string gridColor: "#45475a"
    property real lineWidth: 2

    implicitHeight: 80
    implicitWidth: 300

    Colors {
        id: colors

    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: colors.mantle
        opacity: 0.3
        radius: 4
    }

    // Grid lines
    Canvas {
        id: gridCanvas

        anchors.fill: parent
        visible: graph.showGrid

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = graph.gridColor;
            ctx.lineWidth = 1;
            ctx.globalAlpha = 0.3;
            // Horizontal grid lines
            for (var i = 0; i <= graph.gridLines; i++) {
                var y = (height / graph.gridLines) * i;
                ctx.beginPath();
                ctx.moveTo(0, y);
                ctx.lineTo(width, y);
                ctx.stroke();
            }
        }
    }

    // Graph canvas
    Canvas {
        id: graphCanvas

        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            if (graph.dataPoints.length < 2)
                return;
            var padding = 4;
            var graphWidth = width - 2 * padding;
            var graphHeight = height - 2 * padding;
            var pointSpacing = graphWidth / Math.max(graph.dataPoints.length - 1, 1);
            // Create path for line
            ctx.lineWidth = graph.lineWidth;
            ctx.strokeStyle = graph.lineColor;
            ctx.lineJoin = "round";
            ctx.lineCap = "round";
            // Draw fill if enabled
            if (graph.showFill) {
                var gradient = ctx.createLinearGradient(0, padding, 0, height - padding);
                gradient.addColorStop(0, graph.fillColor + "60");
                gradient.addColorStop(1, graph.fillColor + "10");
                ctx.fillStyle = gradient;
                ctx.beginPath();
                ctx.moveTo(padding, height - padding);
                for (var i = 0; i < graph.dataPoints.length; i++) {
                    var x = padding + i * pointSpacing;
                    var normalizedValue = (graph.dataPoints[i] - graph.minValue) / (graph.maxValue - graph.minValue);
                    var y = height - padding - normalizedValue * graphHeight;
                    if (i === 0)
                        ctx.lineTo(x, y);
                    else
                        ctx.lineTo(x, y);
                }
                ctx.lineTo(padding + (graph.dataPoints.length - 1) * pointSpacing, height - padding);
                ctx.closePath();
                ctx.fill();
            }
            // Draw line
            ctx.beginPath();
            for (var j = 0; j < graph.dataPoints.length; j++) {
                var x2 = padding + j * pointSpacing;
                var normalizedValue2 = (graph.dataPoints[j] - graph.minValue) / (graph.maxValue - graph.minValue);
                var y2 = height - padding - normalizedValue2 * graphHeight;
                if (j === 0)
                    ctx.moveTo(x2, y2);
                else
                    ctx.lineTo(x2, y2);
            }
            ctx.stroke();
        }
    }

    // Redraw when data changes
    onDataPointsChanged: {
        graphCanvas.requestPaint();
    }
    onWidthChanged: {
        gridCanvas.requestPaint();
        graphCanvas.requestPaint();
    }
    onHeightChanged: {
        gridCanvas.requestPaint();
        graphCanvas.requestPaint();
    }
}
