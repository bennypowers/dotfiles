import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pam

Window {
    id: lockScreen

    property bool authInProgress: false
    property string currentUser: "User"

    // Properties
    property bool locked: false

    signal lockRequested

    // Signals
    signal unlocked

    function hide() {
        console.log("Hiding lock screen");
        lockScreen.locked = false;
        lockScreen.visible = false;
        lockScreen.authInProgress = false;
    }

    // Functions
    function show() {
        console.log("Showing lock screen");
        lockScreen.locked = true;
        lockScreen.visible = true;
        passwordField.text = "";
        passwordField.forceActiveFocus();
        errorText.visible = false;
    }
    function startAuthentication() {
        console.log("Starting lock screen authentication");
        if (passwordField.text.length === 0) {
            errorText.text = "Please enter a password";
            errorText.visible = true;
            errorTimer.start();
            return;
        }

        lockScreen.authInProgress = true;
        errorText.visible = false;
        pamContext.start();
    }

    color: "transparent"
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    height: Screen.desktopAvailableHeight
    visible: false

    // Cover all screens
    width: Screen.desktopAvailableWidth
    x: 0
    y: 0

    // Handle authentication response
    Component.onCompleted: {
        // PAM context is ready for use
        console.log("LockScreen component loaded");
    }

    // Auto-focus password field when shown
    onVisibleChanged: {
        if (visible) {
            passwordField.forceActiveFocus();
        }
    }

    Colors {
        id: colors

    }

    // PAM context for authentication
    PamContext {
        id: pamContext

        config: "login"  // Use login config for lock screen

        onCompleted: function (result) {
            console.log("Lock screen PAM auth completed:", result);
            lockScreen.authInProgress = false;

            if (result === PamResult.Success) {
                console.log("Lock screen unlocked successfully");
                lockScreen.hide();
                lockScreen.unlocked();
            } else {
                console.log("Lock screen authentication failed");
                passwordField.text = "";
                passwordField.forceActiveFocus();
                errorText.text = "Authentication failed";
                errorText.visible = true;
                errorTimer.start();
            }
        }
        onError: function (error) {
            console.log("Lock screen PAM auth error:", error);
            lockScreen.authInProgress = false;
            passwordField.text = "";
            passwordField.forceActiveFocus();
            errorText.text = "Authentication error";
            errorText.visible = true;
            errorTimer.start();
        }
        onPamMessage: function (message) {
            console.log("Lock screen PAM message:", message);
        }
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: colors.base
        opacity: 0.95

        // Blur effect would be nice but let's keep it simple

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
                    Layout.alignment: Qt.AlignHCenter
                    color: colors.text
                    font.bold: true
                    font.family: colors.fontFamily
                    font.pixelSize: 72
                    text: Qt.formatDateTime(new Date(), "hh:mm")
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
                    text: "Welcome back, " + lockScreen.currentUser
                }

                // Password input
                TextField {
                    id: passwordField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.topMargin: colors.spacing * 4
                    color: colors.text
                    echoMode: TextInput.Password
                    enabled: !lockScreen.authInProgress
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

                    Keys.onEscapePressed: passwordField.text = ""
                    Keys.onReturnPressed: lockScreen.startAuthentication()
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
                    color: lockScreen.authInProgress ? colors.yellow : colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    opacity: lockScreen.authInProgress ? 1.0 : 0.7
                    text: lockScreen.authInProgress ? "Authenticating..." : "Type password and press Enter"
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
}
