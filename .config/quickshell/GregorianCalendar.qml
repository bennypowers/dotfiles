import QtQuick
import QtQuick.Controls

Column {
    id: gregorianCalendar

    // Properties
    property var currentDate: new Date()
    property var colors  // Colors from parent
    property var getHoliday: function(day) { return ""; }  // Function to get holiday name for a day

    spacing: 8

    // Header
    Text {
        color: colors ? colors.subtext : "#a6adc8"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 11
        text: Qt.formatDate(gregorianCalendar.currentDate, "MMMM yyyy").toUpperCase()
    }

    // Day names header
    Grid {
        columnSpacing: 4
        columns: 7
        width: parent.width

        Repeater {
            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

            delegate: Text {
                required property string modelData

                color: gregorianCalendar.colors ? gregorianCalendar.colors.overlay : "#6c7086"
                font.family: "JetBrainsMono Nerd Font"
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

        property int daysInMonth: {
            var date = new Date(gregorianCalendar.currentDate.getFullYear(),
                              gregorianCalendar.currentDate.getMonth() + 1, 0);
            return date.getDate();
        }
        property int firstDayOfWeek: {
            var date = new Date(gregorianCalendar.currentDate.getFullYear(),
                              gregorianCalendar.currentDate.getMonth(), 1);
            return date.getDay();
        }
        property int today: gregorianCalendar.currentDate.getDate()

        columnSpacing: 4
        columns: 7
        rowSpacing: 4
        width: parent.width

        Repeater {
            model: grid.firstDayOfWeek + grid.daysInMonth

            delegate: Rectangle {
                property int day: index - grid.firstDayOfWeek + 1
                required property int index
                property bool isToday: day === grid.today && index >= grid.firstDayOfWeek
                property string holidayName: index >= grid.firstDayOfWeek ? gregorianCalendar.getHoliday(day) : ""
                property bool isHoliday: holidayName !== ""

                color: {
                    if (!gregorianCalendar.colors) return "transparent";
                    if (isToday) return gregorianCalendar.colors.blue;
                    if (isHoliday) return gregorianCalendar.colors.mauve;
                    return "transparent";
                }
                height: 28
                radius: 4
                width: (grid.width - grid.columnSpacing * 6) / 7

                Text {
                    id: dayText
                    anchors.centerIn: parent
                    color: {
                        if (!gregorianCalendar.colors) return "#cdd6f4";
                        if (parent.isToday)
                            return gregorianCalendar.colors.base;
                        if (parent.isHoliday)
                            return gregorianCalendar.colors.base;
                        if (index < grid.firstDayOfWeek)
                            return "transparent";
                        return gregorianCalendar.colors.text;
                    }
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    text: index < grid.firstDayOfWeek ? "" : parent.day
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
}
