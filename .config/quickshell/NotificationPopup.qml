import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

WlrLayershell {
    id: notificationPopup

    required property Notification notification

    property int notificationTimeout: 5000
    property bool hovered: mouseArea.containsMouse
    property int cornerRadius: 16
    property int padding: 16
    property int popoverWidth: 380

    color: "transparent"
    exclusiveZone: 0
    keyboardFocus: WlrKeyboardFocus.None
    layer: WlrLayer.Overlay
    namespace: "notification-" + (notification ? notification.id : 0)

    implicitWidth: popoverWidth + cornerRadius  // Extra space for top-right corner
    implicitHeight: contentColumn.height + padding * 2 + cornerRadius  // Extra space for bottom-left corner

    anchors {
        top: true
        left: true
    }
    margins {
        top: 0
        left: 0
    }

    Component.onCompleted: {
        // Scale animation on show
        scalableContainer.scale = 0;
        showAnimation.start();

        // Auto-close timeout
        if (!notification.resident && notification.expireTimeout > 0) {
            closeTimer.interval = notification.expireTimeout;
            closeTimer.start();
        } else if (!notification.resident) {
            closeTimer.interval = notificationTimeout;
            closeTimer.start();
        }
    }

    // Auto-close timer
    Timer {
        id: closeTimer

        running: false
        repeat: false

        onTriggered: {
            if (!notificationPopup.hovered) {
                hideAnimation.start();
            } else {
                closeTimer.start();
            }
        }
    }

    // Show animation
    NumberAnimation {
        id: showAnimation

        target: scalableContainer
        property: "scale"
        from: 0
        to: 1
        duration: 150
        easing.type: Easing.OutQuad
    }

    // Hide animation
    SequentialAnimation {
        id: hideAnimation

        NumberAnimation {
            target: scalableContainer
            property: "scale"
            to: 0
            duration: 150
            easing.type: Easing.InQuad
        }

        ScriptAction {
            script: {
                if (notification) {
                    notification.expire();
                }
                notificationPopup.visible = false;
            }
        }
    }

    Colors {
        id: colors
    }

    // Animated container
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: Item.TopLeft

        // Top-right corner (fills the space to the right of the background)
        CornerShape {
            fillColor: colors.black
            width: cornerRadius
            height: cornerRadius
            radius: cornerRadius
            rotation: 270
            x: popoverWidth
            y: 0
        }

        // Bottom-left corner (fills the space below the background)
        CornerShape {
            fillColor: colors.black
            width: cornerRadius
            height: cornerRadius
            radius: cornerRadius
            rotation: 270
            x: 0
            y: contentColumn.height + padding * 2
        }

        // Background with rounded corners
        Rectangle {
            id: background

            x: 0
            y: 0
            width: popoverWidth
            height: contentColumn.height + padding * 2
            color: colors.black
            radius: 16
            topLeftRadius: 16
            topRightRadius: 0
            bottomLeftRadius: 0
            bottomRightRadius: 16

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    if (notification) {
                        notification.dismiss();
                    }
                    hideAnimation.start();
                }
            }

            ColumnLayout {
                id: contentColumn

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: padding
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
                                hideAnimation.start();
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
                                hideAnimation.start();
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
                                hideAnimation.start();
                            }
                        }
                    }
                }
            }
        }
    }
}
