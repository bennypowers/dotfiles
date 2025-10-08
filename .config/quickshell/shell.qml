//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    id: shellRoot

    // Session detection
    readonly property string currentDesktop: Qt.application.environment["XDG_CURRENT_DESKTOP"] || "Unknown"

    // Global font configuration
    readonly property string defaultFontFamily: colors.fontFamily
    readonly property int defaultFontSize: 12
    readonly property bool isHyprland: currentDesktop === "Hyprland"
    readonly property bool isNiri: currentDesktop === "NiRi"
    readonly property int largeFontSize: 14
    readonly property int panelBottomMargin: 24
    readonly property int panelLeftMargin: 0
    readonly property int panelRightMargin: 22

    // Global margin configuration
    readonly property int panelTopMargin: 24
    readonly property int smallFontSize: 8

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

    // Notification Server
    NotificationServer {
        id: notificationServer

        property var notificationContentMap: ({})  // Map notification ID to content item
        property var readNotifications: ({})  // Track read notifications by ID
        property int unreadCount: 0

        // Enable all features
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        inlineReplySupported: true

        onNotification: function(notification) {
            console.log("Notification received:", notification.summary);

            // Track the notification for history
            notification.tracked = true;

            // Increment unread count
            unreadCount++;

            console.log("Creating notification content component...");
            // Create notification content
            var content = notificationContentComponent.createObject(null, {
                "notification": notification
            });

            if (!content) {
                console.log("ERROR: Failed to create notification content");
                return;
            }

            console.log("Content created, adding to container...");

            // Store mapping
            notificationContentMap[notification.id] = content;

            // Add to container
            if (notificationPopupContainer) {
                notificationPopupContainer.addNotification(content);
                console.log("Added to container, updating positions...");
                updateNotificationPositions();
            } else {
                console.log("ERROR: notificationPopupContainer is null");
            }

            // Auto-dismiss timer
            if (!notification.resident) {
                var timeout = notification.expireTimeout > 0 ? notification.expireTimeout : 5000;
                Qt.callLater(function() {
                    var timer = Qt.createQmlObject('import QtQuick; Timer { interval: ' + timeout + '; running: true; repeat: false }', content);
                    timer.triggered.connect(function() {
                        if (!content.hovered && notification) {
                            notification.expire();
                        }
                    });
                });
            }
        }

        function markAllAsRead() {
            var notifications = trackedNotifications.values;
            for (var i = 0; i < notifications.length; i++) {
                readNotifications[notifications[i].id] = true;
            }
            unreadCount = 0;
        }

        function updateNotificationPositions() {
            var contents = notificationPopupContainer.notificationContents;
            for (var i = 0; i < contents.length; i++) {
                if (contents[i]) {
                    contents[i].isFirst = (i === 0);
                    contents[i].isLast = (i === contents.length - 1);
                }
            }
        }
    }

    // Notification popup container (single container for all notifications)
    NotificationPopupContainer {
        id: notificationPopupContainer
        notificationServer: notificationServer
    }

    // Notification content component
    Component {
        id: notificationContentComponent

        NotificationContent {
            id: content

            Connections {
                target: notification

                function onClosed(reason) {
                    // Remove from container
                    notificationPopupContainer.removeNotification(content);
                    delete notificationServer.notificationContentMap[notification.id];
                    notificationServer.updateNotificationPositions();

                    // Decrement unread count if not already read
                    if (!notificationServer.readNotifications[notification.id]) {
                        notificationServer.unreadCount = Math.max(0, notificationServer.unreadCount - 1);
                    }
                }
            }
        }
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
    }
    Colors {
        id: colors

    }
    // Right panel
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: rightPanel

            property var modelData

            implicitWidth: 80
            screen: modelData

            Component.onCompleted: {
                console.log("📐 Right panel modelData:", modelData);
                console.log("📐 Right panel screen:", screen);
                console.log("📐 Right panel screen.width:", screen ? screen.width : "screen is null");
            }

            anchors {
                bottom: true
                right: true
                top: true
            }
            Rectangle {
                id: bar

                anchors.fill: parent
                color: colors.black

                ColumnLayout {
                    anchors.bottomMargin: panelBottomMargin
                    anchors.fill: parent
                    anchors.margins: 8
                    anchors.rightMargin: panelRightMargin
                    // anchors.topMargin: panelTopMargin
                    anchors.topMargin: 4

                    // System Menu (replaces Volume, Mic, Network, Language, Power widgets)
                    SystemMenuButton {
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredHeight: 50
                        Layout.rightMargin: 8
                        screenWidth: rightPanel.screen ? rightPanel.screen.width : 0
                        shellRoot: shellRoot
                    }

                    // CPU widget
                    CpuBarWidget {
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredWidth: parent.width
                        screenWidth: rightPanel.screen ? rightPanel.screen.width : 0
                        shellRoot: shellRoot
                    }

                    // Workspace switcher (minimap style) at top
                    WorkspaceIndicator {
                        Layout.leftMargin: 8
                        Layout.preferredWidth: parent.width
                    }

                    // Spacer to push bottom widgets down
                    Item {
                        Layout.fillHeight: true
                    }

                    // System tray
                    SystemTrayWidget {
                        Layout.leftMargin: 14
                        // Layout.preferredHeight: 120
                        Layout.preferredWidth: parent.width
                        // shellRoot: shellRoot  // Temporarily disabled due to binding loop
                    }
                }
            }
        }
    }

    // Top panel
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            implicitHeight: 48
            screen: modelData

            anchors {
                left: true
                right: true
                top: true
            }
            Rectangle {
                id: topBar

                anchors.fill: parent
                color: colors.black

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    // Notification icon (left side)
                    NotificationIcon {
                        Layout.alignment: Qt.AlignLeft
                        notificationServer: notificationServer
                        notificationContainer: notificationPopupContainer
                    }

                    // Left spacer
                    Item {
                        Layout.fillWidth: true
                    }

                    // Clock (centered)
                    ClockWidget {
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Right spacer
                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    // Corner inset between panels (top-right)
    Variants {
        model: Quickshell.screens

        CornerInset {
            property var modelData

            fillColor: colors.black
            radius: 16
            screen: modelData

            anchors {
                right: true
                top: true
            }
        }
    }

    // Top-left corner
    Variants {
        model: Quickshell.screens

        CornerInset {
            property var modelData

            fillColor: colors.black
            radius: 16
            rotation: 270
            screen: modelData

            anchors {
                left: true
                top: true
            }
            margins {
                left: 0
                top: 0
            }
        }
    }

    // Bottom-left corner
    Variants {
        model: Quickshell.screens

        CornerInset {
            property var modelData

            fillColor: colors.black
            radius: 16
            rotation: 180
            screen: modelData

            anchors {
                bottom: true
                left: true
            }
            margins {
                bottom: 0
                left: 0
            }
        }
    }

    // Bottom-right corner
    Variants {
        model: Quickshell.screens

        CornerInset {
            property var modelData

            fillColor: colors.black
            radius: 16
            rotation: 90
            screen: modelData

            anchors {
                bottom: true
                right: true
            }
            margins {
                bottom: 0
                right: 0
            }
        }
    }
}
