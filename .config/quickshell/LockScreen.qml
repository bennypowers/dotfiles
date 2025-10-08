import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

QtObject {
    id: lockScreen

    property bool locked: false
    property string currentUser: "User"

    signal unlocked

    function show() {
        console.log("Showing lock screen");
        lockScreen.locked = true;
        sessionLock.locked = true;
    }

    function hide() {
        console.log("Hiding lock screen");
        lockScreen.locked = false;
        sessionLock.unlock();
    }

    // PAM context for authentication
    property PamContext pamContext: PamContext {
        id: pamContext

        config: "login"  // Use login config for lock screen

        onCompleted: function (result) {
            console.log("Lock screen PAM auth completed:", result);

            if (result === PamResult.Success) {
                console.log("Lock screen unlocked successfully");
                lockScreen.hide();
                lockScreen.unlocked();
            } else {
                console.log("Lock screen authentication failed");
                // The LockSurface will handle the error display
            }
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
            if (!sessionLock.locked) {
                lockScreen.locked = false;
            }
        }

        surface: Component {
            LockSurface {
                pamContext: lockScreen.pamContext
                lockScreen: lockScreen
            }
        }
    }

    // Load user info
    property Process userInfoProcess: Process {
        id: userInfoProcess

        command: ["/home/bennyp/.config/quickshell/get-user-info.sh"]
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
