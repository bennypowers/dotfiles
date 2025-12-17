import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

pragma ComponentBehavior: Bound

Item {
    id: lockScreen

    property bool locked: false
    property string currentUser: "User"

    signal unlocked

    property var screenCaptureMap: ({})

    // Background screen captures (only active when about to lock)
    Repeater {
        id: screenCaptures
        model: Quickshell.screens

        Item {
            id: captureItem
            required property var modelData

            ScreencopyView {
                id: capture
                captureSource: captureItem.modelData
                live: false  // Single frame only
                paintCursor: false
                visible: true  // Must be visible to render (even if hidden offscreen)

                // Set explicit size to match screen
                width: captureItem.modelData.width
                height: captureItem.modelData.height

                // Store reference for LockSurface to access
                Component.onCompleted: {
                    lockScreen.screenCaptureMap[captureItem.modelData.name] = capture
                }
            }
        }
    }

    // IPC handler for lock/unlock commands
    property IpcHandler ipcHandler: IpcHandler {
        target: "lockscreen"

        function lock() {
            console.log("🔒 IPC lock() called");
            lockScreen.show();
        }

        function unlock() {
            console.log("🔓 IPC unlock() called");
            lockScreen.hide();
        }
    }

    function show() {
        // Capture all screens before showing lock
        for (const screenName in lockScreen.screenCaptureMap) {
            const capture = lockScreen.screenCaptureMap[screenName];
            if (capture) {
                capture.captureFrame();
            }
        }

        // Delay showing lock to ensure capture completes
        Qt.callLater(() => {
            lockScreen.locked = true;
            sessionLock.locked = true;
        });
    }

    function hide() {
        lockScreen.locked = false;
        sessionLock.locked = false;
    }

    // PAM context for authentication
    property PamContext pamContext: PamContext {
        id: pamContext

        config: "login"  // Use login config for lock screen

        onCompleted: function (result) {
            if (result === PamResult.Success) {
                lockScreen.hide();
                lockScreen.unlocked();
            }
            // The LockSurface will handle the error display
        }

        onPamMessage: function (message) {
            console.log("Lock screen PAM message:", message);
        }
    }

    // Session lock
    property WlSessionLock sessionLock: WlSessionLock {
        id: sessionLock

        locked: false

        onSecureChanged: {
            console.log("Session lock secure state:", sessionLock.secure);
        }

        onLockedChanged: {
            console.log("Session lock state changed:", sessionLock.locked);
        }

        surface: Component {
            LockSurface {
                pamContext: lockScreen.pamContext
                currentUser: lockScreen.currentUser
                screenCaptureMap: lockScreen.screenCaptureMap
                isLocked: lockScreen.locked
                onUnlockRequested: lockScreen.hide()
            }
        }
    }

    // Load user info
    property Process userInfoProcess: Process {
        id: userInfoProcess

        command: ["whoami"]
        running: true

        stdout: SplitParser {
            onRead: function(data) {
                const trimmed = data.trim();
                if (trimmed) {
                    lockScreen.currentUser = trimmed;
                    console.log("Lock screen user:", lockScreen.currentUser);
                }
            }
        }
    }


    Component.onCompleted: {
        console.log("LockScreen component loaded");
    }
}
