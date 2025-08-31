//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import Quickshell.DBusMenu
import Quickshell.Hyprland

ShellRoot {
    // Global font configuration
    readonly property string defaultFontFamily: "JetBrainsMono Nerd Font"
    readonly property int defaultFontSize: 12
    readonly property int smallFontSize: 8
    readonly property int largeFontSize: 14

    // Global margin configuration
    readonly property int panelTopMargin: 24
    readonly property int panelBottomMargin: 24
    readonly property int panelLeftMargin: 22
    readonly property int panelRightMargin: 16

    // Volume OSD
    VolumeOSD {}


    // Polkit Authentication Handler
    PolkitAuth {
        id: polkitAuth
        socketClient: polkitSocketClient
    }


    // Polkit Socket Client
    PolkitSocketClient {
        id: polkitSocketClient
        
        onShowAuthDialog: function(actionId, message, iconName, cookie) {
            console.log("🔐 Polkit authentication requested via socket:", actionId)
            polkitAuth.startAuthentication(actionId, message, true, cookie)
        }
        
        onAuthorizationResult: function(authorized, actionId) {
            console.log("✅ Polkit result:", authorized ? "GRANTED" : "DENIED", "for", actionId)
            polkitAuth.authInProgress = false
            
            if (!authorized) {
                // Authentication failed/timed out - show timeout message
                console.log("Authentication failed, showing timeout state")
                polkitAuth.authTimedOut = true
                // Don't auto-dismiss, let user see the failure and manually cancel
            } else {
                // Success - dismiss dialog
                polkitAuth.dialogVisible = false
            }
        }
        
        onAuthorizationError: function(error) {
            console.log("❌ Polkit error:", error)
            polkitAuth.authInProgress = false
            polkitAuth.authTimedOut = true
            // Don't auto-dismiss on error, let user see the error and manually cancel
        }
        
        onConnected: {
            console.log("✅ Connected to quickshell-polkit-agent")
        }
        
        onDisconnected: {
            console.log("❌ Disconnected from quickshell-polkit-agent")
        }
        
        onPasswordRequest: function(actionId, request, echo, cookie) {
            console.log("🔐 Password request after FIDO timeout:", request, "for", actionId)
            // This indicates FIDO timed out and fell back to password
            polkitAuth.fidoFallback = true
            polkitAuth.fidoRetrying = false
            polkitAuth.authInProgress = false
            // Update the cookie for this new password session
            polkitAuth.currentCookie = cookie
            // Dialog should now show both "Try FIDO Again" and password input
            // Trigger focus restoration
            polkitAuth.focusTimer.start()
        }
    }

    // Lock Screen
    LockScreen {
        id: lockScreen

        onUnlocked: {
            console.log("Screen unlocked successfully")
        }

        onLockRequested: {
            console.log("Screen lock requested")
            lockScreen.show()
        }
    }

    // Test Panel (disabled - can be re-enabled manually)
    AuthTestPanel {
        id: testPanel
        polkitAuth: polkitAuth
        lockScreen: lockScreen
        polkitInterceptor: polkitSocketClient
    }


    // IPC Handler for test panel
    IpcHandler {
        target: "authTestPanel"

        function showAuthTestPanel() {
            testPanel.showTestPanel()
        }

        function hideAuthTestPanel() {
            testPanel.hideTestPanel()
        }

        function toggleAuthTestPanel() {
            testPanel.toggleTestMode()
        }
    }

    // IPC Handler for authentication testing
    IpcHandler {
        target: "authTest"

        function testPolkitAuth() {
            console.log("Testing polkit authentication via IPC")
            polkitAuth.startAuthentication("org.example.test.ipc", "IPC test authentication")
        }

        function testLockScreen() {
            console.log("Testing lock screen via IPC")
            lockScreen.show()
        }

        function testInterceptor() {
            console.log("Testing polkit interceptor via IPC")
            polkitInterceptor.triggerTestAuth()
        }

        function enablePolkitIntercept() {
            console.log("Enabling polkit intercept mode via IPC")
            polkitInterceptor.enableInterceptMode()
        }

        function showPolkitAuth() {
            console.log("Showing polkit auth dialog directly")
            polkitAuth.startAuthentication("org.example.direct", "Direct polkit authentication test")
        }

        function reloadUserInfo() {
            console.log("Reloading user information from AccountsService")
            polkitAuth.loadUserInfo()
        }

        function replacePolkitAgent() {
            console.log("Replacing polkit agent with quickshell")
            polkitBackend.replacePolkitAgent()
        }

        function restorePolkitAgent() {
            console.log("Restoring original polkit agent")
            polkitBackend.restorePolkitAgent()
        }

        function checkPolkitStatus() {
            console.log("Polkit agent replaced:", polkitBackend.agentReplaced)
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                left: true
                top: true
                bottom: true
            }

            implicitWidth: 64
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: panelTopMargin
                anchors.bottomMargin: panelBottomMargin
                anchors.leftMargin: panelLeftMargin
                anchors.rightMargin: panelRightMargin

                // CPU widget
                CpuWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                    Layout.leftMargin: 6
                    Layout.alignment: Qt.AlignCenter
                }

                // Volume widget at bottom
                VolumeWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                    Layout.leftMargin: 6
                }

                // Workspace switcher (minimap style) at top
                WorkspaceIndicator {
                    Layout.preferredWidth: parent.width
                }

                // Spacer to center clock
                Item {
                    Layout.fillHeight: true
                }

                // Clock (centered)
                ClockWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                }

                // Spacer to push bottom widgets down
                Item {
                    Layout.fillHeight: true
                }

                // System tray
                SystemTrayWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 120
                }

                // Workmode widget (vm/WM) at very bottom
                WorkmodeWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 40
                }

                // Network widget at bottom
                NetworkWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 40
                }

                // Power widget at very bottom
                PowerWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 40
                }

            }
        }
    }
}
