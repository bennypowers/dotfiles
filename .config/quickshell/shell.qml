//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    // Global font configuration
    readonly property string defaultFontFamily: colors.fontFamily
    readonly property int defaultFontSize: 12
    readonly property int smallFontSize: 8
    readonly property int largeFontSize: 14

    // Global margin configuration
    readonly property int panelTopMargin: 24
    readonly property int panelBottomMargin: 24
    readonly property int panelLeftMargin: 0
    readonly property int panelRightMargin: 22

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
            polkitAuth.startAuthentication(actionId, message, true, cookie)
        }

        onAuthorizationResult: function(authorized, actionId) {
            polkitAuth.authInProgress = false

            if (!authorized) {
                // Authentication failed/timed out - show timeout message
                polkitAuth.authTimedOut = true
                // Don't auto-dismiss, let user see the failure and manually cancel
            } else {
                // Success - dismiss dialog
                polkitAuth.dialogVisible = false
            }
        }

        onAuthorizationError: function(error) {
            polkitAuth.authInProgress = false
            polkitAuth.authTimedOut = true
            // Don't auto-dismiss on error, let user see the error and manually cancel
        }

        onPasswordRequest: function(actionId, request, echo, cookie) {
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
        onLockRequested: {
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
            polkitAuth.startAuthentication("org.example.test.ipc", "IPC test authentication")
        }

        function testLockScreen() {
            lockScreen.show()
        }

        function testInterceptor() {
            polkitInterceptor.triggerTestAuth()
        }

        function enablePolkitIntercept() {
            polkitInterceptor.enableInterceptMode()
        }

        function showPolkitAuth() {
            polkitAuth.startAuthentication("org.example.direct", "Direct polkit authentication test")
        }

        function reloadUserInfo() {
            polkitAuth.loadUserInfo()
        }

        function replacePolkitAgent() {
            polkitBackend.replacePolkitAgent()
        }

        function restorePolkitAgent() {
            polkitBackend.restorePolkitAgent()
        }

        function checkPolkitStatus() {
            console.log("Polkit agent replaced:", polkitBackend.agentReplaced)
        }
    }

    Colors {
        id: colors
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                right: true
                top: true
                bottom: true
            }

            implicitWidth: 80

            Rectangle {
                anchors.fill: parent

                color: colors.crust

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: panelTopMargin
                    anchors.bottomMargin: panelBottomMargin
                    anchors.rightMargin: panelRightMargin
                    anchors.margins: 8

                    // CPU widget
                    CpuWidget {
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: 60
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Volume widget at bottom
                    VolumeWidget {
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: 60
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

            // Inverted rounded corners (top-left, bottom-left)
            // These create the illusion that the desktop has rounded corners
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.rightMargin: 16
                width: 16
                height: 16
                color: colors.yellow
                bottomRightRadius: 10
                border.width: 10
                border.color: colors.crust
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.right
                width: 16
                height: 16
                color: colors.yellow
                topRightRadius: 10
                border.width: 10
                border.color: colors.crust
            }

        }
    }

}
