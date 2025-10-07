import QtQuick

BasePopover {
    id: popover

    // Date/time properties
    property var currentDate: new Date()
    property int sectionSpacing: 12

    anchorSide: "left"
    cornerPositions: ["topLeft", "topRight"]
    namespace: "quickshell-clock-popover"

    onVisibleChanged: {
        if (visible) {
            // Update current date when showing
            currentDate = new Date();
        }
    }

    Column {
        id: contentColumn

        spacing: sectionSpacing
        width: parent.width

        // Current date/time header
        Column {
            spacing: 4
            width: parent.width

            Text {
                color: colors.text
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                text: Qt.formatDate(popover.currentDate, "dddd")
            }

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                text: Qt.formatDate(popover.currentDate, "MMMM d, yyyy")
            }
        }

        // Calendar grid
        Column {
            spacing: 8
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                text: "CALENDAR"
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

                        color: colors.overlay
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        width: (parent.width - parent.columnSpacing * 6) / 7
                    }
                }
            }

            // Calendar days
            Grid {
                id: calendarGrid

                property int daysInMonth: {
                    var date = new Date(popover.currentDate.getFullYear(), popover.currentDate.getMonth() + 1, 0);
                    return date.getDate();
                }
                property int firstDayOfWeek: {
                    var date = new Date(popover.currentDate.getFullYear(), popover.currentDate.getMonth(), 1);
                    return date.getDay();
                }
                property int today: popover.currentDate.getDate()

                columnSpacing: 4
                columns: 7
                rowSpacing: 4
                width: parent.width

                Repeater {
                    model: calendarGrid.firstDayOfWeek + calendarGrid.daysInMonth

                    delegate: Rectangle {
                        property int day: index - calendarGrid.firstDayOfWeek + 1
                        required property int index
                        property bool isToday: day === calendarGrid.today && index >= calendarGrid.firstDayOfWeek

                        color: isToday ? colors.blue : "transparent"
                        height: 28
                        radius: 4
                        width: (calendarGrid.width - calendarGrid.columnSpacing * 6) / 7

                        Text {
                            anchors.centerIn: parent
                            color: {
                                if (parent.isToday)
                                    return colors.base;
                                if (index < calendarGrid.firstDayOfWeek)
                                    return "transparent";
                                return colors.text;
                            }
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            text: index < calendarGrid.firstDayOfWeek ? "" : parent.day
                        }
                    }
                }
            }
        }

        // Appointments section (placeholder for Nextcloud)
        Column {
            spacing: 4
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                text: "TODAY'S APPOINTMENTS"
            }

            Text {
                color: colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                text: "No appointments"
            }
        }

        // Tasks section (placeholder for Nextcloud)
        Column {
            spacing: 4
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                text: "TASKS"
            }

            Text {
                color: colors.overlay
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                text: "No tasks"
            }
        }
    }
}
