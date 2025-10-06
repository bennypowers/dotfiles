import QtQuick
import Quickshell.Wayland

WlrLayershell {
    id: popover

    property int cornerRadius: 16
    property int popoverPadding: 16
    property int popoverWidth: 380
    property int rightPanelWidth: 80
    property int screenWidth: 0
    property int sectionSpacing: 12
    property int topMargin: 0

    // Stats properties
    property real cpuUsage: 0
    property list<real> coreUsages: []
    property real ramUsage: 0
    property real ramTotal: 0
    property real ramUsed: 0
    property string uptime: ""
    property real diskUsage: 0
    property real diskTotal: 0
    property real diskUsed: 0
    property real diskRead: 0
    property real diskWrite: 0
    property real networkDown: 0
    property real networkUp: 0

    anchors {
        right: true
        top: true
    }
    color: "transparent"
    exclusiveZone: 0
    height: contentColumn.height + popoverPadding * 2
    layer: WlrLayer.Overlay
    margins {
        right: 0
        top: topMargin
    }
    namespace: "quickshell-cpu-stats"
    visible: false
    width: popoverWidth

    onVisibleChanged: {
        if (visible) {
            scalableContainer.scale = 0;
            showAnimation.start();
            topLeftInset.margins.right = popoverWidth;
            topLeftInset.margins.top = topMargin;
            bottomRightInset.margins.top = topMargin + contentColumn.height + popoverPadding * 2;
        } else {
            hideAnimation.start();
            topLeftInset.margins.right = 0;
            topLeftInset.margins.top = 0;
            bottomRightInset.margins.top = 0;
        }
    }

    Colors {
        id: colors
    }

    // Animated container for show/hide effects
    Item {
        id: scalableContainer

        anchors.fill: parent
        scale: 0
        transformOrigin: Item.TopRight

        // Background with rounded corners
        Rectangle {
            id: background

            anchors.fill: parent
            bottomLeftRadius: 16
            bottomRightRadius: 0
            color: colors.black

            layer.enabled: true
            topLeftRadius: 0
            topRightRadius: 16
        }

        // Content column
        Column {
            id: contentColumn

            anchors.left: parent.left
            anchors.leftMargin: popoverPadding
            anchors.right: parent.right
            anchors.rightMargin: popoverPadding
            anchors.top: parent.top
            anchors.topMargin: popoverPadding
            spacing: sectionSpacing

            // Header
            Text {
                color: colors.text
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
                text: "System Stats"
            }

            // Overall CPU & RAM Usage (side by side)
            Row {
                spacing: 24
                width: parent.width

                // CPU
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "CPU"
                    }

                    Text {
                        color: colors.text
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 32
                        text: `${Math.round(popover.cpuUsage)}%`
                    }
                }

                // RAM
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "MEMORY"
                    }

                    Row {
                        spacing: 12

                        Text {
                            color: colors.text
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 32
                            text: `${Math.round(popover.ramUsage)}%`
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: colors.overlay
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            text: `${(popover.ramUsed / 1024).toFixed(1)} / ${(popover.ramTotal / 1024).toFixed(1)} GB`
                        }
                    }
                }
            }

            // Per-core usage
            Column {
                spacing: 4
                width: parent.width

                Text {
                    color: colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    text: "Per-Core Usage"
                }

                Grid {
                    columns: 4
                    columnSpacing: 12
                    rowSpacing: 8

                    Repeater {
                        model: popover.coreUsages.length

                        delegate: Row {
                            required property int index

                            spacing: 4

                            Text {
                                color: colors.overlay
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                text: `${index}:`
                                width: 20
                            }

                            Text {
                                property real usage: index < popover.coreUsages.length ? popover.coreUsages[index] : 0
                                property string usageColor: {
                                    if (usage < 25)
                                        return colors.green;
                                    else if (usage < 50)
                                        return colors.yellow;
                                    else if (usage < 75)
                                        return colors.peach;
                                    else
                                        return colors.red;
                                }

                                color: usageColor
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                text: `${Math.round(usage)}%`
                                width: 35
                            }
                        }
                    }
                }
            }

            // Disk Usage & I/O
            Row {
                spacing: 24
                width: parent.width

                // Disk Usage
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "DISK (ROOT)"
                    }

                    Row {
                        spacing: 8

                        Text {
                            color: colors.text
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 20
                            text: `${Math.round(popover.diskUsage)}%`
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: colors.overlay
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            text: `${(popover.diskUsed).toFixed(0)} / ${(popover.diskTotal).toFixed(0)} GB`
                        }
                    }
                }

                // Disk I/O
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "DISK I/O"
                    }

                    Row {
                        spacing: 16

                        Row {
                            spacing: 4

                            Text {
                                color: colors.blue
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: "R"
                            }

                            Text {
                                color: colors.text
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: `${popover.diskRead.toFixed(1)} MB/s`
                            }
                        }

                        Row {
                            spacing: 4

                            Text {
                                color: colors.peach
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: "W"
                            }

                            Text {
                                color: colors.text
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: `${popover.diskWrite.toFixed(1)} MB/s`
                            }
                        }
                    }
                }
            }

            // Network & Uptime (side by side)
            Row {
                spacing: 24
                width: parent.width

                // Network
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "NETWORK"
                    }

                    Row {
                        spacing: 16

                        Row {
                            spacing: 4

                            Text {
                                color: colors.green
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: "↓"
                            }

                            Text {
                                color: colors.text
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: `${popover.networkDown.toFixed(1)} MB/s`
                            }
                        }

                        Row {
                            spacing: 4

                            Text {
                                color: colors.red
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: "↑"
                            }

                            Text {
                                color: colors.text
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                text: `${popover.networkUp.toFixed(1)} MB/s`
                            }
                        }
                    }
                }

                // Uptime
                Column {
                    spacing: 4
                    width: (parent.width - parent.spacing) / 2

                    Text {
                        color: colors.subtext
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        text: "UPTIME"
                    }

                    Text {
                        color: colors.text
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        text: popover.uptime
                    }
                }
            }
        }
    }

    // Show animation
    PropertyAnimation {
        id: showAnimation

        duration: 150
        easing.type: Easing.OutQuad
        from: 0
        properties: "scale"
        target: scalableContainer
        to: 1
    }
    // Hide animation
    PropertyAnimation {
        id: hideAnimation

        duration: 150
        easing.type: Easing.InQuad
        from: 1
        properties: "scale"
        target: scalableContainer
        to: 0
    }

    // Click outside to close
    MouseArea {
        anchors.fill: parent
        z: -1

        onClicked: {
            popover.visible = false;
        }
    }

    // Top-left corner inset
    WlrLayershell {
        id: topLeftInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-cpu-stats-corner-tl"
        visible: popover.visible
        width: cornerRadius

        anchors {
            right: true
            top: true
        }
        margins {
            right: 0
            top: 0

            Behavior on right {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }

    // Bottom-right corner inset
    WlrLayershell {
        id: bottomRightInset

        color: "transparent"
        exclusiveZone: 0
        height: cornerRadius
        layer: WlrLayer.Overlay
        namespace: "quickshell-cpu-stats-corner-br"
        visible: popover.visible
        width: cornerRadius

        anchors {
            right: true
            top: true
        }
        margins {
            right: 0
            top: 0

            Behavior on top {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
        CornerShape {
            anchors.fill: parent
            fillColor: colors.black
            radius: cornerRadius
        }
    }
}
