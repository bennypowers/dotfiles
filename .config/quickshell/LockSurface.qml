import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

WlSessionLockSurface {
    id: lockSurface

    required property PamContext pamContext
    required property string currentUser

    property bool authInProgress: false
    property string pendingPassword: ""
    property bool u2fPromptActive: false

    signal unlockRequested()

    function startAuthentication() {
        console.log("🔑 Starting lock screen authentication");

        // If already authenticating, abort first
        if (lockSurface.authInProgress && lockSurface.pamContext.active) {
            console.log("🔑 Aborting previous auth attempt");
            lockSurface.pamContext.abort();
        }

        // If U2F is waiting and user entered password, abort and restart with password
        if (lockSurface.u2fPromptActive && passwordField.text.length > 0) {
            console.log("🔑 U2F active but user entered password - aborting U2F");
            lockSurface.pamContext.abort();
            lockSurface.u2fPromptActive = false;
        }

        console.log("🔑 Password field length:", passwordField.text.length);
        errorText.visible = false;

        if (passwordField.text.length === 0) {
            // No password - try U2F only
            console.log("🔑 No password, initiating auth (U2F will be tried first)");
            lockSurface.authInProgress = true;
            lockSurface.pendingPassword = "";
            lockSurface.pamContext.start();
        } else {
            // Password provided
            lockSurface.authInProgress = true;
            lockSurface.pendingPassword = passwordField.text;
            console.log("🔑 Calling pamContext.start() with password");
            lockSurface.pamContext.start();
        }
        console.log("🔑 pamContext.start() called, active:", lockSurface.pamContext.active);
    }

    color: colors.base

    // Auto-focus password field when shown
    onVisibleChanged: {
        if (visible) {
            passwordField.forceActiveFocus();
        }
    }

    Timer {
        id: autoStartTimer
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            console.log("🔑 Auto-starting authentication for U2F");
            lockSurface.authInProgress = true;
            lockSurface.pendingPassword = "";
            lockSurface.pamContext.start();
        }
    }

    Component.onCompleted: {
        console.log("🔒 LockSurface created for screen:", screen);
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

                // User avatar
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 96
                    radius: 48
                    color: "transparent"
                    visible: lockSurface.currentUser !== ""
                    clip: true

                    Image {
                        id: avatarImage

                        anchors.fill: parent
                        source: "file:///var/lib/AccountsService/icons/" + lockSurface.currentUser
                        fillMode: Image.PreserveAspectCrop
                        smooth: true

                        onStatusChanged: {
                            console.log("Avatar image status:", status, "source:", source);
                        }
                    }
                }

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
                    text: "Welcome back, " + (lockSurface.currentUser || "User")
                }

                // Password input
                TextField {
                    id: passwordField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.topMargin: colors.spacing * 4
                    color: colors.text
                    echoMode: TextInput.Password
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: TextInput.AlignHCenter
                    placeholderText: "Or enter password..."

                    background: Rectangle {
                        border.color: passwordField.activeFocus ? colors.blue : colors.overlay
                        border.width: 2
                        color: colors.surface
                        radius: colors.borderRadius * 2
                    }

                    Component.onCompleted: {
                        passwordField.forceActiveFocus();
                    }

                    onTextChanged: {
                        // If user starts typing while U2F is active, switch to password auth
                        if (lockSurface.u2fPromptActive && text.length > 0) {
                            console.log("🔑 User typing password, switching from U2F");
                            lockSurface.startAuthentication();
                        }
                    }

                    Keys.onEscapePressed: {
                        passwordField.text = "";
                        errorText.visible = false;
                    }
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
                    id: statusText

                    Layout.alignment: Qt.AlignHCenter
                    color: lockSurface.u2fPromptActive ? colors.blue : (lockSurface.authInProgress ? colors.yellow : colors.subtext)
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    opacity: lockSurface.authInProgress ? 1.0 : 0.7
                    text: lockSurface.u2fPromptActive ? "Touch your security key or enter password" : (lockSurface.authInProgress ? "Authenticating..." : "Press Enter or touch security key")
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
                    text: "Security key or password • Escape to clear"
                }
            }
        }
    }

    // Handle authentication
    Connections {
        target: lockSurface.pamContext

        function onError(error) {
            console.log("❌ Lock screen PAM auth error:", error);
            lockSurface.authInProgress = false;
            lockSurface.pendingPassword = "";
            lockSurface.u2fPromptActive = false;
            passwordField.text = "";
            passwordField.forceActiveFocus();
            errorText.text = "Authentication failed - Press Enter to retry";
            errorText.visible = true;
            errorTimer.start();
        }

        function onCompleted(result) {
            console.log("🔐 Lock surface PAM completed:", result);

            if (result !== PamResult.Success) {
                console.log("❌ Auth failed, resetting...");
                lockSurface.authInProgress = false;
                lockSurface.pendingPassword = "";
                lockSurface.u2fPromptActive = false;
                passwordField.text = "";
                passwordField.forceActiveFocus();
                errorText.text = "Authentication failed - Press Enter to retry";
                errorText.visible = true;
                errorTimer.start();
            }
            // If success, the LockScreen.qml onCompleted handler will unlock
        }

        function onPamMessage() {
            console.log("📨 Lock screen PAM message:", lockSurface.pamContext.message);
            console.log("📨 Response required:", lockSurface.pamContext.responseRequired);
            console.log("📨 Have pending password:", lockSurface.pendingPassword.length > 0);

            const msg = lockSurface.pamContext.message || "";

            // Check if this is a U2F prompt
            if (msg.toLowerCase().includes("touch") || msg.toLowerCase().includes("u2f") || msg.toLowerCase().includes("fido")) {
                console.log("📨 U2F prompt detected");
                lockSurface.u2fPromptActive = true;
                statusText.text = "Touch your security key or enter password";
                // Don't respond - wait for U2F or password
                return;
            }

            // If PAM is requesting a password response, provide it
            if (lockSurface.pamContext.responseRequired) {
                if (lockSurface.pendingPassword) {
                    console.log("📨 Responding to PAM with password (length:", lockSurface.pendingPassword.length, ")");
                    lockSurface.pamContext.respond(lockSurface.pendingPassword);
                    console.log("📨 Response sent to PAM");
                    lockSurface.u2fPromptActive = false;
                } else {
                    console.log("📨 PAM wants response but no password provided - sending empty");
                    lockSurface.pamContext.respond("");
                }
            } else {
                console.log("📨 Not responding - responseRequired:", lockSurface.pamContext.responseRequired);
            }
        }
    }
}
