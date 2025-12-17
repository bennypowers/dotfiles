import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell.Io
import Quickshell.Hyprland

Column {
    id: quickSettings

    property string currentLayout: "A"
    property var languages: [
        { glyph: "A", name: "English (US)", color: colors.blue, layoutKey: "English" },
        { glyph: "א", name: "Hebrew", color: colors.green, layoutKey: "Hebrew" }
    ]
    property string mainKeyboard: "diego-palacios-cantor-keyboard"

    // Network properties
    property string connectionName: ""
    property string connectionType: ""
    property bool isConnected: false
    property bool isWifi: false
    property int wifiStrength: 0
    property string ssidName: ""
    property var availableNetworks: []

    // Bluetooth properties
    property bool bluetoothPowered: false

    // Workmode properties
    property bool viewerActive: false
    property bool vmRunning: false
    property string vmName: "silverblue"

    spacing: 8

    Component.onCompleted: {
        // Initialize checks
        hyprctlProcess.running = true
        networkProcess.running = true
        bluetoothStatusProcess.running = true
        vmStatusProcess.running = true
        statusTimer.start()
    }

    Colors {
        id: colors
    }

    // ===== LANGUAGE/KEYBOARD LOGIC =====
    function updateLayoutDisplay(layoutName) {
        if (layoutName.includes("English")) {
            currentLayout = "A"
        } else if (layoutName.includes("Hebrew")) {
            currentLayout = "א"
        } else {
            currentLayout = "??"
        }
    }

    function switchLayout() {
        switchProcess.running = true
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const [, layoutName] = event.data.split(",")
                quickSettings.updateLayoutDisplay(layoutName)
            }
        }
    }

    Process {
        id: hyprctlProcess
        command: ["/bin/bash", "-c", `hyprctl devices -j | jq -r '.keyboards[] | select(.name == "${mainKeyboard}") | .active_keymap'`]
        running: false

        stdout: SplitParser {
            onRead: function(data) {
                const layout = data.trim()
                quickSettings.updateLayoutDisplay(layout)
            }
        }
    }

    Process {
        id: switchProcess
        command: ["/bin/bash", "-c", `hyprctl switchxkblayout ${mainKeyboard} next`]
        running: false
    }

    // ===== NETWORK LOGIC =====
    property string networkIcon: {
        if (!isConnected) return "󰌙"
        if (isWifi) {
            if (wifiStrength >= 80) return "󰤨"
            else if (wifiStrength >= 60) return "󰤥"
            else if (wifiStrength >= 40) return "󰤢"
            else if (wifiStrength >= 20) return "󰤟"
            else return "󰤯"
        } else {
            return "󰈀"
        }
        return "󰌙"
    }

    Process {
        id: networkProcess
        command: ["/bin/bash", "-c", "nmcli -t -f NAME,TYPE,DEVICE,STATE connection show --active"]
        running: false

        stdout: SplitParser {
            onRead: function(data) {
                const lines = data.trim().split('\n')
                if (lines.length > 0 && lines[0]) {
                    const parts = lines[0].split(':')
                    if (parts.length >= 4) {
                        connectionName = parts[0]
                        connectionType = parts[1]
                        isConnected = parts[3] === 'activated'
                        isWifi = connectionType.includes('wireless') || connectionType.includes('wifi')

                        if (isWifi) {
                            wifiCheckProcess.running = true
                        }
                    }
                }
            }
        }

        onExited: function(exitCode) {
            networkCheckTimer.start()
        }
    }

    Process {
        id: wifiCheckProcess
        command: ["/bin/bash", "-c", "nmcli -f IN-USE,SIGNAL,SSID dev wifi | grep '^\\*' | awk '{print $2,$3}'"]
        running: false

        stdout: SplitParser {
            onRead: function(data) {
                const output = data.trim().split(' ')
                if (output.length >= 2) {
                    const strength = parseInt(output[0])
                    if (!isNaN(strength)) {
                        wifiStrength = strength
                    }
                    ssidName = output.slice(1).join(' ')
                }
            }
        }
    }

    Process {
        id: wifiListProcess
        command: ["/bin/bash", "-c", "nmcli -f SIGNAL,SSID,SECURITY dev wifi list | tail -n +2"]
        running: false

        stdout: SplitParser {
            onRead: function(data) {
                const lines = data.trim().split('\n')
                availableNetworks = lines.map(line => {
                    const match = line.trim().match(/^(\d+)\s+(.+?)\s+(.*?)$/)
                    if (match) {
                        return {
                            signal: parseInt(match[1]),
                            ssid: match[2].trim(),
                            security: match[3].trim()
                        }
                    }
                    return null
                }).filter(n => n !== null)
            }
        }
    }

    Timer {
        id: networkCheckTimer
        interval: 5000
        repeat: false
        onTriggered: { networkProcess.running = true }
    }

    // ===== BLUETOOTH LOGIC =====
    Process {
        id: bluetoothStatusProcess
        command: ["/bin/bash", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        running: false

        stdout: SplitParser {
            onRead: function(data) {
                bluetoothPowered = data.trim() === "yes"
            }
        }

        onExited: function(exitCode) {
            bluetoothCheckTimer.start()
        }
    }

    Process {
        id: bluetoothToggleProcess
        command: ["/bin/bash", "-c", bluetoothPowered ? "bluetoothctl power off" : "bluetoothctl power on"]
        running: false

        onExited: function(exitCode) {
            // Refresh status after toggle
            Qt.callLater(function() {
                bluetoothStatusProcess.running = true
            })
        }
    }

    Process {
        id: overskrideLaunchProcess
        command: ["/bin/bash", "-c", "flatpak run io.github.kaii_lb.Overskride &"]
        running: false
    }

    Timer {
        id: bluetoothCheckTimer
        interval: 5000
        repeat: false
        onTriggered: { bluetoothStatusProcess.running = true }
    }

    // ===== WORKMODE LOGIC =====
    Process {
        id: vmStatusProcess
        command: ["virsh", "domstate", quickSettings.vmName]

        stdout: SplitParser {
            onRead: function(data) {
                if (data && data.trim()) {
                    const state = data.trim()
                    quickSettings.vmRunning = (state === "running")
                    viewerCheckProcess.running = true
                }
            }
        }
    }

    Process {
        id: viewerCheckProcess
        command: ["pgrep", "-f", "virt-viewer"]

        stdout: SplitParser {
            onRead: function(data) {
                const wasViewerActive = quickSettings.viewerActive
                quickSettings.viewerActive = data && data.trim().length > 0

                if (wasViewerActive && !quickSettings.viewerActive && quickSettings.vmRunning) {
                    vmSuspendProcess.running = true
                }
            }
        }

        onExited: function(exitCode) {
            const wasViewerActive = quickSettings.viewerActive
            if (exitCode === 1) {
                quickSettings.viewerActive = false
            }

            if (wasViewerActive && !quickSettings.viewerActive && quickSettings.vmRunning) {
                vmSuspendProcess.running = true
            }
        }
    }

    Timer {
        id: statusTimer
        interval: 5000
        repeat: true
        running: false
        onTriggered: vmStatusProcess.running = true
    }

    Process {
        id: vmSuspendProcess
        command: ["virsh", "suspend", quickSettings.vmName]
        onExited: { killViewerProcess.running = true }
    }

    Process {
        id: vmStartProcess
        command: ["bash", "-c", "state=$(virsh domstate " + quickSettings.vmName + "); if [ \"$state\" = \"shut off\" ]; then virsh start " + quickSettings.vmName + "; elif [ \"$state\" = \"paused\" ]; then virsh resume " + quickSettings.vmName + "; fi"]
        onExited: { launchViewerProcess.running = true }
    }

    Process {
        id: killViewerProcess
        command: ["pkill", "-f", "virt-viewer"]
        onExited: { vmStatusProcess.running = true }
    }

    Process {
        id: launchViewerProcess
        command: ["setsid", "-f", "/home/bennyp/.config/quickshell/launch-virt-viewer.sh", quickSettings.vmName, "workmode", "2", "1"]
        onExited: function(exitCode) { vmStatusProcess.running = true }
    }

    // ===== UI: 3-COLUMN GRID =====
    GridLayout {
        width: parent.width
        columns: 3
        columnSpacing: 8
        rowSpacing: 8

        // Keyboard/Language button
        QuickSettingButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            icon: currentLayout === "A" ? "A" : "א"
            iconColor: currentLayout === "A" ? colors.blue : colors.green
            secondaryIcon: "󰌌"
            active: true
            hasSecondary: true

            onPrimaryClicked: {
                console.log("Language primary clicked")
                quickSettings.switchLayout()
            }

            onSecondaryClicked: {
                console.log("Language secondary clicked")
                languageMenu.popup()
            }
        }

        // Network button
        QuickSettingButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            icon: networkIcon
            iconColor: isConnected ? colors.text : colors.overlay
            secondaryIcon: "󰅂"
            active: isConnected
            hasSecondary: true

            onPrimaryClicked: {
                console.log("Network primary clicked, isConnected:", isConnected)
                if (isConnected) {
                    disconnectProcess.running = true
                } else {
                    reconnectProcess.running = true
                }
            }

            onSecondaryClicked: {
                console.log("Network secondary clicked")
                wifiListProcess.running = true
                Qt.callLater(function() {
                    wifiMenu.popup()
                })
            }
        }

        // Bluetooth button
        QuickSettingButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            icon: bluetoothPowered ? "󰂯" : "󰂲"
            iconColor: bluetoothPowered ? colors.blue : colors.overlay
            secondaryIcon: "󰅂"
            active: bluetoothPowered
            hasSecondary: true

            onPrimaryClicked: {
                console.log("Bluetooth primary clicked, powered:", bluetoothPowered)
                bluetoothToggleProcess.running = true
            }

            onSecondaryClicked: {
                console.log("Bluetooth secondary clicked")
                overskrideLaunchProcess.running = true
            }
        }

        // Workmode button
        QuickSettingButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            icon: (vmRunning && viewerActive) ? "󰃖" : "󰠔"
            iconColor: (vmRunning && viewerActive) ? colors.green : colors.overlay
            secondaryIcon: ""
            active: vmRunning && viewerActive
            hasSecondary: false

            onPrimaryClicked: {
                console.log("Workmode clicked, vmRunning:", vmRunning, "viewerActive:", viewerActive)
                if (vmRunning && viewerActive) {
                    vmSuspendProcess.running = true
                } else {
                    vmStartProcess.running = true
                }
            }
        }
    }

    // Language selection menu
    QQC.Menu {
        id: languageMenu

        QQC.MenuItem {
            text: "🇺🇸 English (US)"
            onTriggered: {
                // Switch to English if not already
                if (currentLayout !== "A") {
                    switchProcess.running = true
                }
            }
        }

        QQC.MenuItem {
            text: "🇮🇱 Hebrew"
            onTriggered: {
                // Switch to Hebrew if not already
                if (currentLayout !== "א") {
                    switchProcess.running = true
                }
            }
        }
    }

    // WiFi network selection menu
    QQC.Menu {
        id: wifiMenu

        Instantiator {
            model: availableNetworks
            delegate: QQC.MenuItem {
                text: modelData.ssid + " (" + modelData.signal + "%) " + (modelData.security ? "🔒" : "")
                onTriggered: {
                    connectToWifiProcess.command = ["/bin/bash", "-c", "nmcli dev wifi connect '" + modelData.ssid + "'"]
                    connectToWifiProcess.running = true
                }
            }
            onObjectAdded: (index, object) => wifiMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => wifiMenu.removeItem(object)
        }
    }

    Process {
        id: connectToWifiProcess
        command: []
        running: false
        onExited: {
            networkProcess.running = true
        }
    }

    Process {
        id: disconnectProcess
        command: ["/bin/bash", "-c", "nmcli networking off"]
        running: false
        onExited: { networkProcess.running = true }
    }

    Process {
        id: reconnectProcess
        command: ["/bin/bash", "-c", "nmcli networking on"]
        running: false
        onExited: { networkProcess.running = true }
    }

    // Component for individual quick setting buttons
    component QuickSettingButton: Rectangle {
        id: button

        property string icon: ""
        property color iconColor: colors.text
        property string secondaryIcon: ""
        property bool active: false
        property bool hasSecondary: false

        signal primaryClicked()
        signal secondaryClicked()

        radius: 12
        color: button.active ? colors.surface : colors.mantle

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        // Main content area
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 4

            // Main icon
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                color: button.iconColor
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 32
                text: button.icon
                verticalAlignment: Text.AlignVCenter
            }

            // Secondary action icon (bottom right corner)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 20

                Text {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: secondaryMouseArea.containsMouse ? colors.text : colors.subtext
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    text: button.secondaryIcon
                    visible: button.hasSecondary

                    Rectangle {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        radius: 6
                        color: secondaryMouseArea.containsMouse ? colors.overlay : "transparent"
                        z: -1

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        id: secondaryMouseArea
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        hoverEnabled: true

                        onClicked: function(mouse) {
                            console.log("Secondary MouseArea clicked")
                            mouse.accepted = true
                            button.secondaryClicked()
                        }
                    }
                }
            }
        }

        // Main button click area
        MouseArea {
            id: mainMouseArea
            anchors.fill: parent
            anchors.bottomMargin: button.hasSecondary ? 28 : 0
            anchors.rightMargin: button.hasSecondary ? 28 : 0
            hoverEnabled: true

            onClicked: function(mouse) {
                console.log("Primary MouseArea clicked")
                button.primaryClicked()
            }
        }
    }
}
