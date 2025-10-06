import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: clockWidget

    property int dateFontSize: 18
    readonly property string dateFormat: "dddd MMMM d"

    // Font properties with optional overrides - access root via Quickshell.root
    property string fontFamily: "Liberation Sans"
    property string hebrewDate: ""
    property bool popoverVisible: false
    property int timeFontSize: 18

    // Format properties
    readonly property string timeFormat: "h:mm AP"

    implicitHeight: clockRow.height
    implicitWidth: clockRow.width

    Row {
        id: clockRow

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

        // Update Hebrew date once per minute
        Timer {
            interval: 60000
            repeat: true
            running: true

            onTriggered: {
                hebrewDateProcess.running = true;
            }
        }
        Text {
            id: hebrewDateText

            anchors.verticalCenter: parent.verticalCenter
            color: "#a6adc8"
            font.family: "Deja Vu Serif"
            font.pixelSize: clockWidget.dateFontSize
            text: clockWidget.hebrewDate
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
    MouseArea {
        anchors.fill: parent

        onClicked: {
            clockWidget.popoverVisible = !clockWidget.popoverVisible;
        }
    }
    ClockPopover {
        id: clockPopover

        leftMargin: {
            // Center the popover under the clock widget
            var globalPos = clockWidget.mapToItem(null, 0, 0);
            if (globalPos) {
                return Math.max(0, globalPos.x + (clockWidget.width / 2) - (popoverWidth / 2));
            }
            return 0;
        }
        topMargin: 0  // Flush with bottom of panel
        visible: clockWidget.popoverVisible

        onVisibleChanged: {
            if (!visible) {
                clockWidget.popoverVisible = false;
            }
        }
    }

    // Hebrew date process using hdate
    Process {
        id: hebrewDateProcess

        command: ["bash", "-c", "hebcal --lang he --city jerusalem -iT | head -1"]

        stdout: SplitParser {
            onRead: function (data) {
                if (data && data.trim()) {
                    clockWidget.hebrewDate = data.trim();
                }
            }
        }

        Component.onCompleted: {
            running = true;
        }
    }
}
