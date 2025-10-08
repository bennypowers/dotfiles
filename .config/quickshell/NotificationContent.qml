import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Item {
    id: notificationContent

    required property Notification notification
    property bool isFirst: false
    property bool isLast: false
    property bool hovered: mouseArea.containsMouse

    width: 380
    height: contentColumn.height + 32  // 16px padding top and bottom

    Colors {
        id: colors
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        z: -1  // Behind content so buttons work

        onClicked: {
            if (notification) {
                notification.dismiss();
            }
        }
    }

    ColumnLayout {
        id: contentColumn

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: colors.spacing * 2

        // Header row
        RowLayout {
            Layout.fillWidth: true
            spacing: colors.spacing * 2

            // App icon
            Image {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                source: notification ? (notification.appIcon || notification.image || "") : ""
                visible: source != ""
                fillMode: Image.PreserveAspectFit
            }

            // App name
            Text {
                Layout.fillWidth: true
                text: notification ? notification.appName : ""
                color: colors.subtext
                font.family: colors.fontFamily
                font.pixelSize: colors.smallTextSize
                elide: Text.ElideRight
            }

            // Close button
            Text {
                text: "✕"
                color: colors.overlay
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if (notification) {
                            notification.dismiss();
                        }
                    }
                }
            }
        }

        // Summary (title)
        Text {
            Layout.fillWidth: true
            text: notification ? notification.summary : ""
            color: colors.text
            font.family: colors.fontFamily
            font.pixelSize: colors.textSize
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
        }

        // Body
        Text {
            Layout.fillWidth: true
            text: notification ? notification.body : ""
            color: colors.subtext
            font.family: colors.fontFamily
            font.pixelSize: colors.smallTextSize
            wrapMode: Text.Wrap
            maximumLineCount: 4
            elide: Text.ElideRight
            visible: notification && notification.body !== ""
            textFormat: Text.PlainText
        }

        // Notification image
        Image {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            source: notification ? (notification.image || "") : ""
            visible: {
                if (!notification) return false;
                return source != "" && source != notification.appIcon;
            }
            fillMode: Image.PreserveAspectFit
        }

        // Actions
        Flow {
            Layout.fillWidth: true
            spacing: colors.spacing
            visible: notification && notification.actions.length > 0

            Repeater {
                model: notification ? notification.actions : []

                Button {
                    text: modelData.text

                    background: Rectangle {
                        color: parent.hovered ? colors.blue : colors.overlay
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
                        modelData.invoke();
                        if (notification) {
                            notification.dismiss();
                        }
                    }
                }
            }
        }

        // Inline reply
        RowLayout {
            Layout.fillWidth: true
            visible: notification && notification.hasInlineReply
            spacing: colors.spacing

            TextField {
                id: replyField

                Layout.fillWidth: true
                placeholderText: notification ? (notification.inlineReplyPlaceholder || "Type a reply...") : "Type a reply..."
                color: colors.text
                font.family: colors.fontFamily
                font.pixelSize: colors.smallTextSize

                background: Rectangle {
                    color: colors.base
                    radius: colors.borderRadius
                    border.color: replyField.activeFocus ? colors.blue : colors.overlay
                    border.width: 1
                }

                Keys.onReturnPressed: sendButton.clicked()
            }

            Button {
                id: sendButton

                text: "Send"

                background: Rectangle {
                    color: parent.hovered ? colors.blue : colors.overlay
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
                    if (replyField.text !== "" && notification) {
                        notification.sendInlineReply(replyField.text);
                        notification.dismiss();
                    }
                }
            }
        }
    }

    // Separator line (except for last notification)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        height: 1
        color: colors.overlay
        visible: !notificationContent.isLast
    }
}
