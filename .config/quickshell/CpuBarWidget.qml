import QtQuick
import Quickshell.Io

Rectangle {
    id: cpuBarWidget

    property var shellRoot: null
    property real cpuUsage: 0
    property list<real> coreUsages: []
    property list<real> tempCoreData: []
    property real ramUsage: 0
    property int updateInterval: 2000

    // Bar appearance
    property int barHeight: 3
    property int barSpacing: 2
    property int ramBarHeight: 6
    property int ramGap: 8
    property int maxBarWidth: 52

    color: "transparent"
    radius: 8

    // Auto-size based on core count
    implicitHeight: {
        if (coreUsages.length === 0) return 60;
        var cpuBarsHeight = coreUsages.length * (barHeight + barSpacing);
        return cpuBarsHeight + ramGap + ramBarHeight + 8;
    }

    Component.onCompleted: {
        console.log("🔧 CpuBarWidget loaded");
        cpuProcess.running = true;
        coreProcess.running = true;
        ramProcess.running = true;
    }

    Colors {
        id: colors
    }

    Column {
        anchors.centerIn: parent
        spacing: 0
        width: maxBarWidth

        // CPU bars
        Column {
            spacing: barSpacing
            width: maxBarWidth

            Repeater {
                model: cpuBarWidget.coreUsages.length

                delegate: Item {
                    required property int index

                    height: barHeight
                    width: maxBarWidth

                    // Background bar
                    Rectangle {
                        anchors.fill: parent
                        border.color: colors.overlay
                        border.width: 1
                        color: "transparent"
                        opacity: 0.3
                        radius: 1
                    }

                    // Usage bar
                    Rectangle {
                        property real usage: index < cpuBarWidget.coreUsages.length ? cpuBarWidget.coreUsages[index] : 0
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

                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.verticalCenter: parent.verticalCenter
                        color: usageColor
                        height: barHeight - 2
                        radius: 1
                        width: Math.max(2, (maxBarWidth - 2) * (usage / 100))

                        Behavior on width {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutQuad
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                }
            }
        }

        // Gap before RAM bar
        Item {
            height: ramGap
            width: maxBarWidth
        }

        // RAM bar
        Item {
            height: ramBarHeight
            width: maxBarWidth

            // Background bar
            Rectangle {
                anchors.fill: parent
                border.color: colors.overlay
                border.width: 1
                color: "transparent"
                opacity: 0.3
                radius: 2
            }

            // Usage bar
            Rectangle {
                property string ramColor: {
                    if (ramUsage < 25)
                        return colors.green;
                    else if (ramUsage < 50)
                        return colors.yellow;
                    else if (ramUsage < 75)
                        return colors.peach;
                    else
                        return colors.red;
                }

                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.verticalCenter: parent.verticalCenter
                color: ramColor
                height: ramBarHeight - 2
                radius: 2
                width: Math.max(2, (maxBarWidth - 2) * (ramUsage / 100))

                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        property bool hovered: false

        function createTooltipContent() {
            var component = Qt.createComponent('CpuTooltipContent.qml');
            if (component.status === Component.Ready) {
                var tooltipContent = component.createObject(tooltip.contentContainer, {
                    cpuUsage: cpuBarWidget.cpuUsage,
                    coreUsages: cpuBarWidget.coreUsages,
                    colors: colors,
                    fontFamily: tooltip.fontFamily,
                    fontSize: tooltip.fontSize,
                    textColor: tooltip.textColor
                });

                if (tooltipContent) {
                    tooltipContent.cpuUsage = Qt.binding(function() {
                        return cpuBarWidget.cpuUsage;
                    });
                    tooltipContent.coreUsages = Qt.binding(function() {
                        return cpuBarWidget.coreUsages;
                    });

                    tooltip.contentItem = tooltipContent;
                }
            }
        }
        function hideTooltip() {
            tooltip.hide();
        }
        function showTooltip() {
            if (!tooltip.visible) {
                createTooltipContent();
                tooltip.showForWidget(mouseArea);
            }
        }

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            clickProcess.running = true;
        }
        onEntered: {
            hovered = true;
            showTooltip();
        }
        onExited: {
            hovered = false;
            hideTooltip();
        }

        Tooltip {
            id: tooltip

            onVisibleChanged: {
                if (cpuBarWidget.shellRoot) {
                    if (visible) {
                        cpuBarWidget.shellRoot.registerTooltip(this);
                    } else {
                        cpuBarWidget.shellRoot.unregisterTooltip(this);
                    }
                }
            }
        }
    }

    // Overall CPU monitoring process
    Process {
        id: cpuProcess

        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"]

        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const usage = parseFloat(data.trim());
                        if (!isNaN(usage)) {
                            cpuBarWidget.cpuUsage = usage;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing CPU usage:", e);
                }
            }
        }
    }

    // Per-core CPU monitoring process
    Process {
        id: coreProcess

        command: ["bash", "-c", "grep '^cpu[0-9]' /proc/stat > /tmp/cpu1; sleep 1; grep '^cpu[0-9]' /proc/stat > /tmp/cpu2; awk 'NR==FNR{a[NR]=$0; next} {split(a[FNR], old); split($0, new); user_diff = new[2] - old[2]; nice_diff = new[3] - old[3]; sys_diff = new[4] - old[4]; idle_diff = new[5] - old[5]; total_diff = user_diff + nice_diff + sys_diff + idle_diff; cpu_usage = (total_diff - idle_diff) * 100 / total_diff; printf \"%.1f\\n\", cpu_usage}' /tmp/cpu1 /tmp/cpu2"]

        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const usage = parseFloat(data.trim());
                        if (!isNaN(usage)) {
                            cpuBarWidget.tempCoreData.push(usage);
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing core usage:", e);
                }
            }
        }

        onExited: {
            if (cpuBarWidget.tempCoreData.length > 0) {
                cpuBarWidget.coreUsages = cpuBarWidget.tempCoreData.slice();
                cpuBarWidget.tempCoreData = [];
            }
        }
    }

    // RAM monitoring process
    Process {
        id: ramProcess

        command: ["bash", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}'"]

        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const usage = parseFloat(data.trim());
                        if (!isNaN(usage)) {
                            cpuBarWidget.ramUsage = usage;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing RAM usage:", e);
                }
            }
        }
    }

    Timer {
        interval: cpuBarWidget.updateInterval
        repeat: true
        running: true

        onTriggered: {
            cpuProcess.running = true;
            coreProcess.running = true;
            ramProcess.running = true;
        }
    }

    // Click handler process
    Process {
        id: clickProcess

        command: ["kitty", "--class=floating-sysmon", "-e", "btop"]
    }
}
