import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import Quickshell.Io

Item {
    id: polkitAuth

    // Import colors
    Colors { id: colors }

    // Socket client property
    property var socketClient

    // Properties for auth request data
    property string actionId: ""
    property string message: ""
    property bool authInProgress: false
    property bool dialogVisible: false
    property bool ipcMode: false  // Set to true when using quickshell-polkit-agent
    property string currentCookie: ""  // Cookie for current polkit session
    property bool fidoKeyPresent: false  // FIDO key detection
    property bool fidoFallback: false    // FIDO timed out, now showing password fallback
    property bool fidoRetrying: false    // FIDO retry in progress
    property bool authTimedOut: false    // Authentication timed out or failed


    property int windowWidth: 680
    property int windowHeight: 420

    // User information
    property string currentUser: ""
    property string userFullName: ""
    property string userIconPath: ""

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

    // Load user information
    function loadUserInfo() {
        userInfoProcess.running = true
    }

    function startFocusTimer() {
      focusTimer.start()
    }

    // Function to start authentication
    function startAuthentication(actionId, message, useIpcMode, cookie) {
        polkitAuth.actionId = actionId
        polkitAuth.message = message || "Authentication required"
        polkitAuth.ipcMode = useIpcMode || false
        polkitAuth.currentCookie = cookie || ""

        // Reset timeout and fallback state
        polkitAuth.fidoFallback = false
        polkitAuth.fidoRetrying = false
        fidoRetryTimer.stop()

        // Detect FIDO keys FIRST, before showing dialog
        fidoDetector.running = true

        // Small delay to let FIDO detection complete before showing dialog
        Qt.callLater(function() {
            polkitAuth.authInProgress = true
            polkitAuth.dialogVisible = true

            // Don't start PAM for ipc calls - the agent handles authentication
            if (!polkitAuth.ipcMode) {
                pamContext.start()
            }
        })
    }

    // Function to cancel authentication
    function cancelAuthentication() {
        if (pamContext.active) {
            pamContext.abort()
        }
        polkitAuth.authInProgress = false
        polkitAuth.dialogVisible = false
        polkitAuth.fidoFallback = false
        polkitAuth.fidoRetrying = false
        fidoRetryTimer.stop()
        focusTimer.stop()
        initialFocusTimer.stop()
        polkitAuth.authCancelled()
        // Only emit authCompleted for direct PAM mode, not IPC mode
        if (!polkitAuth.ipcMode) {
            polkitAuth.authCompleted(false)
        }
    }

    // Function to get human-readable action names
    function getActionDisplayName(actionId) {
        return polkitAuth.actionMap[actionId] || actionId
    }

    // Signals
    signal authCompleted(bool success)
    signal authCancelled()

    // AccountsService process with inline command
    Process {
        id: userInfoProcess
        running: false
        command: [
          "sh",
          "-c",
          "uid=$(id -u); busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$uid org.freedesktop.Accounts.User IconFile 2>/dev/null && busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$uid org.freedesktop.Accounts.User RealName 2>/dev/null"
        ]
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                var [[,iconPath], [,realName]] =
                    this.text
                        .split('\n')
                        .map(l => l?.match(/s "(.+)"/) ??[])
                if (iconPath) { polkitAuth.userIconPath = iconPath }
                if (realName) { polkitAuth.userFullName = realName }
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
                var output = this.text.toLowerCase()
                polkitAuth.fidoKeyPresent = output.includes("yubico") ||
                                          output.includes("feitian") ||
                                          output.includes("nitrokey") ||
                                          output.includes("1050:") ||  // Yubico vendor ID
                                          output.includes("20a0:")     // Nitrokey vendor ID
                // Auto-submit for FIDO keys in IPC mode, but not when in fallback mode
                if (polkitAuth.fidoKeyPresent && polkitAuth.ipcMode && polkitAuth.currentCookie && !polkitAuth.fidoFallback) {
                    polkitAuth.authInProgress = true
                    // Submit empty response to trigger FIDO auth
                    if (polkitAuth.socketClient) {
                        polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, "")
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // Get current user from environment
        polkitAuth.currentUser = Quickshell.env("USER") || "user"
        polkitAuth.userFullName = polkitAuth.currentUser // Fallback
        // Load user info from AccountsService
        loadUserInfo()
    }

    // PAM context for authentication
    PamContext {
        id: pamContext
        config: "system-auth"  // Use system auth config like sudo

        onCompleted: function(result) {
            polkitAuth.authInProgress = false
            polkitAuth.dialogVisible = false
            polkitAuth.authCompleted(result === PamResult.Success)
        }

        onError: function(error) {
            polkitAuth.authInProgress = false
            polkitAuth.dialogVisible = false
            polkitAuth.authCompleted(false)
        }

        onPamMessage: function(message) {
            // Update UI with PAM prompts
            if (message && message.length > 0) {
                authDialog.messageText = message
            }
        }
    }

    // Focus restoration timer for fallback mode
    Timer {
        id: focusTimer
        interval: 200
        running: false
        repeat: false

        onTriggered: {
            if (authDialog.visible && passwordField.visible) {
                passwordField.forceActiveFocus()
            }
        }
    }

    // Aggressive focus timer for initial password mode
    Timer {
        id: initialFocusTimer
        interval: 100
        running: false
        repeat: true
        property int attempts: 0

        onTriggered: {
            attempts++
            if (authDialog.visible && passwordField.visible && !passwordField.activeFocus && attempts < 10) {
                passwordField.forceActiveFocus()
            } else {
                attempts = 0
                running = false
            }
        }
    }

    // FIDO retry timeout timer
    Timer {
        id: fidoRetryTimer
        interval: 30000  // 30 second timeout for FIDO retry
        running: false
        repeat: false

        onTriggered: {
            if (polkitAuth.fidoRetrying) {
                polkitAuth.fidoRetrying = false
                polkitAuth.fidoFallback = true
                polkitAuth.authInProgress = false
                focusTimer.start()
            }
        }
    }

    // Authentication dialog layer shell
    WlrLayershell {
        id: authDialog
        visible: polkitAuth.dialogVisible
        namespace: "quickshell-polkit-auth"
        layer: WlrLayer.Overlay
        exclusiveZone: 0
        keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        // Center on screen using margins
        anchors.bottom: true
        margins.bottom: (screen.height - height) / 2
        margins.left: (screen.width - width) / 2

        implicitWidth: Math.min(polkitAuth.windowWidth, screen.width - 40)
        implicitHeight: Math.min(polkitAuth.fidoFallback ? polkitAuth.windowHeight : (polkitAuth.fidoKeyPresent ? 280 : 320), screen.height - 40)

        property string messageText: polkitAuth.message

        onVisibleChanged: {
            if (visible) {
                passwordField.text = ""
                // Force focus after a delay to ensure layer shell is ready
                Qt.callLater(function() {
                    if (passwordField.visible) {
                        passwordField.forceActiveFocus()
                        // Start aggressive focus timer for password-only mode
                        if (!polkitAuth.fidoKeyPresent) {
                            initialFocusTimer.attempts = 0
                            initialFocusTimer.start()
                        }
                    }
                })
            } else {
                // Stop focus timers when dialog closes
                initialFocusTimer.stop()
                focusTimer.stop()
            }
        }

        // Global ESC key handler
        Shortcut {
            sequence: "Escape"
            enabled: polkitAuth.dialogVisible
            onActivated: {
                console.log("ESC shortcut activated")
                // Handle ESC key same as cancel button
                if (polkitAuth.ipcMode && polkitAuth.socketClient) {
                    console.log("ESC: sending socket cancellation")
                    polkitAuth.socketClient.cancelAuthentication()
                } else {
                    console.log("ESC: calling direct cancellation")
                    polkitAuth.cancelAuthentication()
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: colors.base
            border.color: colors.mauve  // Match Hyprland active border
            border.width: 2
            radius: 10  // Match Hyprland rounding

            // Smooth antialiasing for rounded corners
            antialiasing: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (passwordField.visible) {
                        passwordField.forceActiveFocus()
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
                        Layout.preferredWidth: 64
                        Layout.preferredHeight: 64

                        // Real user avatar if available
                        Rectangle {
                            anchors.fill: parent
                            radius: 24
                            color: "transparent"
                            clip: true
                            visible: userAvatarImage.status === Image.Ready

                            Image {
                                id: userAvatarImage
                                anchors.fill: parent
                                source: polkitAuth.userIconPath ? "file://" + polkitAuth.userIconPath : ""
                                fillMode: Image.PreserveAspectCrop
                                onStatusChanged: {
                                    console.log("Avatar image status:", status, "source:", source)
                                }
                            }
                        }

                        // Fallback avatar with user initial
                        Rectangle {
                            anchors.fill: parent
                            radius: 24
                            color: colors.blue
                            visible: userAvatarImage.status !== Image.Ready

                            Text {
                                anchors.centerIn: parent
                                text: polkitAuth.userFullName.charAt(0).toUpperCase()
                                color: colors.crust
                                font.family: colors.fontFamily
                                font.pixelSize: colors.largeTextSize
                                font.bold: true
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: colors.spacing

                        Text {
                            text: "Authentication Required"
                            color: colors.text
                            font.family: colors.fontFamily
                            font.pixelSize: colors.largeTextSize + 2
                            font.bold: true
                        }

                        Text {
                            text: {
                                if (polkitAuth.fidoRetrying) {
                                    return "Retrying security key authentication..."
                                } else if (polkitAuth.fidoFallback) {
                                    return "Security key timed out. Try again or enter password:"
                                } else if (polkitAuth.fidoKeyPresent) {
                                    return polkitAuth.authInProgress ? "Touch your security key..." : "Please use your security key"
                                } else {
                                    return "Please enter your password"
                                }
                            }
                            color: colors.subtext
                            font.family: colors.fontFamily
                            font.pixelSize: colors.textSize
                        }
                    }
                }

                // Message
                Text {
                    text: authDialog.messageText
                    color: colors.green
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                // Human-readable action description
                Text {
                    text: polkitAuth.getActionDisplayName(polkitAuth.actionId)
                    color: colors.peach
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                // Password input field (hidden if FIDO key present, shown in fallback mode)
                TextField {
                    id: passwordField
                    placeholderText: "Enter password..."
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    visible: !polkitAuth.fidoKeyPresent || polkitAuth.fidoFallback

                    onVisibleChanged: {
                        if (visible && authDialog.visible) {
                            if (polkitAuth.fidoFallback) {
                                // Use normal timer for fallback mode
                                focusTimer.start()
                            } else {
                                // Use aggressive timer for password-only mode
                                initialFocusTimer.attempts = 0
                                initialFocusTimer.start()
                            }
                        }
                    }

                    background: Rectangle {
                        color: colors.surface
                        border.color: passwordField.activeFocus ? colors.blue : colors.overlay
                        border.width: 1
                        radius: colors.borderRadius
                    }

                    color: colors.text
                    font.family: colors.fontFamily
                    font.pixelSize: colors.textSize

                    Keys.onReturnPressed: authenticateButton.clicked()
                    Keys.onEscapePressed: {
                        console.log("ESC pressed from password field")
                        cancelButton.clicked()
                    }

                    Component.onCompleted: forceActiveFocus()
                }

                // Status indicator
                Text {
                    text: {
                        if (polkitAuth.authInProgress) {
                            if (polkitAuth.fidoRetrying) {
                                return "Retrying FIDO authentication..."
                            } else if (polkitAuth.fidoKeyPresent) {
                                return "Waiting for security key..."
                            } else {
                                return "Authenticating..."
                            }
                        }
                        return ""
                    }
                    color: colors.yellow
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    Layout.alignment: Qt.AlignHCenter
                    visible: polkitAuth.authInProgress
                }

                // Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: colors.spacing * 2

                    Button {
                        id: cancelButton
                        text: "Cancel"
                        Layout.fillWidth: true
                        enabled: true  // Always enabled

                        background: Rectangle {
                            color: cancelButton.pressed ? colors.overlay : colors.surface
                            opacity: cancelButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }

                        contentItem: Text {
                            text: cancelButton.text
                            color: colors.text
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            // Send cancellation to polkit agent if in IPC mode
                            if (polkitAuth.ipcMode && polkitAuth.socketClient) {
                                polkitAuth.socketClient.cancelAuthentication()
                                // Don't close dialog immediately - wait for authorization_result
                            } else {
                                // For direct PAM mode, use full cancellation
                                polkitAuth.cancelAuthentication()
                            }
                        }
                    }

                    // Try FIDO Again button (only in fallback mode)
                    Button {
                        id: tryFidoButton
                        text: "Try Security Key Again"
                        Layout.fillWidth: true
                        enabled: !polkitAuth.authInProgress
                        visible: polkitAuth.fidoFallback

                        background: Rectangle {
                            color: tryFidoButton.pressed ? colors.blue : colors.sapphire
                            opacity: tryFidoButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }

                        contentItem: Text {
                            text: tryFidoButton.text
                            color: colors.crust
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            console.log("Retrying FIDO authentication")
                            polkitAuth.fidoFallback = false
                            polkitAuth.fidoRetrying = true
                            polkitAuth.authInProgress = true

                            // Submit empty response to retry FIDO
                            if (polkitAuth.socketClient) {
                                polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, "")
                            }

                            // Reset retry state after timeout
                            fidoRetryTimer.start()
                        }
                    }

                    // Authenticate with password button (in password mode or fallback mode)
                    Button {
                        id: authenticateButton
                        text: "Authenticate"
                        Layout.fillWidth: true
                        enabled: !polkitAuth.authInProgress && passwordField.text.length > 0
                        visible: !polkitAuth.fidoKeyPresent || polkitAuth.fidoFallback

                        background: Rectangle {
                            color: authenticateButton.pressed ? colors.green : colors.sapphire
                            opacity: authenticateButton.pressed ? 0.8 : 1.0
                            radius: colors.borderRadius
                        }

                        contentItem: Text {
                            text: authenticateButton.text
                            color: colors.crust
                            font.family: colors.fontFamily
                            font.pixelSize: colors.smallTextSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (polkitAuth.ipcMode && polkitAuth.currentCookie) {
                                // IPC mode - send to quickshell polkit agent
                                // Submit via socket client
                                if (polkitAuth.socketClient) {
                                    polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, passwordField.text)
                                }
                                passwordField.text = ""  // Clear password field
                                // Keep dialog visible and show "processing" state
                                polkitAuth.authInProgress = true
                                // Don't dismiss dialog yet - wait for result from polkit agent
                            } else {
                                // Direct PAM mode
                                if (pamContext.responseRequired && passwordField.text.length > 0) {
                                    pamContext.respond(passwordField.text)
                                    passwordField.text = ""  // Clear password field
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
