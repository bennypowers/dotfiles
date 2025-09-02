import QtQuick
import Quickshell

// Smart anchor calculation utility for popouts
QtObject {
    id: smartAnchor

    // Calculate optimal anchor position based on widget position and available screen space
    function calculateAnchor(widget, popupWidth, popupHeight) {
        if (!widget) {
            return { x: 100, y: 100, anchorCorner: "bottomRight" }
        }

        // Try different ways to get window and screen info
        var window = null
        var screen = null
        
        // Try multiple approaches to get window reference
        if (widget.Window && widget.Window.window) {
            window = widget.Window.window
        } else if (widget.QsWindow && widget.QsWindow.window) {
            window = widget.QsWindow.window
        } else if (widget.QsWindow) {
            window = widget.QsWindow
        } else {
            // Walk up the parent tree to find a window
            var parent = widget.parent
            var depth = 0
            while (parent && !window && depth < 10) {
                if (parent.Window && parent.Window.window) {
                    window = parent.Window.window
                    break
                } else if (parent.QsWindow && parent.QsWindow.window) {
                    window = parent.QsWindow.window
                    break
                } else if (parent.QsWindow) {
                    window = parent.QsWindow
                    break
                }
                parent = parent.parent
                depth++
            }
        }
        
        if (window) {
            if (window.screen) {
                screen = window.screen
            } else if (window.parentScreen) {
                screen = window.parentScreen
            } else {
                // Try to get screen from Quickshell.screens
                try {
                    if (typeof Quickshell !== 'undefined' && Quickshell.screens && Quickshell.screens.length > 0) {
                        screen = Quickshell.screens[0] // Use primary screen as fallback
                    }
                } catch (e) {
                    // Silently handle error
                }
            }
        }
        
        if (!window || !screen) {
            // Fallback to simple positioning
            var fallbackPos = widget.mapToGlobal(widget.width + 10, 0)
            return { x: fallbackPos.x, y: fallbackPos.y, anchorCorner: "topLeft" }
        }

        var widgetGlobalPos = widget.mapToGlobal(0, 0)
        var panelWindow = window
        
        // Get screen dimensions
        var screenWidth = screen.width
        var screenHeight = screen.height
        
        // Get widget dimensions and position
        var widgetX = widgetGlobalPos.x
        var widgetY = widgetGlobalPos.y
        var widgetWidth = widget.width
        var widgetHeight = widget.height
        
        // Calculate available space in each direction
        var spaceRight = screenWidth - (widgetX + widgetWidth)
        var spaceLeft = widgetX
        var spaceBelow = screenHeight - (widgetY + widgetHeight)
        var spaceAbove = widgetY
        
        var anchorX, anchorY
        
        // Horizontal positioning - prefer left side when panel is on right
        if (spaceLeft >= popupWidth + 10) {
            anchorX = widgetX - popupWidth - 5
        } else if (spaceRight >= popupWidth + 10) {
            anchorX = widgetX + widgetWidth + 5
        } else {
            // Center horizontally if no space on sides
            anchorX = Math.max(5, Math.min(screenWidth - popupWidth - 5, widgetX + widgetWidth / 2 - popupWidth / 2))
        }
        
        // Vertical positioning - prefer below widget
        if (spaceBelow >= popupHeight + 10) {
            anchorY = widgetY + widgetHeight + 5
        } else if (spaceAbove >= popupHeight + 10) {
            anchorY = widgetY - popupHeight - 5
        } else {
            // Center vertically if no space above/below
            anchorY = Math.max(5, Math.min(screenHeight - popupHeight - 5, widgetY + widgetHeight / 2 - popupHeight / 2))
        }
        
        // Ensure bounds
        anchorX = Math.max(0, Math.min(screenWidth - popupWidth, anchorX))
        anchorY = Math.max(0, Math.min(screenHeight - popupHeight, anchorY))
        
        return {
            x: anchorX,
            y: anchorY,
            anchorCorner: "topLeft",
            spaceRight: spaceRight,
            spaceLeft: spaceLeft,
            spaceBelow: spaceBelow,
            spaceAbove: spaceAbove
        }
    }
    
    // Simplified version for tooltips (smaller popups)
    function calculateTooltipPosition(widget, tooltipWidth, tooltipHeight) {
        if (!tooltipWidth) tooltipWidth = 200  // Default width
        if (!tooltipHeight) tooltipHeight = 100  // Default height
        
        return calculateAnchor(widget, tooltipWidth, tooltipHeight)
    }
    
    // Debug information for the anchor calculation
    function getDebugInfo(widget) {
        if (!widget || !widget.Window || !widget.Window.window || !widget.Window.window.screen) {
            return "No screen information available"
        }
        
        var screen = widget.Window.window.screen
        var widgetGlobalPos = widget.mapToGlobal(0, 0)
        var panelWindow = widget.Window.window
        
        return "Screen: " + screen.width + "x" + screen.height + 
               ", Widget: " + widgetGlobalPos.x + "," + widgetGlobalPos.y + 
               ", Panel: " + panelWindow.x + "," + panelWindow.y + " " + panelWindow.width + "x" + panelWindow.height
    }
}