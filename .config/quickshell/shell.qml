//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    id: shellRoot

    // Global tooltip management for droplet border coordination
    property var activeTooltip: null

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

    // Global function for tooltip registration
    function registerTooltip(tooltip) {
        activeTooltip = tooltip;
    }
    function unregisterTooltip(tooltip) {
        if (activeTooltip === tooltip) {
            activeTooltip = null;
        }
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
                        shellRoot: shellRoot
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
                        shellRoot: shellRoot
                    }
                }

                // Continuous border for droplet effect
                Canvas {
                    id: dropletBorder

                    function calculateArcPath(tooltipX, tooltipY, tooltipWidth, tooltipHeight, radius) {
                        var ctx = getContext("2d");
                        ctx.reset();

                        if (!shellRoot.activeTooltip || !shellRoot.activeTooltip.dropletVisible) {
                            return;
                        }

                        // Calculate tooltip position relative to panel
                        var panelLeft = 0;
                        var panelRight = width;
                        var panelTop = 0;
                        var panelBottom = height;

                        // Calculate tooltip coordinates relative to panel
                        var ttTop = tooltipY;
                        var ttBottom = tooltipY + tooltipHeight;
                        var ttLeft = tooltipX;
                        var ttRight = tooltipX + tooltipWidth;

                        // Arc geometry for 45-degree connections
                        var arcRadius = radius;
                        var topArcStartX = ttRight;
                        var topArcStartY = ttTop + radius;
                        var topArcEndX = panelLeft;
                        var topArcEndY = ttTop;

                        var bottomArcStartX = ttRight;
                        var bottomArcStartY = ttBottom - radius;
                        var bottomArcEndX = panelLeft;
                        var bottomArcEndY = ttBottom;

                        // Set stroke style
                        ctx.strokeStyle = colors.overlay;
                        ctx.lineWidth = 1;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        // Draw continuous border path
                        ctx.beginPath();

                        // Start from panel top
                        ctx.moveTo(panelLeft, panelTop);

                        // Down panel to top arc connection
                        ctx.lineTo(panelLeft, topArcEndY);

                        // Top droplet arc (45-degree curve from panel to tooltip)
                        var topControlX = topArcStartX + arcRadius * 0.707;  // 45-degree control point
                        var topControlY = topArcStartY - arcRadius * 0.707;
                        ctx.quadraticCurveTo(topControlX, topControlY, topArcStartX, topArcStartY);

                        // Tooltip top edge
                        ctx.lineTo(ttLeft + radius, ttTop);

                        // Tooltip top-left corner
                        ctx.arcTo(ttLeft, ttTop, ttLeft, ttTop + radius, radius);

                        // Tooltip left edge
                        ctx.lineTo(ttLeft, ttBottom - radius);

                        // Tooltip bottom-left corner
                        ctx.arcTo(ttLeft, ttBottom, ttLeft + radius, ttBottom, radius);

                        // Tooltip bottom edge
                        ctx.lineTo(bottomArcStartX, ttBottom);

                        // Bottom droplet arc (45-degree curve from tooltip to panel)
                        var bottomControlX = bottomArcStartX + arcRadius * 0.707;
                        var bottomControlY = bottomArcStartY + arcRadius * 0.707;
                        ctx.quadraticCurveTo(bottomControlX, bottomControlY, panelLeft, bottomArcEndY);

                        // Down panel to bottom
                        ctx.lineTo(panelLeft, panelBottom);

                        // Stroke the path
                        ctx.stroke();
                    }

                    anchors.fill: parent
                    z: 100  // Above all panel content

                    onPaint: {
                        if (shellRoot.activeTooltip && shellRoot.activeTooltip.dropletVisible) {
                            calculateArcPath(shellRoot.activeTooltip.dropletX - x  // Relative to panel
                            , shellRoot.activeTooltip.dropletY - y, shellRoot.activeTooltip.dropletWidth, shellRoot.activeTooltip.dropletHeight, shellRoot.activeTooltip.dropletRadius);
                        }
                    }

                    // Redraw when tooltip properties change
                    Connections {
                        target: shellRoot.activeTooltip
                    }
                }
            }
        }
    }
}
