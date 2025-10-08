import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

Item {
    id: notificationIcon

    required property NotificationServer notificationServer
    required property var notificationContainer

    property bool popoverVisible: false

    implicitWidth: 40
    implicitHeight: 40

    onPopoverVisibleChanged: {
        console.log("NotificationIcon: popoverVisible changed to", popoverVisible);
        if (notificationContainer) {
            console.log("NotificationIcon: setting container.showNotificationCenter to", popoverVisible);
            notificationContainer.showNotificationCenter = popoverVisible;
        } else {
            console.log("NotificationIcon: ERROR - notificationContainer is null");
        }
    }

    Colors {
        id: colors
    }

    Rectangle {
        anchors.centerIn: parent
        width: 32
        height: 32
        color: notificationIcon.popoverVisible ? colors.surface : "transparent"
        radius: colors.borderRadius

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        // Bell icon
        Text {
            anchors.centerIn: parent
            text: "\uf0f3"  // nerdfonts bell icon
            font.family: "Symbols Nerd Font"
            font.pixelSize: 18
            color: colors.text
        }

        // Notification count badge (only for unread)
        Rectangle {
            visible: notificationServer && notificationServer.unreadCount > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: -4
            anchors.topMargin: -4
            width: Math.max(16, countText.width + 6)
            height: 16
            radius: 8
            color: colors.red

            Text {
                id: countText

                anchors.centerIn: parent
                text: notificationServer ? Math.min(notificationServer.unreadCount, 99) : 0
                font.family: colors.fontFamily
                font.pixelSize: 9
                font.bold: true
                color: colors.text
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                notificationIcon.popoverVisible = !notificationIcon.popoverVisible;
                if (notificationIcon.popoverVisible && notificationServer) {
                    // Mark all as read when opening
                    notificationServer.markAllAsRead();
                }
            }
        }
    }

    // Backdrop for closing notification center
    Loader {
        id: backdropLoader
        active: notificationIcon.popoverVisible

        sourceComponent: Component {
            WlrLayershell {
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                color: "transparent"
                exclusiveZone: 0
                keyboardFocus: WlrKeyboardFocus.None
                layer: WlrLayer.Top
                namespace: "notification-center-backdrop"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        notificationIcon.popoverVisible = false;
                    }
                }
            }
        }
    }
}
