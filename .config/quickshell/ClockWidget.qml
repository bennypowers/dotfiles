import QtQuick
import Quickshell

Row {
    id: clockWidget

    property int dateFontSize: 18
    readonly property string dateFormat: "dddd MMMM d"

    // Font properties with optional overrides - access root via Quickshell.root
    property string fontFamily: "Liberation Sans"
    property int timeFontSize: 18

    // Format properties
    readonly property string timeFormat: "h:mm AP"

    spacing: 8

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: {
            const now = new Date();
            timeText.text = Qt.formatTime(now, clockWidget.timeFormat);
            dateText.text = Qt.formatDate(now, clockWidget.dateFormat);
        }
    }
    Text {
        id: timeText

        anchors.verticalCenter: parent.verticalCenter
        color: "#cdd6f4"
        font.bold: true
        font.family: clockWidget.fontFamily
        font.pixelSize: clockWidget.timeFontSize
        text: Qt.formatTime(new Date(), clockWidget.timeFormat)
    }
    Text {
        id: dateText

        anchors.verticalCenter: parent.verticalCenter
        color: "#a6adc8"
        font.family: clockWidget.fontFamily
        font.pixelSize: clockWidget.dateFontSize
        text: Qt.formatDate(new Date(), clockWidget.dateFormat)
    }
}
