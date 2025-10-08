import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

BasePopover {
    id: notificationCenter

    required property NotificationServer notificationServer

    popoverWidth: 400
    popoverPadding: 0  // No padding, content fills entire width
    namespace: "notification-center"

    Colors {
        id: colors
    }

    ColumnLayout {
        spacing: 0

        // Header
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 16
            Layout.bottomMargin: 8
            spacing: colors.spacing * 2

            Text {
                Layout.fillWidth: true
                text: "Notifications"
                color: colors.text
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                font.bold: true
            }

            Button {
                text: "Clear All"
                visible: notificationServer && notificationServer.trackedNotifications.values.length > 0

                background: Rectangle {
                    color: parent.hovered ? colors.red : colors.overlay
                    radius: colors.borderRadius
                }

                contentItem: Text {
                    text: parent.text
                    color: colors.text
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    if (!notificationServer) return;
                    // Dismiss all tracked notifications
                    const notifications = notificationServer.trackedNotifications.values;
                    for (let i = 0; i < notifications.length; i++) {
                        notifications[i].dismiss();
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: colors.overlay
        }

        // Notification list
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 400
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                width: 400  // Full popover width
                spacing: 0

                Repeater {
                    model: notificationServer ? notificationServer.trackedNotifications : null

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: notifContent.implicitHeight + 24
                        color: notifMouseArea.containsMouse ? colors.overlay : "transparent"

                        MouseArea {
                            id: notifMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                        }

                        ColumnLayout {
                            id: notifContent

                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: colors.spacing

                            // Header
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: colors.spacing * 2

                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    source: modelData.appIcon || modelData.image || ""
                                    visible: source != ""
                                    fillMode: Image.PreserveAspectFit
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.appName
                                    color: colors.subtext
                                    font.family: colors.fontFamily
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: "✕"
                                    color: colors.overlay
                                    font.family: colors.fontFamily
                                    font.pixelSize: colors.smallTextSize

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            modelData.dismiss();
                                        }
                                    }
                                }
                            }

                            // Summary
                            Text {
                                Layout.fillWidth: true
                                text: modelData.summary
                                color: colors.text
                                font.family: colors.fontFamily
                                font.pixelSize: colors.smallTextSize
                                font.bold: true
                                wrapMode: Text.Wrap
                                maximumLineCount: 1
                                elide: Text.ElideRight
                            }

                            // Body
                            Text {
                                Layout.fillWidth: true
                                text: modelData.body
                                color: colors.subtext
                                font.family: colors.fontFamily
                                font.pixelSize: 10
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                visible: modelData.body !== ""
                                textFormat: Text.PlainText
                            }

                            // Actions
                            Flow {
                                Layout.fillWidth: true
                                spacing: colors.spacing
                                visible: modelData.actions.length > 0

                                Repeater {
                                    model: modelData.actions

                                    Button {
                                        text: modelData.text

                                        background: Rectangle {
                                            color: parent.hovered ? colors.blue : colors.base
                                            radius: colors.borderRadius
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: colors.text
                                            font.family: colors.fontFamily
                                            font.pixelSize: 9
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            modelData.invoke();
                                            notificationCenter.modelData.dismiss();
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: colors.overlay
                        }
                    }
                }

                // Empty state
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    visible: !notificationServer || notificationServer.trackedNotifications.values.length === 0

                    Text {
                        anchors.centerIn: parent
                        text: "No notifications"
                        color: colors.subtext
                        font.family: colors.fontFamily
                        font.pixelSize: colors.textSize
                    }
                }
            }
        }
    }
}
