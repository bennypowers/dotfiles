import QtQuick

Rectangle {
    id: baseWidget

    // Common properties that all widgets need
    property var shellRoot: null
    
    // Function to find the shell root by traversing up and looking globally
    function findShellRoot() {
        // First try traversing parents
        var currentParent = parent;
        var depth = 0;
        while (currentParent && depth < 10) {
            console.log("🏗️ Checking parent", depth, ":", currentParent.toString(), "objectName:", currentParent.objectName || "none");
            if (currentParent.objectName === "shellRoot" || 
                currentParent.toString().indexOf("ShellRoot") !== -1 ||
                (currentParent.registerTooltip && typeof currentParent.registerTooltip === "function")) {
                console.log("🏗️ BaseWidget found shellRoot via parent:", !!currentParent);
                return currentParent;
            }
            currentParent = currentParent.parent;
            depth++;
        }
        
        // If parent traversal fails, try to find it globally via root application object
        try {
            var appWindow = Qt.application;
            if (appWindow && appWindow.windows) {
                for (var i = 0; i < appWindow.windows.length; i++) {
                    var window = appWindow.windows[i];
                    if (window && window.contentItem) {
                        var content = window.contentItem;
                        // Look for children with shellRoot properties
                        if (content.children) {
                            for (var j = 0; j < content.children.length; j++) {
                                var child = content.children[j];
                                if (child && (child.registerTooltip && typeof child.registerTooltip === "function")) {
                                    console.log("🏗️ BaseWidget found shellRoot globally:", !!child);
                                    return child;
                                }
                            }
                        }
                    }
                }
            }
        } catch (e) {
            console.log("🏗️ Error in global search:", e);
        }
        
        console.log("🏗️ BaseWidget could not find shellRoot after checking", depth, "parents and global search");
        return null;
    }
    
    // Debug shellRoot property
    Component.onCompleted: {
        // First try the global reference
        if (Qt.application && Qt.application.globalShellRoot) {
            shellRoot = Qt.application.globalShellRoot;
            console.log("🏗️ BaseWidget found shellRoot via global reference:", !!shellRoot);
        } else {
            // Fallback to traversal method
            shellRoot = findShellRoot();
            console.log("🏗️ BaseWidget completed via traversal, shellRoot:", !!shellRoot);
            
            // If still no shellRoot, try to set it later when it becomes available
            if (!shellRoot) {
                checkLaterTimer.start();
            }
        }
    }
    
    // Timer to check for shellRoot later if not found initially
    Timer {
        id: checkLaterTimer
        interval: 100
        repeat: true
        running: false
        
        onTriggered: {
            if (Qt.application && Qt.application.globalShellRoot && !shellRoot) {
                shellRoot = Qt.application.globalShellRoot;
                console.log("🏗️ BaseWidget found shellRoot via delayed check:", !!shellRoot);
                stop();
            }
        }
    }

    // Common color and styling properties
    property int colorAnimationDuration: 150
    property int iconSize: 26
    property string fontFamily: "JetBrainsMono Nerd Font"

    // Default styling
    color: "transparent"
    radius: 8

    // Colors instance - available to all child widgets
    Colors {
        id: colors
    }

    // Smart anchor utility - available to all child widgets
    SmartAnchor {
        id: smartAnchor
    }

    // Base tooltip that child widgets can override or use directly
    property alias tooltip: baseTooltip
    Tooltip {
        id: baseTooltip
    }
}