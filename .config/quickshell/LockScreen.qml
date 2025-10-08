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
        console.log("🔓 Hiding lock screen");
        console.log("🔓 Setting lockScreen.locked = false");
        lockScreen.locked = false;
        console.log("🔓 Setting sessionLock.locked = false");
        sessionLock.locked = false;
        console.log("🔓 Lock screen hide complete");
    }

    // PAM context for authentication
    property PamContext pamContext: PamContext {
        id: pamContext

        config: "login"  // Use login config for lock screen

        onCompleted: function (result) {
            console.log("🔐 Lock screen PAM auth completed:", result);
            console.log("🔐 Result type:", typeof result);
            console.log("🔐 PamResult.Success:", PamResult.Success);

            if (result === PamResult.Success) {
                console.log("✅ Lock screen unlocked successfully");
                lockScreen.hide();
                lockScreen.unlocked();
            } else {
                console.log("❌ Lock screen authentication failed, result:", result);
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
        }

        surface: Component {
            LockSurface {
                pamContext: lockScreen.pamContext
                currentUser: lockScreen.currentUser
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

    // Socket server to trigger lock via command
    property SocketServer lockSocket: SocketServer {
        id: lockSocket

        active: true
        path: "/run/user/1000/quickshell-lock.sock"

        handler: Socket {
            onConnectedChanged: {
                if (connected) {
                    console.log("Lock socket: New connection");
                } else {
                    console.log("Lock socket: Connection dropped");
                }
            }

            parser: SplitParser {
                onRead: function(data) {
                    const cmd = data.trim();
                    console.log("Lock socket command:", cmd);

                    if (cmd === "lock") {
                        lockScreen.show();
                    } else if (cmd === "unlock") {
                        lockScreen.hide();
                    } else if (cmd === "status") {
                        if (lockScreen.locked) {
                            write("locked\n");
                        } else {
                            write("unlocked\n");
                        }
                    }
                }
            }
        }

        Component.onCompleted: {
            console.log("Lock socket server started at:", path);
        }
    }

    Component.onCompleted: {
        console.log("LockScreen component loaded");
    }
}
