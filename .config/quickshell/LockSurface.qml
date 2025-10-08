import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
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

        // If U2F is waiting and user entered password, abort and restart with password
        if (lockSurface.u2fPromptActive && passwordField.text.length > 0) {
            console.log("🔑 U2F active but user entered password - aborting U2F");
            lockSurface.pamContext.abort();
            lockSurface.u2fPromptActive = false;
        }

        console.log("🔑 Password field length:", passwordField.text.length);
        if (passwordField.text.length === 0) {
            // No password - try U2F only
            console.log("🔑 No password, initiating auth (U2F will be tried first)");
            lockSurface.authInProgress = true;
            lockSurface.pendingPassword = "";
            errorText.visible = false;
            lockSurface.pamContext.start();
        } else {
            // Password provided
            lockSurface.authInProgress = true;
            lockSurface.pendingPassword = passwordField.text;
            errorText.visible = false;
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
                Image {
                    id: avatarImage

                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 96
                    source: "file:///var/lib/AccountsService/icons/" + lockSurface.currentUser
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    visible: lockSurface.currentUser !== ""

                    onStatusChanged: {
                        console.log("Avatar image status:", status, "source:", source);
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: 96
                            height: 96
                            radius: 48
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
                    id: statusText

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

    // Handle authentication
    Connections {
        target: lockSurface.pamContext

        function onError(error) {
            console.log("Lock screen PAM auth error:", error);
            lockSurface.authInProgress = false;
            lockSurface.pendingPassword = "";
            passwordField.text = "";
            passwordField.forceActiveFocus();
            errorText.text = "Authentication failed";
            errorText.visible = true;
            errorTimer.start();
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
