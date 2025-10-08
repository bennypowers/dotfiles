import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: idleMonitor

    // Idle timeout in milliseconds (default: 5 minutes)
    property int idleTimeout: 5 * 60 * 1000

    // Check interval in milliseconds (default: 30 seconds)
    property int checkInterval: 30 * 1000

    // Whether idle monitoring is enabled
    property bool enabled: true

    // Signal emitted when system becomes idle
    signal idle()

    // Signal emitted when system becomes active again
    signal active()

    // Current idle state
    property bool isIdle: false

    // Internal properties
    property int currentIdleTime: 0
    property bool wasIdle: false

    // Timer to periodically check idle time
    property Timer checkTimer: Timer {
        interval: idleMonitor.checkInterval
        running: idleMonitor.enabled
        repeat: true

        onTriggered: {
            if (idleMonitor.enabled) {
                idleCheckProcess.running = true;
            }
        }
    }

    // Process to check idle time using loginctl
    property Process idleCheckProcess: Process {
        id: idleCheckProcess

        // Use loginctl to get idle time - works on systemd systems
        command: ["sh", "-c", "loginctl show-session $(loginctl show-user $USER -p Display --value) -p IdleHint -p IdleSinceHint --value"]

        running: false

        stdout: SplitParser {
            onRead: function(data) {
                // Output format from loginctl:
                // Line 1: IdleHint (yes/no)
                // Line 2: IdleSinceHint (timestamp or 0)

                const lines = data.trim().split('\n');
                if (lines.length >= 2) {
                    const idleHint = lines[0].trim();
                    const idleSince = lines[1].trim();

                    console.log("💤 Idle check - IdleHint:", idleHint, "IdleSince:", idleSince);

                    if (idleHint === "yes" && idleSince !== "0") {
                        // User is idle
                        const idleTimestamp = parseInt(idleSince);
                        const now = Date.now() * 1000; // Convert to microseconds
                        const idleTime = (now - idleTimestamp) / 1000; // Convert to milliseconds

                        console.log("💤 Idle time:", Math.floor(idleTime / 1000), "seconds");

                        idleMonitor.currentIdleTime = idleTime;

                        if (idleTime >= idleMonitor.idleTimeout) {
                            if (!idleMonitor.isIdle) {
                                console.log("💤 System is now idle (threshold:", idleMonitor.idleTimeout / 1000, "seconds)");
                                idleMonitor.isIdle = true;
                                idleMonitor.idle();
                            }
                        }
                    } else {
                        // User is active
                        if (idleMonitor.isIdle) {
                            console.log("💤 System is now active");
                            idleMonitor.isIdle = false;
                            idleMonitor.active();
                        }
                        idleMonitor.currentIdleTime = 0;
                    }
                }
            }
        }

        stderr: SplitParser {
            onRead: function(data) {
                console.log("⚠️  Idle check error:", data);
            }
        }
    }

    Component.onCompleted: {
        console.log("💤 IdleMonitor initialized");
        console.log("💤   - Idle timeout:", idleTimeout / 1000, "seconds");
        console.log("💤   - Check interval:", checkInterval / 1000, "seconds");
        console.log("💤   - Enabled:", enabled);
    }
}
