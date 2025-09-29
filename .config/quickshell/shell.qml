//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    id: shellRoot

    // Global font configuration
    readonly property string defaultFontFamily: colors.fontFamily
    readonly property int defaultFontSize: 12
    readonly property int largeFontSize: 14
    readonly property int panelBottomMargin: 24
    readonly property int panelLeftMargin: 0
    readonly property int panelRightMargin: 22

    // Global margin configuration
    readonly property int panelTopMargin: 24
    readonly property int smallFontSize: 8

    // Session detection
    readonly property string currentDesktop: Qt.application.environment["XDG_CURRENT_DESKTOP"] || "Unknown"
    readonly property bool isHyprland: currentDesktop === "Hyprland"
    readonly property bool isNiri: currentDesktop === "NiRi"

    objectName: "shellRoot"

    // Make shellRoot globally accessible
    Component.onCompleted: {
        console.log("🌍 Setting global shellRoot reference");
        console.log("🖥️  Current desktop session:", currentDesktop);
        Qt.application.globalShellRoot = shellRoot;
    }

    // Volume OSD
    VolumeOSD {
    }

    // Polkit Authentication Handler
    PolkitAuth {
        id: polkitAuth

        socketClient: polkitSocketClient
    }

    // Polkit Socket Client
    PolkitSocketClient {
        id: polkitSocketClient

        onAuthorizationError: function (error) {
            polkitAuth.authInProgress = false;
            polkitAuth.authTimedOut = true;
        // Don't auto-dismiss on error, let user see the error and manually cancel
        }
        onAuthorizationResult: function (authorized, actionId) {
            polkitAuth.authInProgress = false;

            if (!authorized) {
                // Authentication failed/cancelled - dismiss dialog
                polkitAuth.dialogVisible = false;
                polkitAuth.authCompleted(false);
            } else {
                // Success - dismiss dialog
                polkitAuth.dialogVisible = false;
                polkitAuth.authCompleted(true);
            }
        }
        onPasswordRequest: function (actionId, request, echo, cookie) {
            // This indicates FIDO timed out and fell back to password
            polkitAuth.fidoFallback = true;
            polkitAuth.fidoRetrying = false;
            polkitAuth.authInProgress = false;
            // Update the cookie for this new password session
            polkitAuth.currentCookie = cookie;
            // Dialog should now show both "Try FIDO Again" and password input
            // Trigger focus restoration
            polkitAuth.startFocusTimer();
        }
        onShowAuthDialog: function (actionId, message, iconName, cookie) {
            polkitAuth.startAuthentication(actionId, message, true, cookie);
        }
    }

    // Lock Screen
    LockScreen {
        id: lockScreen

        onLockRequested: {
            lockScreen.show();
        }
    }
    Colors {
        id: colors

    }
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            implicitWidth: 80
            screen: modelData

            anchors {
                bottom: true
                right: true
                top: true
            }
            Rectangle {
                id: bar

                anchors.fill: parent
                color: colors.base

                ColumnLayout {
                    anchors.bottomMargin: panelBottomMargin
                    anchors.fill: parent
                    anchors.margins: 8
                    anchors.rightMargin: panelRightMargin
                    anchors.topMargin: panelTopMargin

                    // CPU widget
                    CpuWidget {
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: parent.width
                    }

                    // Volume widget at bottom
                    VolumeWidget {
                        Layout.leftMargin: 6
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: parent.width
                    }

                    // Microphone widget
                    MicWidget {
                        Layout.leftMargin: 4
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }

                    // Camera widget
                    CameraWidget {
                        Layout.leftMargin: 4
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }

                    // Workspace switcher (minimap style) at top
                    WorkspaceIndicator {
                        Layout.leftMargin: 8
                        Layout.preferredWidth: parent.width
                    }

                    // Spacer to center clock
                    Item {
                        Layout.fillHeight: true
                    }

                    // Clock (centered)
                    ClockWidget {
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: parent.width
                    }

                    // Spacer to push bottom widgets down
                    Item {
                        Layout.fillHeight: true
                    }

                    // System tray
                    SystemTrayWidget {
                        Layout.leftMargin: 14
                        Layout.preferredHeight: 120
                        Layout.preferredWidth: parent.width
                        // shellRoot: shellRoot  // Temporarily disabled due to binding loop
                    }

                    // Workmode widget (vm/WM) at very bottom
                    WorkmodeWidget {
                        Layout.leftMargin: 8
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }

                    // Network widget at bottom
                    NetworkWidget {
                        Layout.leftMargin: 8
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }

                    // Language switcher widget
                    LanguageWidget {
                        Layout.leftMargin: 8
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }

                    // Power widget at very bottom
                    PowerWidget {
                        Layout.leftMargin: 8
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: parent.width
                    }
                }
            }
        }
    }
}
