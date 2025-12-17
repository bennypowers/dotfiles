import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

WlSessionLockSurface {
    id: lockSurface

    required property PamContext pamContext
    required property string currentUser
    required property var screenCaptureMap
    required property bool isLocked

    property bool authInProgress: false
    property string pendingPassword: ""
    property string pamPrompt: ""
    property bool capsLockOn: false
    property string currentKeyboardLayout: ""

    signal unlockRequested()

    function startAuthentication() {
        console.log("🔑 Starting lock screen authentication");

        // If already authenticating, abort first
        if (lockSurface.authInProgress && lockSurface.pamContext.active) {
            console.log("🔑 Aborting previous auth attempt");
            lockSurface.pamContext.abort();
        }

        console.log("🔑 Password field length:", passwordField.text.length);
        errorText.visible = false;

        // Start PAM authentication with whatever password we have (empty for security key only)
        lockSurface.authInProgress = true;
        lockSurface.pendingPassword = passwordField.text;
        lockSurface.pamContext.start();
        console.log("🔑 pamContext.start() called, active:", lockSurface.pamContext.active);
    }

    color: colors.base

    // Auto-focus password field and start monitoring when locked
    onIsLockedChanged: {
        if (isLocked) {
            passwordField.forceActiveFocus();
            keyboardLayoutProcess.running = true;
            capsLockProcess.running = true;
        }
    }


    Colors {
        id: colors
    }

    // Background - blurred screenshot of the screen
    Item {
        anchors.fill: parent

        // Render the captured screen via ShaderEffectSource
        ShaderEffectSource {
            id: captureTexture
            anchors.fill: parent
            sourceItem: lockSurface.screen ? lockSurface.screenCaptureMap[lockSurface.screen.name] : null
            visible: sourceItem !== null && sourceItem.hasContent
            live: false
            hideSource: false  // Don't hide source - it's already offscreen
            smooth: true
            mipmap: false
            textureSize: Qt.size(width, height)

            onSourceItemChanged: {
                if (sourceItem) {
                    // Force refresh the texture
                    scheduleUpdate()
                }
            }
        }

        Connections {
            target: lockSurface.screen && lockSurface.screenCaptureMap[lockSurface.screen.name] ? lockSurface.screenCaptureMap[lockSurface.screen.name] : null

            function onHasContentChanged() {
                if (target.hasContent) {
                    captureTexture.scheduleUpdate()
                }
            }
        }

        // Blur the captured screen
        FastBlur {
            id: blurredBackground
            anchors.fill: parent
            source: captureTexture
            radius: 128  // Very high blur radius to obscure all text
            visible: captureTexture.visible
            cached: true
        }

        // Fallback: solid background if capture not available
        Rectangle {
            anchors.fill: parent
            color: colors.base
            opacity: 0.95
            visible: !captureTexture.visible
        }

        // Dark overlay for better text contrast (on top of blurred capture)
        Rectangle {
            anchors.fill: parent
            color: colors.base
            opacity: 0.5
            visible: blurredBackground.visible
        }

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
                    enabled: !lockSurface.authInProgress  // Disable while authenticating to prevent faillock
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: TextInput.AlignHCenter
                    placeholderText: "Or enter password..."

                    background: Rectangle {
                        border.color: passwordField.enabled
                            ? (passwordField.activeFocus ? colors.blue : colors.overlay)
                            : colors.overlay
                        border.width: 2
                        color: passwordField.enabled ? colors.surface : colors.mantle
                        opacity: passwordField.enabled ? 1.0 : 0.6
                        radius: colors.borderRadius * 2
                    }

                    Component.onCompleted: {
                        passwordField.forceActiveFocus();
                    }

                    onTextChanged: {
                        // Clear error when user starts typing
                        if (text.length > 0) {
                            errorText.visible = false;
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
                }

                // PAM prompt message
                Text {
                    id: pamPromptText

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    color: colors.blue
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    text: lockSurface.pamPrompt
                    visible: lockSurface.pamPrompt !== ""
                    wrapMode: Text.WordWrap
                }

                // Status message
                Text {
                    id: statusText

                    Layout.alignment: Qt.AlignHCenter
                    color: lockSurface.authInProgress ? colors.yellow : colors.subtext
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    opacity: lockSurface.authInProgress ? 1.0 : 0.7
                    text: lockSurface.authInProgress ? "Authenticating..." : "Press Enter to authenticate"
                }

                // Spacer
                Item {
                    Layout.fillHeight: true
                }

                // Keyboard indicators (capslock and layout)
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: colors.spacing * 4
                    visible: lockSurface.capsLockOn || lockSurface.currentKeyboardLayout !== ""

                    // Capslock indicator
                    Rectangle {
                        Layout.preferredWidth: capsLockText.width + colors.spacing * 4
                        Layout.preferredHeight: capsLockText.height + colors.spacing * 2
                        color: colors.yellow
                        radius: colors.borderRadius
                        visible: lockSurface.capsLockOn

                        Text {
                            id: capsLockText
                            anchors.centerIn: parent
                            color: colors.base
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            font.bold: true
                            text: "⇪ CAPS LOCK"
                        }
                    }

                    // Keyboard layout indicator
                    Rectangle {
                        Layout.preferredWidth: layoutText.width + colors.spacing * 4
                        Layout.preferredHeight: layoutText.height + colors.spacing * 2
                        color: colors.blue
                        radius: colors.borderRadius
                        visible: lockSurface.currentKeyboardLayout !== ""

                        Text {
                            id: layoutText
                            anchors.centerIn: parent
                            color: colors.base
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            font.bold: true
                            text: lockSurface.currentKeyboardLayout
                        }
                    }
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
            lockSurface.pamPrompt = "";
            passwordField.text = "";
            passwordField.forceActiveFocus();
            errorText.text = error;
            errorText.visible = true;
        }

        function onCompleted(result) {
            console.log("🔐 Lock surface PAM completed:", result);

            if (result !== PamResult.Success) {
                console.log("❌ Auth failed, resetting...");
                lockSurface.authInProgress = false;
                lockSurface.pendingPassword = "";
                lockSurface.pamPrompt = "";
                passwordField.text = "";
                passwordField.forceActiveFocus();
                errorText.text = "Authentication failed";
                errorText.visible = true;
            }
            // If success, the LockScreen.qml onCompleted handler will unlock
        }

        function onPamMessage() {
            console.log("📨 Lock screen PAM message:", lockSurface.pamContext.message);
            console.log("📨 Response required:", lockSurface.pamContext.responseRequired);
            console.log("📨 Have pending password:", lockSurface.pendingPassword.length > 0);

            const msg = lockSurface.pamContext.message || "";

            // Display PAM's message to the user
            lockSurface.pamPrompt = msg;

            // If PAM is requesting a response, provide what we have
            if (lockSurface.pamContext.responseRequired) {
                console.log("📨 Responding to PAM with password (length:", lockSurface.pendingPassword.length, ")");
                lockSurface.pamContext.respond(lockSurface.pendingPassword);
                console.log("📨 Response sent to PAM");
            } else {
                console.log("📨 PAM message is informational only (no response required)");
            }
        }
    }

    // Monitor capslock state
    Timer {
        id: capsLockTimer
        interval: 500  // Poll every 500ms
        repeat: true
        running: lockSurface.isLocked

        onTriggered: {
            capsLockProcess.running = true;
        }
    }

    Process {
        id: capsLockProcess

        command: ["cat", "/sys/class/leds/input2::capslock/brightness"]

        stdout: SplitParser {
            onRead: function(data) {
                const brightness = parseInt(data.trim());
                lockSurface.capsLockOn = (brightness === 1);
            }
        }
    }

    // Get keyboard layout
    Timer {
        id: keyboardLayoutTimer
        interval: 1000  // Poll every second
        repeat: true
        running: lockSurface.isLocked

        onTriggered: {
            keyboardLayoutProcess.running = true;
        }
    }

    Process {
        id: keyboardLayoutProcess

        command: ["niri", "msg", "keyboard-layouts"]

        stdout: SplitParser {
            onRead: function(data) {
                // Parse output like:
                // Keyboard layouts:
                //  * 0 English (US)
                //    1 Hebrew (Adelman)
                const lines = data.trim().split('\n');
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim();
                    // Look for the line with * (active layout)
                    if (line.startsWith('*')) {
                        // Extract layout name after the number
                        const match = line.match(/\*\s+\d+\s+(.+)/);
                        if (match && match[1]) {
                            const layoutName = match[1];
                            // Shorten the layout name for display
                            if (layoutName.includes("English")) {
                                lockSurface.currentKeyboardLayout = "EN";
                            } else if (layoutName.includes("Hebrew")) {
                                lockSurface.currentKeyboardLayout = "עב";
                            } else {
                                lockSurface.currentKeyboardLayout = layoutName;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
}
