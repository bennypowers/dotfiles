import QtQuick
import Quickshell

Column {
    id: clockWidget
    spacing: 4

    // Format properties
    readonly property string timeFormat: "hh:mm"
    readonly property string dateFormat: "MMM d"
    readonly property string weekFormat: "ddd"

    // Font properties with optional overrides - access root via Quickshell.root
    property string fontFamily: "Liberation Sans"
    property int timeFontSize: 18
    property int dateFontSize: 12

    // Offset to compensate for asymmetric panel margins
    property int centerOffset: 4  // Adjust this to fine-tune centering

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const now = new Date();
            timeText.text = Qt.formatTime(now, clockWidget.timeFormat);
            dateText.text = Qt.formatDate(now, clockWidget.dateFormat);
        }
    }

    Rectangle {
        width: parent.width
        height: timeText.height + 8
        color: "transparent"
        radius: 6

        Text {
            id: timeText
            text: Qt.formatTime(new Date(), clockWidget.timeFormat)
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.timeFontSize
            font.bold: true
            color: "#cdd6f4"
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
        }
    }

    Rectangle {
        width: parent.width
        height: weekText.height + 0
        color: "transparent"
        radius: 6

        Text {
            id: weekText
            text: Qt.formatDate(new Date(), clockWidget.weekFormat)
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.dateFontSize
            color: "#a6adc8"
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
        }
    }

    Rectangle {
        width: parent.width
        height: dateText.height + 0
        color: "transparent"
        radius: 6

        Text {
            id: dateText
            text: Qt.formatDate(new Date(), clockWidget.dateFormat)
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.dateFontSize
            color: "#a6adc8"
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
        }
    }
}
