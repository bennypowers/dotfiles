import QtQuick
import Quickshell.Wayland

WlrLayershell {
    id: popover

    property int cornerRadius: 16

    // Date/time properties
    property var currentDate: new Date()
    property int leftMargin: 0
    property int popoverPadding: 16
    property int popoverWidth: 380
    property int sectionSpacing: 12
    property int topMargin: 0

    color: "transparent"
    exclusiveZone: 0
    height: contentColumn.height + popoverPadding * 2
    layer: WlrLayer.Overlay
    namespace: "quickshell-clock-popover"
    visible: false
    width: popoverWidth

    onVisibleChanged: {
        if (visible) {
            scalableContainer.scale = 0;
            showAnimation.start();
            console.log("📍 Clock popover leftMargin:", leftMargin, "topMargin:", topMargin);
            console.log("📍 Setting topLeftInset to:", leftMargin - cornerRadius, 48);
            console.log("📍 Setting topRightInset to:", leftMargin + popoverWidth, 48);
            topLeftInset.margins.left = leftMargin - cornerRadius;
            topLeftInset.margins.top = 48;  // Corners at bottom of 48px panel
            topRightInset.margins.left = leftMargin + popoverWidth;
            topRightInset.margins.top = 48;  // Corners at bottom of 48px panel
            // Update current date when showing
            currentDate = new Date();
        } else {
            hideAnimation.start();
            topLeftInset.margins.left = 0;
            topLeftInset.margins.top = 0;
            topRightInset.margins.left = 0;
            topRightInset.margins.top = 0;
        }
    }

    anchors {
        left: true
        top: true
    }
    margins {
        left: leftMargin
        top: topMargin
    }
    Colors {
        id: colors

    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: Item.Top

        // Background with rounded corners
        Rectangle {
            id: background

            anchors.fill: parent
            bottomLeftRadius: 16
            bottomRightRadius: 16
            color: colors.black
            layer.enabled: true
            topLeftRadius: 0
            topRightRadius: 0
        }

        // Content column
        Column {
            id: contentColumn

            anchors.left: parent.left
            anchors.leftMargin: popoverPadding
            anchors.right: parent.right
            anchors.rightMargin: popoverPadding
            anchors.top: parent.top
            anchors.topMargin: popoverPadding
            spacing: sectionSpacing

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

    // Show animation
    PropertyAnimation {
        id: showAnimation

        duration: 150
        easing.type: Easing.OutQuad
        from: 0
        properties: "scale"
        target: scalableContainer
        to: 1
    }
    // Hide animation
    PropertyAnimation {
        id: hideAnimation

        duration: 150
        easing.type: Easing.InQuad
        from: 1
        properties: "scale"
        target: scalableContainer
        to: 0
    }

    // Click outside to close
    MouseArea {
        anchors.fill: parent
        z: -1

        onClicked: {
            popover.visible = false;
        }
    }

    // Top-left corner inset
    WlrLayershell {
        id: topLeftInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-clock-popover-corner-tl"
        visible: popover.visible
        width: cornerRadius

        anchors {
            left: true
            top: true
        }
        margins {
            left: 0
            top: 0

            Behavior on left {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }

    // Top-right corner inset
    WlrLayershell {
        id: topRightInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-clock-popover-corner-tr"
        visible: popover.visible
        width: cornerRadius

        anchors {
            left: true
            top: true
        }
        margins {
            left: 0
            top: 0

            Behavior on left {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
            rotation: 270
        }
    }
}
