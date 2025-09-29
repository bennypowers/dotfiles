import QtQuick
import Quickshell

Column {
    id: clockWidget

    // Offset to compensate for asymmetric panel margins
    property int centerOffset: 4  // Adjust this to fine-tune centering

    property int dateFontSize: 12
    readonly property string dateFormat: "MMM d"

    // Font properties with optional overrides - access root via Quickshell.root
    property string fontFamily: "Liberation Sans"
    property int timeFontSize: 18

    // Format properties
    readonly property string timeFormat: "hh:mm"
    readonly property string weekFormat: "ddd"

    spacing: 4

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: {
            const now = new Date();
            timeText.text = Qt.formatTime(now, clockWidget.timeFormat);
            dateText.text = Qt.formatDate(now, clockWidget.dateFormat);
            weekText.text = Qt.formatDate(now, clockWidget.weekFormat);
        }
    }
    Rectangle {
        color: "transparent"
        height: timeText.height + 8
        radius: 6
        width: parent.width

        Text {
            id: timeText

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
            color: "#cdd6f4"
            font.bold: true
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.timeFontSize
            text: Qt.formatTime(new Date(), clockWidget.timeFormat)
        }
    }
    Rectangle {
        color: "transparent"
        height: weekText.height + 0
        radius: 6
        width: parent.width

        Text {
            id: weekText

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
            color: "#a6adc8"
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.dateFontSize
            text: Qt.formatDate(new Date(), clockWidget.weekFormat)
        }
    }
    Rectangle {
        color: "transparent"
        height: dateText.height + 0
        radius: 6
        width: parent.width

        Text {
            id: dateText

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clockWidget.centerOffset
            color: "#a6adc8"
            font.family: clockWidget.fontFamily
            font.pixelSize: clockWidget.dateFontSize
            text: Qt.formatDate(new Date(), clockWidget.dateFormat)
        }
    }
}
