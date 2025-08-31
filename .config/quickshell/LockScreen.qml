import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pam

Window {
    id: lockScreen
    visible: false
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    color: "transparent"

    // Cover all screens
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    x: 0
    y: 0

    Colors { id: colors }

    // Properties
    property bool locked: false
    property bool authInProgress: false
    property string currentUser: "User"

    // Signals
    signal unlocked()
    signal lockRequested()

    // PAM context for authentication
    PamContext {
        id: pamContext
        config: "login"  // Use login config for lock screen

        onCompleted: function(result) {
            console.log("Lock screen PAM auth completed:", result)
            lockScreen.authInProgress = false

            if (result === PamResult.Success) {
                console.log("Lock screen unlocked successfully")
                lockScreen.hide()
                lockScreen.unlocked()
            } else {
                console.log("Lock screen authentication failed")
                passwordField.text = ""
                passwordField.forceActiveFocus()
                errorText.text = "Authentication failed"
                errorText.visible = true
                errorTimer.start()
            }
        }

        onError: function(error) {
            console.log("Lock screen PAM auth error:", error)
            lockScreen.authInProgress = false
            passwordField.text = ""
            passwordField.forceActiveFocus()
            errorText.text = "Authentication error"
            errorText.visible = true
            errorTimer.start()
        }

        onPamMessage: function(message) {
            console.log("Lock screen PAM message:", message)
        }
    }

    // Functions
    function show() {
        console.log("Showing lock screen")
        lockScreen.locked = true
        lockScreen.visible = true
        passwordField.text = ""
        passwordField.forceActiveFocus()
        errorText.visible = false
    }

    function hide() {
        console.log("Hiding lock screen")
        lockScreen.locked = false
        lockScreen.visible = false
        lockScreen.authInProgress = false
    }

    function startAuthentication() {
        console.log("Starting lock screen authentication")
        if (passwordField.text.length === 0) {
            errorText.text = "Please enter a password"
            errorText.visible = true
            errorTimer.start()
            return
        }

        lockScreen.authInProgress = true
        errorText.visible = false
        pamContext.start()
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
            width: 400
            height: 500

            ColumnLayout {
                anchors.fill: parent
                spacing: colors.spacing * 8

                // Time display
                Text {
                    text: Qt.formatDateTime(new Date(), "hh:mm")
                    color: colors.text
                    font.family: colors.fontFamily
                    font.pixelSize: 72
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                // Date display
                Text {
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                    color: colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    Layout.alignment: Qt.AlignHCenter
                }

                // User info
                Text {
                    text: "Welcome back, " + lockScreen.currentUser
                    color: colors.green
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: colors.spacing * 4
                }

                // Password input
                TextField {
                    id: passwordField
                    placeholderText: "Enter password to unlock..."
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.topMargin: colors.spacing * 4

                    background: Rectangle {
                        color: colors.surface
                        border.color: passwordField.activeFocus ? colors.blue : colors.overlay
                        border.width: 2
                        radius: colors.borderRadius * 2
                    }

                    color: colors.text
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: TextInput.AlignHCenter

                    Keys.onReturnPressed: lockScreen.startAuthentication()
                    Keys.onEscapePressed: passwordField.text = ""

                    enabled: !lockScreen.authInProgress
                }

                // Error message
                Text {
                    id: errorText
                    text: ""
                    color: colors.red
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    Layout.alignment: Qt.AlignHCenter
                    visible: false

                    Timer {
                        id: errorTimer
                        interval: 3000
                        onTriggered: errorText.visible = false
                    }
                }

                // Status message
                Text {
                    text: lockScreen.authInProgress ? "Authenticating..." : "Type password and press Enter"
                    color: lockScreen.authInProgress ? colors.yellow : colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    Layout.alignment: Qt.AlignHCenter
                    opacity: lockScreen.authInProgress ? 1.0 : 0.7
                }

                // Spacer
                Item {
                    Layout.fillHeight: true
                }

                // Instructions
                Text {
                    text: "Press Escape to clear • Enter to authenticate"
                    color: colors.overlay
                    font.family: colors.fontFamily
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // Auto-focus password field when shown
    onVisibleChanged: {
        if (visible) {
            passwordField.forceActiveFocus()
        }
    }

    // Handle authentication response
    Component.onCompleted: {
        // Connect to PAM response handling
        pamContext.onResponseRequired.connect(function() {
            if (passwordField.text.length > 0) {
                pamContext.respond(passwordField.text)
            }
        })
    }
}
