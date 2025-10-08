import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

WlSessionLockSurface {
    id: lockSurface

    required property PamContext pamContext
    required property var lockScreen

    property bool authInProgress: false

    function startAuthentication() {
        console.log("Starting lock screen authentication");
        if (passwordField.text.length === 0) {
            errorText.text = "Please enter a password";
            errorText.visible = true;
            errorTimer.start();
            return;
        }

        lockSurface.authInProgress = true;
        errorText.visible = false;
        lockSurface.pamContext.start();
    }

    color: colors.base

    // Auto-focus password field when shown
    onVisibleChanged: {
        if (visible) {
            passwordField.forceActiveFocus();
        }
    }

    Colors {
        id: colors
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: colors.base
        opacity: 0.95

        // Lock screen content
        Item {
            anchors.centerIn: parent
            height: 500
            width: 400

            ColumnLayout {
                anchors.fill: parent
                spacing: colors.spacing * 8

                // Time display
                Text {
                    id: timeText

                    Layout.alignment: Qt.AlignHCenter
                    color: colors.text
                    font.bold: true
                    font.family: colors.fontFamily
                    font.pixelSize: 72
                    text: Qt.formatDateTime(new Date(), "hh:mm")

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true

                        onTriggered: {
                            timeText.text = Qt.formatDateTime(new Date(), "hh:mm");
                        }
                    }
                }

                // Date display
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                }

                // User info
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: colors.spacing * 4
                    color: colors.green
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    text: "Welcome back, " + (lockScreen.currentUser || "User")
                }

                // Password input
                TextField {
                    id: passwordField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.topMargin: colors.spacing * 4
                    color: colors.text
                    echoMode: TextInput.Password
                    enabled: !lockSurface.authInProgress
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: TextInput.AlignHCenter
                    placeholderText: "Enter password to unlock..."

                    background: Rectangle {
                        border.color: passwordField.activeFocus ? colors.blue : colors.overlay
                        border.width: 2
                        color: colors.surface
                        radius: colors.borderRadius * 2
                    }

                    Component.onCompleted: {
                        passwordField.forceActiveFocus();
                    }

                    Keys.onEscapePressed: passwordField.text = ""
                    Keys.onReturnPressed: lockSurface.startAuthentication()
                }

                // Error message
                Text {
                    id: errorText

                    Layout.alignment: Qt.AlignHCenter
                    color: colors.red
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    text: ""
                    visible: false

                    Timer {
                        id: errorTimer

                        interval: 3000

                        onTriggered: errorText.visible = false
                    }
                }

                // Status message
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: lockSurface.authInProgress ? colors.yellow : colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    opacity: lockSurface.authInProgress ? 1.0 : 0.7
                    text: lockSurface.authInProgress ? "Authenticating..." : "Type password and press Enter"
                }

                // Spacer
                Item {
                    Layout.fillHeight: true
                }

                // Instructions
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: colors.overlay
                    font.family: colors.fontFamily
                    font.pixelSize: 10
                    text: "Press Escape to clear • Enter to authenticate"
                }
            }
        }
    }

    // Handle authentication errors
    Connections {
        target: lockSurface.pamContext

        function onError(error) {
            console.log("Lock screen PAM auth error:", error);
            lockSurface.authInProgress = false;
            passwordField.text = "";
            passwordField.forceActiveFocus();
            errorText.text = "Authentication error";
            errorText.visible = true;
            errorTimer.start();
        }
    }
}
