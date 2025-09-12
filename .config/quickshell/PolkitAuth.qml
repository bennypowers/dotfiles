import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import Quickshell.Io

Item {
    id: polkitAuth

    // Properties for auth request data
    property string actionId: ""
    property var actionMap: {
        "org.freedesktop.policykit.exec": "Run program as administrator",
        "org.freedesktop.systemd1.manage-units": "Manage system services",
        "org.freedesktop.systemd1.reload-daemon": "Reload system configuration",
        "org.freedesktop.NetworkManager.network-control": "Control network connections",
        "org.freedesktop.udisks2.filesystem-mount": "Mount storage device",
        "org.freedesktop.udisks2.filesystem-unmount": "Unmount storage device",
        "org.freedesktop.login1.power-off": "Power off the system",
        "org.freedesktop.login1.reboot": "Restart the system",
        "org.freedesktop.packagekit.package-install": "Install software packages",
        "org.freedesktop.packagekit.package-remove": "Remove software packages"
    }
    property bool authInProgress: false
    property bool authTimedOut: false    // Authentication timed out or failed

    property string currentCookie: ""  // Cookie for current polkit session

    // User information
    property string currentUser: ""
    property bool dialogVisible: false
    property bool fidoFallback: false    // FIDO timed out, now showing password fallback
    property bool fidoKeyPresent: false  // FIDO key detection
    property bool fidoRetrying: false    // FIDO retry in progress
    property bool ipcMode: false  // Set to true when using quickshell-polkit-agent
    property string message: ""

    // Socket client property
    property var socketClient
    property string userFullName: ""
    property string userIconPath: ""
    property int windowHeight: 420
    property int windowWidth: 680

    signal authCancelled

    // Signals
    signal authCompleted(bool success)

    // Function to cancel authentication
    function cancelAuthentication() {
        if (pamContext.active) {
            pamContext.abort();
        }
        polkitAuth.authInProgress = false;
        polkitAuth.dialogVisible = false;
        polkitAuth.fidoFallback = false;
        polkitAuth.fidoRetrying = false;
        fidoRetryTimer.stop();
        focusTimer.stop();
        initialFocusTimer.stop();
        polkitAuth.authCancelled();
        // Only emit authCompleted for direct PAM mode, not IPC mode
        if (!polkitAuth.ipcMode) {
            polkitAuth.authCompleted(false);
        }
    }

    // Function to get human-readable action names
    function getActionDisplayName(actionId) {
        return polkitAuth.actionMap[actionId] || actionId;
    }

    // Load user information
    function loadUserInfo() {
        userInfoProcess.running = true;
    }

    // Function to start authentication
    function startAuthentication(actionId, message, useIpcMode, cookie) {
        polkitAuth.actionId = actionId;
        polkitAuth.message = message || "Authentication required";
        polkitAuth.ipcMode = useIpcMode || false;
        polkitAuth.currentCookie = cookie || "";

        // Reset timeout and fallback state
        polkitAuth.fidoFallback = false;
        polkitAuth.fidoRetrying = false;
        fidoRetryTimer.stop();

        // Detect FIDO keys FIRST, before showing dialog
        fidoDetector.running = true;

        // Small delay to let FIDO detection complete before showing dialog
        Qt.callLater(function () {
            polkitAuth.authInProgress = true;
            polkitAuth.dialogVisible = true;

            // Don't start PAM for ipc calls - the agent handles authentication
            if (!polkitAuth.ipcMode) {
                pamContext.start();
            }
        });
    }
    function startFocusTimer() {
        focusTimer.start();
    }

    Component.onCompleted: {
        // Get current user from environment
        polkitAuth.currentUser = Quickshell.env("USER") || "user";
        polkitAuth.userFullName = polkitAuth.currentUser; // Fallback
        // Load user info from AccountsService
        loadUserInfo();
    }

    // Import colors
    Colors {
        id: colors

    }

    // AccountsService process with inline command
    Process {
        id: userInfoProcess

        command: ["sh", "-c", "uid=$(id -u); busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$uid org.freedesktop.Accounts.User IconFile 2>/dev/null && busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$uid org.freedesktop.Accounts.User RealName 2>/dev/null"]
        running: false

        stdout: StdioCollector {
            id: stdoutCollector

            onStreamFinished: {
                var [[, iconPath], [, realName]] = this.text.split('\n').map(l => l?.match(/s "(.+)"/) ?? []);
                if (iconPath) {
                    polkitAuth.userIconPath = iconPath;
                }
                if (realName) {
                    polkitAuth.userFullName = realName;
                }
            }
        }
    }

    // FIDO key detection
    Process {
        id: fidoDetector

        command: ["lsusb"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                // Check for common FIDO key vendors
                var output = this.text.toLowerCase();
                polkitAuth.fidoKeyPresent = output.includes("yubico") || output.includes("feitian") || output.includes("nitrokey") || output.includes("1050:") ||  // Yubico vendor ID
                output.includes("20a0:");     // Nitrokey vendor ID
                // Auto-submit for FIDO keys in IPC mode, but not when in fallback mode
                if (polkitAuth.fidoKeyPresent && polkitAuth.ipcMode && polkitAuth.currentCookie && !polkitAuth.fidoFallback) {
                    polkitAuth.authInProgress = true;
                    // Submit empty response to trigger FIDO auth
                    if (polkitAuth.socketClient) {
                        polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, "");
                    }
                }
            }
        }
    }

    // PAM context for authentication
    PamContext {
        id: pamContext

        config: "system-auth"  // Use system auth config like sudo

        onCompleted: function (result) {
            polkitAuth.authInProgress = false;
            polkitAuth.dialogVisible = false;
            polkitAuth.authCompleted(result === PamResult.Success);
        }
        onError: function (error) {
            polkitAuth.authInProgress = false;
            polkitAuth.dialogVisible = false;
            polkitAuth.authCompleted(false);
        }
        onPamMessage: function (message) {
            // Update UI with PAM prompts
            if (message && message.length > 0) {
                authDialog.messageText = message;
            }
        }
    }

    // Focus restoration timer for fallback mode
    Timer {
        id: focusTimer

        interval: 200
        repeat: false
        running: false

        onTriggered: {
            if (authDialog.visible && passwordField.visible) {
                passwordField.forceActiveFocus();
            }
        }
    }

    // Aggressive focus timer for initial password mode
    Timer {
        id: initialFocusTimer

        property int attempts: 0

        interval: 100
        repeat: true
        running: false

        onTriggered: {
            attempts++;
            if (authDialog.visible && passwordField.visible && !passwordField.activeFocus && attempts < 10) {
                passwordField.forceActiveFocus();
            } else {
                attempts = 0;
                running = false;
            }
        }
    }

    // FIDO retry timeout timer
    Timer {
        id: fidoRetryTimer

        interval: 30000  // 30 second timeout for FIDO retry
        repeat: false
        running: false

        onTriggered: {
            if (polkitAuth.fidoRetrying) {
                polkitAuth.fidoRetrying = false;
                polkitAuth.fidoFallback = true;
                polkitAuth.authInProgress = false;
                focusTimer.start();
            }
        }
    }

    // Authentication dialog layer shell
    WlrLayershell {
        id: authDialog

        property string messageText: polkitAuth.message

        // Center on screen using margins
        anchors.bottom: true
        color: "transparent"
        exclusiveZone: 0
        implicitHeight: Math.min(polkitAuth.fidoFallback ? polkitAuth.windowHeight : (polkitAuth.fidoKeyPresent ? 280 : 320), screen.height - 40)
        implicitWidth: Math.min(polkitAuth.windowWidth, screen.width - 40)
        keyboardFocus: WlrKeyboardFocus.Exclusive
        layer: WlrLayer.Overlay
        margins.bottom: (screen.height - height) / 2
        margins.left: (screen.width - width) / 2
        namespace: "quickshell-polkit-auth"
        visible: polkitAuth.dialogVisible

        onVisibleChanged: {
            if (visible) {
                passwordField.text = "";
                // Force focus after a delay to ensure layer shell is ready
                Qt.callLater(function () {
                    if (passwordField.visible) {
                        passwordField.forceActiveFocus();
                        // Start aggressive focus timer for password-only mode
                        if (!polkitAuth.fidoKeyPresent) {
                            initialFocusTimer.attempts = 0;
                            initialFocusTimer.start();
                        }
                    }
                });
            } else {
                // Stop focus timers when dialog closes
                initialFocusTimer.stop();
                focusTimer.stop();
            }
        }

        // Global ESC key handler
        Shortcut {
            enabled: polkitAuth.dialogVisible
            sequence: "Escape"

            onActivated: {
                console.log("ESC shortcut activated");
                // Handle ESC key same as cancel button
                if (polkitAuth.ipcMode && polkitAuth.socketClient) {
                    console.log("ESC: sending socket cancellation");
                    polkitAuth.socketClient.cancelAuthentication();
                } else {
                    console.log("ESC: calling direct cancellation");
                    polkitAuth.cancelAuthentication();
                }
            }
        }
        Rectangle {
            anchors.fill: parent

            // Smooth antialiasing for rounded corners
            antialiasing: true
            border.color: colors.mauve  // Match Hyprland active border
            border.width: 2
            color: colors.base
            radius: 10  // Match Hyprland rounding

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (passwordField.visible) {
                        passwordField.forceActiveFocus();
                    }
                }
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: colors.spacing * 5

                // User avatar and info section
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: colors.spacing * 3

                    // User avatar
                    Item {
                        Layout.preferredHeight: 64
                        Layout.preferredWidth: 64

                        // Real user avatar if available
                        Rectangle {
                            anchors.fill: parent
                            clip: true
                            color: "transparent"
                            radius: 24
                            visible: userAvatarImage.status === Image.Ready

                            Image {
                                id: userAvatarImage

                                anchors.fill: parent
                                fillMode: Image.PreserveAspectCrop
                                source: polkitAuth.userIconPath ? "file://" + polkitAuth.userIconPath : ""

                                onStatusChanged: {
                                    console.log("Avatar image status:", status, "source:", source);
                                }
                            }
                        }

                        // Fallback avatar with user initial
                        Rectangle {
                            anchors.fill: parent
                            color: colors.blue
                            radius: 24
                            visible: userAvatarImage.status !== Image.Ready

                            Text {
                                anchors.centerIn: parent
                                color: colors.crust
                                font.bold: true
                                font.family: colors.fontFamily
                                font.pixelSize: colors.largeTextSize
                                text: polkitAuth.userFullName.charAt(0).toUpperCase()
                            }
                        }
                    }
                    ColumnLayout {
                        spacing: colors.spacing

                        Text {
                            color: colors.text
                            font.bold: true
                            font.family: colors.fontFamily
                            font.pixelSize: colors.largeTextSize + 2
                            text: "Authentication Required"
                        }
                        Text {
                            color: colors.subtext
                            font.family: colors.fontFamily
                            font.pixelSize: colors.textSize
                            text: {
                                if (polkitAuth.fidoRetrying) {
                                    return "Retrying security key authentication...";
                                } else if (polkitAuth.fidoFallback) {
                                    return "Security key timed out. Try again or enter password:";
                                } else if (polkitAuth.fidoKeyPresent) {
                                    return polkitAuth.authInProgress ? "Touch your security key..." : "Please use your security key";
                                } else {
                                    return "Please enter your password";
                                }
                            }
                        }
                    }
                }

                // Message
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    color: colors.green
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: Text.AlignHCenter
                    text: authDialog.messageText
                    wrapMode: Text.WordWrap
                }

                // Human-readable action description
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    color: colors.peach
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    horizontalAlignment: Text.AlignHCenter
                    text: polkitAuth.getActionDisplayName(polkitAuth.actionId)
                    wrapMode: Text.WordWrap
                }

                // Password input field (hidden if FIDO key present, shown in fallback mode)
                TextField {
                    id: passwordField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: colors.text
                    echoMode: TextInput.Password
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    placeholderText: "Enter password..."
                    visible: !polkitAuth.fidoKeyPresent || polkitAuth.fidoFallback

                    background: Rectangle {
                        border.color: passwordField.activeFocus ? colors.blue : colors.overlay
                        border.width: 1
                        color: colors.surface
                        radius: colors.borderRadius
                    }

                    Component.onCompleted: forceActiveFocus()
                    Keys.onEscapePressed: {
                        console.log("ESC pressed from password field");
                        cancelButton.clicked();
                    }
                    Keys.onReturnPressed: authenticateButton.clicked()
                    onVisibleChanged: {
                        if (visible && authDialog.visible) {
                            if (polkitAuth.fidoFallback) {
                                // Use normal timer for fallback mode
                                focusTimer.start();
                            } else {
                                // Use aggressive timer for password-only mode
                                initialFocusTimer.attempts = 0;
                                initialFocusTimer.start();
                            }
                        }
                    }
                }

                // Status indicator
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: colors.yellow
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    text: {
                        if (polkitAuth.authInProgress) {
                            if (polkitAuth.fidoRetrying) {
                                return "Retrying FIDO authentication...";
                            } else if (polkitAuth.fidoKeyPresent) {
                                return "Waiting for security key...";
                            } else {
                                return "Authenticating...";
                            }
                        }
                        return "";
                    }
                    visible: polkitAuth.authInProgress
                }

                // Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: colors.spacing * 2

                    Button {
                        id: cancelButton

                        Layout.fillWidth: true
                        enabled: true  // Always enabled

                        text: "Cancel"

                        background: Rectangle {
                            color: cancelButton.pressed ? colors.overlay : colors.surface
                            opacity: cancelButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }
                        contentItem: Text {
                            color: colors.text
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            text: cancelButton.text
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            // Send cancellation to polkit agent if in IPC mode
                            if (polkitAuth.ipcMode && polkitAuth.socketClient) {
                                polkitAuth.socketClient.cancelAuthentication();
                                // Don't close dialog immediately - wait for authorization_result
                            } else {
                                // For direct PAM mode, use full cancellation
                                polkitAuth.cancelAuthentication();
                            }
                        }
                    }

                    // Try FIDO Again button (only in fallback mode)
                    Button {
                        id: tryFidoButton

                        Layout.fillWidth: true
                        enabled: !polkitAuth.authInProgress
                        text: "Try Security Key Again"
                        visible: polkitAuth.fidoFallback

                        background: Rectangle {
                            color: tryFidoButton.pressed ? colors.blue : colors.sapphire
                            opacity: tryFidoButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }
                        contentItem: Text {
                            color: colors.crust
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            text: tryFidoButton.text
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            console.log("Retrying FIDO authentication");
                            polkitAuth.fidoFallback = false;
                            polkitAuth.fidoRetrying = true;
                            polkitAuth.authInProgress = true;

                            // Submit empty response to retry FIDO
                            if (polkitAuth.socketClient) {
                                polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, "");
                            }

                            // Reset retry state after timeout
                            fidoRetryTimer.start();
                        }
                    }

                    // Authenticate with password button (in password mode or fallback mode)
                    Button {
                        id: authenticateButton

                        Layout.fillWidth: true
                        enabled: !polkitAuth.authInProgress && passwordField.text.length > 0
                        text: "Authenticate"
                        visible: !polkitAuth.fidoKeyPresent || polkitAuth.fidoFallback

                        background: Rectangle {
                            color: authenticateButton.pressed ? colors.green : colors.sapphire
                            opacity: authenticateButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }
                        contentItem: Text {
                            color: colors.crust
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            text: authenticateButton.text
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (polkitAuth.ipcMode && polkitAuth.currentCookie) {
                                // IPC mode - send to quickshell polkit agent
                                // Submit via socket client
                                if (polkitAuth.socketClient) {
                                    polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, passwordField.text);
                                }
                                passwordField.text = "";  // Clear password field
                                // Keep dialog visible and show "processing" state
                                polkitAuth.authInProgress = true;
                                // Don't dismiss dialog yet - wait for result from polkit agent
                            } else {
                                // Direct PAM mode
                                if (pamContext.responseRequired && passwordField.text.length > 0) {
                                    pamContext.respond(passwordField.text);
                                    passwordField.text = "";  // Clear password field
                                }
                            }
                        }
                    }
                }

                // Spacer
                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
