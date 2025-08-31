import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Column {
    id: systemTrayWidget
    spacing: 4

    // Configurable parameters
    property real itemSize: 32

    // Icon fallback configuration - can be customized per user/system
    // iconExtensions: File extensions to try when applications specify custom icon paths
    // enableTextFallback: Whether to show first letter of app name when icons fail to load
    property var iconExtensions: [".png", ".svg", ".xpm", ""]
    property bool enableTextFallback: true

    Colors {
        id: colors
    }

    Repeater {
        model: SystemTray.items
        delegate: Item {
            width: systemTrayWidget.itemSize
            height: systemTrayWidget.itemSize

            property var item: modelData

            Rectangle {
                anchors.fill: parent
                color: mouse.containsMouse ? colors.surface : "transparent"
                radius: 4

                Item {
                    anchors.centerIn: parent
                    width: systemTrayWidget.itemSize * 0.8
                    height: systemTrayWidget.itemSize * 0.8

                    property string processedIconSource: {
                        if (!parent.parent.item || !parent.parent.item.icon) return ""

                        var iconStr = parent.parent.item.icon.toString()

                        // Handle custom path format: iconname?path=/custom/path
                        // This is used by some applications (like Flatpak apps) to specify custom icon locations
                        if (iconStr.includes("?path=")) {
                            var parts = iconStr.split("?path=")
                            if (parts.length === 2) {
                                var iconName = parts[0].replace("image://icon/", "")
                                var iconPath = parts[1]

                                // Try configured icon file extensions in the specified path
                                // Return the first candidate - Image components will handle fallbacks
                                return "file://" + iconPath + "/" + iconName + systemTrayWidget.iconExtensions[0]
                            }
                        }

                        return iconStr
                    }

                    // Primary image attempt
                    Image {
                        id: primaryIcon
                        anchors.fill: parent
                        source: parent.processedIconSource
                        smooth: true
                        cache: false
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            // Silently handle icon loading errors
                            if (status === Image.Error && source !== "") {
                                // Icon failed to load, fallback will be handled by secondary icon or text
                            }
                        }
                    }

                    // Second attempt with different extension or fallback to icon theme
                    Image {
                        id: secondaryIcon
                        anchors.fill: parent
                        visible: primaryIcon.status !== Image.Ready
                        source: {
                            if (!parent.parent.parent.item || !parent.parent.parent.item.icon) return ""

                            var iconStr = parent.parent.parent.item.icon.toString()

                            // If it was a custom path, try the second configured extension
                            if (iconStr.includes("?path=") && systemTrayWidget.iconExtensions.length > 1) {
                                var parts = iconStr.split("?path=")
                                if (parts.length === 2) {
                                    var iconName = parts[0].replace("image://icon/", "")
                                    var iconPath = parts[1]
                                    return "file://" + iconPath + "/" + iconName + systemTrayWidget.iconExtensions[1]
                                }
                            }

                            // Otherwise try the icon through the icon theme
                            var cleanIconName = iconStr.replace("image://icon/", "").split("?")[0]
                            return "image://icon/" + cleanIconName
                        }
                        smooth: true
                        cache: false
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            // Silently handle secondary icon loading errors
                            if (status === Image.Error && source !== "") {
                                // Secondary icon failed, text fallback will be used if enabled
                            }
                        }
                    }

                    // Text fallback when both images fail (configurable)
                    Rectangle {
                        anchors.fill: parent
                        color: colors.blue
                        radius: 2
                        visible: systemTrayWidget.enableTextFallback &&
                                primaryIcon.status !== Image.Ready &&
                                secondaryIcon.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (parent.parent.parent.item && parent.parent.parent.item.title) {
                                    // Use first letter of the application title as fallback
                                    return parent.parent.parent.item.title.charAt(0).toUpperCase()
                                }
                                return "?"
                            }
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.bold: true
                            color: "white"
                        }
                    }
                }

                QsMenuAnchor {
                    id: menuAnchor

                    // Window will be set dynamically when opening menu
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onEntered: {
                        if (parent.parent.item && parent.parent.item.title) {
                            tooltip.showAt(
                                systemTrayWidget.mapToGlobal(parent.parent.x + parent.parent.width, parent.parent.y).x,
                                systemTrayWidget.mapToGlobal(parent.parent.x, parent.parent.y).y,
                                parent.parent.item.title
                            )
                        }
                    }

                    onExited: {
                        tooltip.hide()
                    }

                    onClicked: function(mouse) {
                        if (parent.parent.item) {
                            if (mouse.button === 2 && parent.parent.item.hasMenu) {
                                // Right click - open context menu
                                if (parent.parent.item.menu) {
                                    menuAnchor.menu = parent.parent.item.menu
                                }

                                // Set up window and anchor positioning
                                try {
                                    var window2 = systemTrayWidget.QsWindow
                                    if (window2 && window2.window) {
                                        menuAnchor.anchor.window = window2.window
                                        var globalMousePos = systemTrayWidget.mapToGlobal(parent.parent.x + mouse.x, parent.parent.y + mouse.y)

                                        menuAnchor.anchor.rect.x = globalMousePos.x - 2
                                        menuAnchor.anchor.rect.y = globalMousePos.y - 2  
                                        menuAnchor.anchor.rect.width = 4
                                        menuAnchor.anchor.rect.height = 4
                                    }
                                } catch (e) {
                                    // Silently handle anchor setup errors
                                }

                                try {
                                    if (menuAnchor.menu) {
                                        menuAnchor.open()
                                    }
                                } catch (e) {
                                    // Silently handle menu open errors
                                }
                            } else if (mouse.button === Qt.LeftButton) {
                                // Left click - activate
                                try {
                                    parent.parent.item.activate()
                                } catch (e) {
                                    // Silently handle activation errors
                                }
                            } else if (mouse.button === Qt.RightButton) {
                                // Right click - secondary activate (for items without menus)
                                try {
                                    parent.parent.item.secondaryActivate()
                                } catch (e) {
                                    // Silently handle secondary activation errors
                                }
                            }
                        }
                    }

                    onWheel: function(wheel) {
                        if (parent.parent.item && parent.parent.item.scroll) {
                            parent.parent.item.scroll(wheel.angleDelta.x, wheel.angleDelta.y)
                        }
                    }
                }
            }
        }
    }

    // Tooltip
    SimpleTooltip {
        id: tooltip
        backgroundColor: colors.surface
        borderColor: colors.overlay
        textColor: colors.text
    }
}
