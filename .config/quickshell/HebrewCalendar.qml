import QtQuick
import QtQuick.Controls

Column {
    id: hebrewCalendar

    // Properties
    property string monthName: ""
    property string year: ""
    property int monthLength: 30
    property int firstDayOfWeek: 0
    property int today: 1
    property var colors  // Colors from parent
    property var getHoliday: function(day) { return ""; }  // Function to get holiday name for a day

    spacing: 8
    LayoutMirroring.enabled: true
    LayoutMirroring.childrenInherit: true

    // Header
    Text {
        color: colors ? colors.subtext : "#a6adc8"
        font.family: "Deja Vu Serif"
        font.pixelSize: 11
        text: hebrewCalendar.monthName + " " + hebrewCalendar.year
    }

    // Day names header
    Grid {
        columnSpacing: 4
        columns: 7
        width: parent.width

        Repeater {
            model: ["א׳", "ב׳", "ג׳", "ד׳", "ה׳", "ו׳", "ש׳"]

            delegate: Text {
                required property string modelData

                color: hebrewCalendar.colors ? hebrewCalendar.colors.overlay : "#6c7086"
                font.family: "Deja Vu Serif"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                width: (parent.width - parent.columnSpacing * 6) / 7
            }
        }
    }

    // Calendar grid
    Grid {
        id: grid

        columnSpacing: 4
        columns: 7
        rowSpacing: 4
        width: parent.width

        Repeater {
            model: hebrewCalendar.firstDayOfWeek + hebrewCalendar.monthLength

            delegate: Rectangle {
                property int day: index - hebrewCalendar.firstDayOfWeek + 1
                required property int index
                property bool isToday: day === hebrewCalendar.today && index >= hebrewCalendar.firstDayOfWeek
                property string holidayName: index >= hebrewCalendar.firstDayOfWeek ? hebrewCalendar.getHoliday(day) : ""
                property bool isHoliday: holidayName !== ""

                color: {
                    if (!hebrewCalendar.colors) return "transparent";
                    if (isToday) return hebrewCalendar.colors.blue;
                    if (isHoliday) return hebrewCalendar.colors.mauve;
                    return "transparent";
                }
                height: 28
                radius: 4
                width: (grid.width - grid.columnSpacing * 6) / 7

                Text {
                    id: dayText
                    anchors.centerIn: parent
                    color: {
                        if (!hebrewCalendar.colors) return "#cdd6f4";
                        if (parent.isToday)
                            return hebrewCalendar.colors.base;
                        if (parent.isHoliday)
                            return hebrewCalendar.colors.base;
                        if (index < hebrewCalendar.firstDayOfWeek)
                            return "transparent";
                        return hebrewCalendar.colors.text;
                    }
                    font.family: "Deja Vu Serif"
                    font.pixelSize: 11
                    text: {
                        if (index < hebrewCalendar.firstDayOfWeek)
                            return "";
                        return convertToHebrewNumeral(parent.day);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: parent.isHoliday
                    hoverEnabled: true

                    ToolTip.visible: containsMouse && parent.isHoliday
                    ToolTip.text: parent.holidayName
                    ToolTip.delay: 500
                }
            }
        }
    }

    // Helper function to convert numbers to Hebrew numerals
    function convertToHebrewNumeral(num) {
        var ones = ["", "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט"];
        var tens = ["", "י", "כ", "ל"];

        if (num < 1 || num > 30) return num.toString();

        var tensDigit = Math.floor(num / 10);
        var onesDigit = num % 10;

        var result = tens[tensDigit] + ones[onesDigit];

        // Add geresh or gershayim
        if (result.length === 1) {
            result += "׳";
        } else if (result.length > 1) {
            result = result.slice(0, -1) + "״" + result.slice(-1);
        }

        return result;
    }
}
