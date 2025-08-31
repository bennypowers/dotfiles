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

    // User information
    property string currentUser: ""
    property string userFullName: ""
    property string userIconPath: ""

    // AccountsService process with proper stdout collection
    Process {
        id: userInfoProcess
        running: false
        command: ["/home/bennyp/.config/quickshell/get-user-info.sh"]

        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                console.log("AccountsService script output received:", this.text)
                parseAccountsServiceData(this.text)
            }
        }

        onExited: {
            console.log("AccountsService process exited with code:", exitCode)
            if (exitCode !== 0) {
                console.log("Process failed, using fallback")
                setFallbackUserInfo()
            }
        }
    }

    // Load user information
    function loadUserInfo() {
        console.log("Loading user information from AccountsService...")
        userInfoProcess.running = true
    }

    // Parse AccountsService data from script output
    function parseAccountsServiceData(output) {
        console.log("Parsing real AccountsService data...")

        if (!output || output.length === 0) {
            console.log("No output from AccountsService script")
            setFallbackUserInfo()
            return
        }

        // Parse the output from our script
        var lines = output.split('\n')

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()

            if (line.startsWith("ICON_FILE=")) {
                var iconPath = line.substring(10) // Remove "ICON_FILE="
                if (iconPath && iconPath.length > 0) {
                    polkitAuth.userIconPath = iconPath
                    console.log("Set user avatar from AccountsService:", iconPath)
                }
            }

            if (line.startsWith("REAL_NAME=")) {
                var realName = line.substring(10) // Remove "REAL_NAME="
                if (realName && realName.length > 0) {
                    polkitAuth.userFullName = realName
                    console.log("Set user real name from AccountsService:", realName)
                } else {
                    console.log("RealName is empty, keeping username:", polkitAuth.userFullName)
                }
            }

            if (line.startsWith("EMAIL=")) {
                var email = line.substring(6) // Remove "EMAIL="
                if (email && email.length > 0) {
                    console.log("User email from AccountsService:", email)
                }
            }
        }

        console.log("AccountsService data loaded - Name:", polkitAuth.userFullName, "Avatar:", polkitAuth.userIconPath)
    }

    // Fallback user info
    function setFallbackUserInfo() {
        console.log("Using fallback user information")
        // Username is already set in Component.onCompleted
        // Avatar will remain empty, showing fallback initial
        console.log("Fallback - Name:", polkitAuth.userFullName, "Avatar: (empty)")
    }

    Component.onCompleted: {
        // Get current user from environment
        polkitAuth.currentUser = Quickshell.env("USER") || "user"
        polkitAuth.userFullName = polkitAuth.currentUser // Fallback

        // Load user info from AccountsService
        loadUserInfo()
    }

    // Signals
    signal authCompleted(bool success)
    signal authCancelled()

    // PAM context for authentication
    PamContext {
        id: pamContext
        config: "system-auth"  // Use system auth config like sudo

        onCompleted: function(result) {
            console.log("Polkit PAM auth completed:", result)
            polkitAuth.authInProgress = false
            polkitAuth.dialogVisible = false

            if (result === PamResult.Success) {
                polkitAuth.authCompleted(true)
            } else {
                polkitAuth.authCompleted(false)
            }
        }

        onError: function(error) {
            console.log("Polkit PAM auth error:", error)
            polkitAuth.authInProgress = false
            polkitAuth.dialogVisible = false
            polkitAuth.authCompleted(false)
        }

        onPamMessage: function(message) {
            console.log("Polkit PAM message:", message)
            // Update UI with PAM prompts
            if (message && message.length > 0) {
                authDialog.messageText = message
            }
        }
    }

    // Function to start authentication
    function startAuthentication(actionId, message, useIpcMode, cookie) {
        console.log("Starting polkit authentication for:", actionId)
        polkitAuth.actionId = actionId
        polkitAuth.message = message || "Authentication required"
        polkitAuth.authInProgress = true
        polkitAuth.dialogVisible = true
        polkitAuth.ipcMode = useIpcMode || false
        polkitAuth.currentCookie = cookie || ""

        // Reset timeout and fallback state
        polkitAuth.fidoFallback = false
        polkitAuth.fidoRetrying = false
        fidoRetryTimer.stop()

        // Detect FIDO keys when starting authentication
        fidoDetector.running = true

        if (polkitAuth.ipcMode) {
            console.log("Using IPC mode - authentication handled by quickshell-polkit-agent")
            console.log("Cookie:", polkitAuth.currentCookie)
            // Don't start PAM - the agent handles authentication

        } else {
            console.log("Using direct PAM mode")
            // Start PAM authentication
            pamContext.start()
        }
    }

    // Function to cancel authentication
    function cancelAuthentication() {
        console.log("Cancelling polkit authentication")
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
                console.log("FIDO key detection:", polkitAuth.fidoKeyPresent ? "Found" : "Not found")

                // Auto-submit for FIDO keys in IPC mode
                if (polkitAuth.fidoKeyPresent && polkitAuth.ipcMode && polkitAuth.currentCookie) {
                    console.log("Auto-submitting FIDO authentication")
                    polkitAuth.authInProgress = true
                    // Submit empty response to trigger FIDO auth
                    console.log("DEBUG: socketClient exists:", !!polkitAuth.socketClient)
                    if (polkitAuth.socketClient) {
                        console.log("DEBUG: Calling submitAuthentication with cookie:", polkitAuth.currentCookie)
                        polkitAuth.socketClient.submitAuthentication(polkitAuth.currentCookie, "")
                    } else {
                        console.log("ERROR: socketClient not available")
                    }
                }
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
                console.log("Focus restored to password field")
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
                console.log("Focus attempt", attempts, "for password field")
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
                console.log("FIDO retry timed out, falling back to password")
                polkitAuth.fidoRetrying = false
                polkitAuth.fidoFallback = true
                polkitAuth.authInProgress = false
                focusTimer.start()
            }
        }
    }

    // Function to get human-readable action names
    function getActionDisplayName(actionId) {
        var actionMap = {
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

        return actionMap[actionId] || actionId
    }

    // Authentication dialog layer shell
    WlrLayershell {
        id: authDialog
        visible: polkitAuth.dialogVisible
        namespace: "quickshell-polkit-auth"
        layer: WlrLayer.Overlay
        exclusiveZone: 0
        keyboardFocus: WlrKeyboardFocus.Exclusive

        // Center on screen using margins
        anchors.bottom: true
        margins.bottom: (screen.height - height) / 2
        margins.left: (screen.width - width) / 2

        onVisibleChanged: {
            console.log("PolkitAuth dialog visibility changed to:", visible)
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

        // Focus trapping - WlrLayershell handles focus automatically
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                polkitAuth.cancelAuthentication()
                event.accepted = true
            } else if (event.key === Qt.Key_Tab) {
                // Trap focus within dialog
                if (event.modifiers & Qt.ShiftModifier) {
                    // Shift+Tab - go to cancel button
                    cancelButton.forceActiveFocus()
                } else {
                    // Tab - go to authenticate button or password field
                    if (passwordField.activeFocus) {
                        if (authenticateButton.enabled) {
                            authenticateButton.forceActiveFocus()
                        }
                    } else {
                        passwordField.forceActiveFocus()
                    }
                }
                event.accepted = true
            }
        }

        width: Math.min(450, screen.width - 40)
        height: Math.min(polkitAuth.fidoFallback ? 360 : (polkitAuth.fidoKeyPresent ? 280 : 320), screen.height - 40)

        property string messageText: polkitAuth.message


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
                        width: 48
                        height: 48

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
                                font.pixelSize: 20
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
                            font.pixelSize: colors.textSize + 2
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
                            font.pixelSize: colors.smallTextSize
                        }
                    }
                }

                // Message
                Text {
                    text: authDialog.messageText
                    color: colors.green
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                // Human-readable action description
                Text {
                    text: getActionDisplayName(polkitAuth.actionId)
                    color: colors.peach
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
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
                    font.pixelSize: colors.smallTextSize

                    Keys.onReturnPressed: authenticateButton.clicked()
                    Keys.onEscapePressed: polkitAuth.cancelAuthentication()

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
                    font.pixelSize: 10
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
                            }

                            polkitAuth.cancelAuthentication()
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
                            console.log("Authentication button clicked")

                            if (polkitAuth.ipcMode && polkitAuth.currentCookie) {
                                // IPC mode - send to quickshell polkit agent
                                console.log("Submitting authentication via IPC, cookie:", polkitAuth.currentCookie)
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
