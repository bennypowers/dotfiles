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
                        console.log("=== TRAY CLICK DEBUG ===")
                        console.log("Mouse button:", mouse.button)
                        console.log("Mouse position:", mouse.x, mouse.y)
                        console.log("Parent item exists:", parent.parent.item ? "YES" : "NO")

                        if (parent.parent.item) {
                            console.log("Item details:")
                            console.log("  - Title:", parent.parent.item.title)
                            console.log("  - ID:", parent.parent.item.id)
                            console.log("  - Status:", parent.parent.item.status)
                            console.log("  - Category:", parent.parent.item.category)
                            console.log("  - HasMenu:", parent.parent.item.hasMenu)
                            console.log("  - OnlyMenu:", parent.parent.item.onlyMenu)

                            if (mouse.button === 2 && parent.parent.item.hasMenu) {
                                console.log("Right click - opening menu with QsMenuAnchor")
                                console.log("Item menu exists:", parent.parent.item.menu ? "YES" : "NO")
                                console.log("Item menu object:", parent.parent.item.menu)

                                // Set the menu dynamically
                                if (parent.parent.item.menu) {
                                    menuAnchor.menu = parent.parent.item.menu
                                    console.log("Set menu anchor menu:", menuAnchor.menu)
                                } else {
                                    console.log("No menu to set on anchor")
                                }

                                // Set up window and anchor positioning
                                console.log("Setting up menu anchor...")
                                try {
                                    // Try different ways to get the window
                                    var window1 = mouse.QsWindow
                                    var window2 = systemTrayWidget.QsWindow
                                    var window3 = parent.parent.parent.parent.parent.parent // Navigate up to find window

                                    // Try to use the best window candidate
                                    var window = null

                                    // window2 is ProxyWindowAttached - get the actual window
                                    if (window2 && window2.window) {
                                        window = window2.window
                                        console.log("Using ProxyWindowAttached.window:", window)
                                    } else if (window1) {
                                        window = window1
                                        console.log("Using mouse window:", window)
                                    } else if (window3) {
                                        window = window3
                                        console.log("Using navigation window:", window)
                                    }

                                    if (window) {
                                        console.log("Final window properties:", Object.getOwnPropertyNames(window))
                                        menuAnchor.anchor.window = window
                                        // Get global coordinates of the mouse position
                                        var globalMousePos = systemTrayWidget.mapToGlobal(parent.parent.x + mouse.x, parent.parent.y + mouse.y)

                                        // Position menu so its bottom-left appears at mouse position
                                        // This means the menu rect should be positioned slightly above/to the right
                                        menuAnchor.anchor.rect.x = globalMousePos.x - 2
                                        menuAnchor.anchor.rect.y = globalMousePos.y - 2  
                                        menuAnchor.anchor.rect.width = 4
                                        menuAnchor.anchor.rect.height = 4

                                        console.log("Mouse pos in item:", mouse.x, mouse.y)
                                        console.log("Item pos:", parent.parent.x, parent.parent.y)
                                        console.log("Menu anchored to mouse at global:", globalMousePos.x, globalMousePos.y)
                                        console.log("Anchor window and rect set successfully")
                                    } else {
                                        console.log("No suitable window found")
                                    }
                                } catch (e) {
                                    console.log("Error setting anchor:", e)
                                }

                                try {
                                    if (menuAnchor.menu) {
                                        console.log("Calling menuAnchor.open()")
                                        menuAnchor.open()
                                    } else {
                                        console.log("MenuAnchor has no menu")
                                    }
                                } catch (e) {
                                    console.log("MenuAnchor open failed:", e)
                                }
                            } else if (mouse.button === Qt.LeftButton) {
                                // Left click - try activate
                                console.log("Attempting activate()...")
                                try {
                                    parent.parent.item.activate()
                                    console.log("✓ activate() completed")
                                } catch (e) {
                                    console.log("✗ activate() failed:", e)
                                }
                            } else if (mouse.button === Qt.RightButton) {
                                // Right click - try secondaryActivate
                                console.log("Attempting secondaryActivate()...")
                                try {
                                    parent.parent.item.secondaryActivate()
                                    console.log("✓ secondaryActivate() completed")
                                } catch (e) {
                                    console.log("✗ secondaryActivate() failed:", e)
                                }
                            }
                        }
                        console.log("=== END DEBUG ===")
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
