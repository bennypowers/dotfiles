import QtQuick
import Quickshell.Io

Rectangle {
    id: cpuBarWidget

    // Bar appearance
    property int barHeight: 3
    property int barSpacing: 2
    property list<real> coreUsages: []
    property real cpuUsage: 0
    property real diskRead: 0
    property real diskTotal: 0
    property real diskUsage: 0
    property real diskUsed: 0
    property real diskWrite: 0
    property int maxBarWidth: 52
    property real networkDown: 0
    property real networkUp: 0
    property bool popoverVisible: false
    property int ramBarHeight: 6
    property int ramGap: 8
    property real ramTotal: 0
    property real ramUsage: 0
    property real ramUsed: 0
    property int screenWidth: 0
    property var shellRoot: null
    property list<real> tempCoreData: []
    property int updateInterval: 2000
    property string uptime: ""
    property real cpuTemp: 0
    property real cpuPower: 0
    property real gpuUsage: 0
    property real gpuVramTotal: 0
    property real gpuVramUsed: 0
    property real gpuTemp: 0
    property real gpuPower: 0
    property var gpuUsageHistory: []
    property var gpuVramHistory: []
    property var gpuTempHistory: []
    property var gpuPowerHistory: []
    property int maxHistoryPoints: 60

    color: "transparent"

    // Auto-size based on core count
    implicitHeight: {
        if (coreUsages.length === 0)
            return 60;
        var cpuBarsHeight = coreUsages.length * (barHeight + barSpacing);
        return cpuBarsHeight + ramGap + ramBarHeight + 8;
    }
    radius: 8

    Component.onCompleted: {
        console.log("🔧 CpuBarWidget loaded");
        cpuProcess.running = true;
        coreProcess.running = true;
        cpuTempProcess.running = true;
        cpuPowerProcess.running = true;
        ramProcess.running = true;
        ramDetailsProcess.running = true;
        uptimeProcess.running = true;
        diskProcess.running = true;
        diskIOProcess.running = true;
        networkProcess.running = true;
        gpuUsageProcess.running = true;
        gpuMemoryProcess.running = true;
        gpuTempProcess.running = true;
        gpuPowerProcess.running = true;
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

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutQuad
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

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent

        onClicked: {
            console.log("🖱️  CpuBarWidget clicked! Current popoverVisible:", cpuBarWidget.popoverVisible);
            cpuBarWidget.popoverVisible = !cpuBarWidget.popoverVisible;
            console.log("🖱️  CpuBarWidget new popoverVisible:", cpuBarWidget.popoverVisible);
        }
    }
    CpuStatsPopover {
        id: statsPopover

        coreUsages: cpuBarWidget.coreUsages
        cpuPower: cpuBarWidget.cpuPower
        cpuTemp: cpuBarWidget.cpuTemp
        cpuUsage: cpuBarWidget.cpuUsage
        diskRead: cpuBarWidget.diskRead
        diskTotal: cpuBarWidget.diskTotal
        diskUsage: cpuBarWidget.diskUsage
        diskUsed: cpuBarWidget.diskUsed
        diskWrite: cpuBarWidget.diskWrite
        gpuPower: cpuBarWidget.gpuPower
        gpuPowerHistory: cpuBarWidget.gpuPowerHistory
        gpuTemp: cpuBarWidget.gpuTemp
        gpuTempHistory: cpuBarWidget.gpuTempHistory
        gpuUsage: cpuBarWidget.gpuUsage
        gpuUsageHistory: cpuBarWidget.gpuUsageHistory
        gpuVramHistory: cpuBarWidget.gpuVramHistory
        gpuVramTotal: cpuBarWidget.gpuVramTotal
        gpuVramUsed: cpuBarWidget.gpuVramUsed
        networkDown: cpuBarWidget.networkDown
        networkUp: cpuBarWidget.networkUp
        ramTotal: cpuBarWidget.ramTotal
        ramUsage: cpuBarWidget.ramUsage
        ramUsed: cpuBarWidget.ramUsed
        rightPanelWidth: 80
        screenWidth: cpuBarWidget.screenWidth
        topMargin: {
            // Get the widget's position relative to the panel window
            var globalPos = cpuBarWidget.mapToItem(null, 0, 0);
            return globalPos ? globalPos.y : 0;
        }
        uptime: cpuBarWidget.uptime
        visible: cpuBarWidget.popoverVisible

        onCloseRequested: {
            console.log("🔔 CpuStatsPopover closeRequested - setting popoverVisible = false");
            cpuBarWidget.popoverVisible = false;
        }
    }

    // Overall CPU monitoring process
    Process {
        id: cpuProcess

        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"]

        stdout: SplitParser {
            onRead: function (data) {
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
            onRead: function (data) {
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

    // CPU Temperature process
    Process {
        id: cpuTempProcess

        command: ["bash", "-c", "cat /sys/class/hwmon/hwmon2/temp1_input 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const temp = parseFloat(data.trim()) / 1000; // Convert millidegrees to degrees
                        if (!isNaN(temp)) {
                            cpuBarWidget.cpuTemp = temp;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing CPU temperature:", e);
                }
            }
        }
    }

    // CPU Power process (may require permissions)
    Process {
        id: cpuPowerProcess

        command: ["bash", "-c", "cat /sys/class/powercap/intel-rapl:0/energy_uj 2>/dev/null > /tmp/cpu_energy1; sleep 0.5; cat /sys/class/powercap/intel-rapl:0/energy_uj 2>/dev/null > /tmp/cpu_energy2; awk 'NR==FNR{e1=$1;next} {e2=$1; if(e2>=e1) print (e2-e1)*2/1000000; else print 0}' /tmp/cpu_energy1 /tmp/cpu_energy2 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const power = parseFloat(data.trim());
                        if (!isNaN(power)) {
                            cpuBarWidget.cpuPower = power;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing CPU power:", e);
                }
            }
        }
    }

    // RAM monitoring process
    Process {
        id: ramProcess

        command: ["bash", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}'"]

        stdout: SplitParser {
            onRead: function (data) {
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

    // RAM details process (total, used in MB)
    Process {
        id: ramDetailsProcess

        command: ["bash", "-c", "free -m | grep Mem | awk '{print $2\" \"$3}'"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const parts = data.trim().split(" ");
                        if (parts.length === 2) {
                            cpuBarWidget.ramTotal = parseFloat(parts[0]);
                            cpuBarWidget.ramUsed = parseFloat(parts[1]);
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing RAM details:", e);
                }
            }
        }
    }

    // Uptime process
    Process {
        id: uptimeProcess

        command: ["bash", "-c", "uptime -p | sed 's/up //'"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        cpuBarWidget.uptime = data.trim();
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing uptime:", e);
                }
            }
        }
    }

    // Disk usage process (root filesystem)
    Process {
        id: diskProcess

        command: ["bash", "-c", "df -BG / | awk 'NR==2 {gsub(/G/,\"\"); print $2\" \"$3\" \"$5}' | sed 's/%//'"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const parts = data.trim().split(" ");
                        if (parts.length === 3) {
                            cpuBarWidget.diskTotal = parseFloat(parts[0]);
                            cpuBarWidget.diskUsed = parseFloat(parts[1]);
                            cpuBarWidget.diskUsage = parseFloat(parts[2]);
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing disk usage:", e);
                }
            }
        }
    }

    // Disk I/O process
    Process {
        id: diskIOProcess

        command: ["bash", "-c", "awk '{if($3~/^(sd|nvme|vd)/) {read+=$6; write+=$10}} END {print read\" \"write}' /proc/diskstats > /tmp/disk1; sleep 1; awk '{if($3~/^(sd|nvme|vd)/) {read+=$6; write+=$10}} END {print read\" \"write}' /proc/diskstats > /tmp/disk2; awk 'NR==FNR{r1=$1;w1=$2;next} {r2=$1;w2=$2; print (r2-r1)*512/1024/1024\" \"(w2-w1)*512/1024/1024}' /tmp/disk1 /tmp/disk2"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const parts = data.trim().split(" ");
                        if (parts.length === 2) {
                            cpuBarWidget.diskRead = parseFloat(parts[0]);
                            cpuBarWidget.diskWrite = parseFloat(parts[1]);
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing disk I/O:", e);
                }
            }
        }
    }

    // Network usage process
    Process {
        id: networkProcess

        command: ["bash", "-c", "cat /proc/net/dev | grep -v lo | awk 'NR>2 {rx+=$2; tx+=$10} END {print rx\" \"tx}' > /tmp/net1; sleep 1; cat /proc/net/dev | grep -v lo | awk 'NR>2 {rx+=$2; tx+=$10} END {print rx\" \"tx}' > /tmp/net2; awk 'NR==FNR{rx1=$1;tx1=$2;next} {rx2=$1;tx2=$2; print (rx2-rx1)/1024/1024\" \"(tx2-tx1)/1024/1024}' /tmp/net1 /tmp/net2"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const parts = data.trim().split(" ");
                        if (parts.length === 2) {
                            cpuBarWidget.networkDown = parseFloat(parts[0]);
                            cpuBarWidget.networkUp = parseFloat(parts[1]);
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing network usage:", e);
                }
            }
        }
    }

    // GPU Usage process
    Process {
        id: gpuUsageProcess

        command: ["bash", "-c", "cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const usage = parseFloat(data.trim());
                        if (!isNaN(usage)) {
                            cpuBarWidget.gpuUsage = usage;
                            // Update history
                            var history = cpuBarWidget.gpuUsageHistory.slice();
                            history.push(usage);
                            if (history.length > cpuBarWidget.maxHistoryPoints) {
                                history.shift();
                            }
                            cpuBarWidget.gpuUsageHistory = history;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing GPU usage:", e);
                }
            }
        }
    }

    // GPU Memory process
    Process {
        id: gpuMemoryProcess

        command: ["bash", "-c", "cat /sys/class/drm/card0/device/mem_info_vram_used /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null | awk '{sum+=$1} END {print sum}' | xargs -I {} bash -c 'echo $(cat /sys/class/drm/card0/device/mem_info_vram_used 2>/dev/null || echo 0) $(cat /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null || echo 1)'"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const parts = data.trim().split(" ");
                        if (parts.length === 2) {
                            cpuBarWidget.gpuVramUsed = parseFloat(parts[0]) / (1024 * 1024 * 1024); // Convert bytes to GB
                            cpuBarWidget.gpuVramTotal = parseFloat(parts[1]) / (1024 * 1024 * 1024); // Convert bytes to GB
                            // Update history (percentage)
                            const vramPercent = cpuBarWidget.gpuVramTotal > 0 ? (cpuBarWidget.gpuVramUsed / cpuBarWidget.gpuVramTotal) * 100 : 0;
                            var history = cpuBarWidget.gpuVramHistory.slice();
                            history.push(vramPercent);
                            if (history.length > cpuBarWidget.maxHistoryPoints) {
                                history.shift();
                            }
                            cpuBarWidget.gpuVramHistory = history;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing GPU memory:", e);
                }
            }
        }
    }

    // GPU Temperature process
    Process {
        id: gpuTempProcess

        command: ["bash", "-c", "cat /sys/class/drm/card0/device/hwmon/hwmon0/temp1_input 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const temp = parseFloat(data.trim()) / 1000; // Convert millidegrees to degrees
                        if (!isNaN(temp)) {
                            cpuBarWidget.gpuTemp = temp;
                            // Update history
                            var history = cpuBarWidget.gpuTempHistory.slice();
                            history.push(temp);
                            if (history.length > cpuBarWidget.maxHistoryPoints) {
                                history.shift();
                            }
                            cpuBarWidget.gpuTempHistory = history;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing GPU temperature:", e);
                }
            }
        }
    }

    // GPU Power process
    Process {
        id: gpuPowerProcess

        command: ["bash", "-c", "cat /sys/class/drm/card0/device/hwmon/hwmon0/power1_average 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function (data) {
                try {
                    if (data && data.trim()) {
                        const power = parseFloat(data.trim()) / 1000000; // Convert microwatts to watts
                        if (!isNaN(power)) {
                            cpuBarWidget.gpuPower = power;
                            // Update history
                            var history = cpuBarWidget.gpuPowerHistory.slice();
                            history.push(power);
                            if (history.length > cpuBarWidget.maxHistoryPoints) {
                                history.shift();
                            }
                            cpuBarWidget.gpuPowerHistory = history;
                        }
                    }
                } catch (e) {
                    console.log("CpuBarWidget: Error parsing GPU power:", e);
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
            cpuTempProcess.running = true;
            cpuPowerProcess.running = true;
            ramProcess.running = true;
            ramDetailsProcess.running = true;
            uptimeProcess.running = true;
            diskProcess.running = true;
            diskIOProcess.running = true;
            networkProcess.running = true;
            gpuUsageProcess.running = true;
            gpuMemoryProcess.running = true;
            gpuTempProcess.running = true;
            gpuPowerProcess.running = true;
        }
    }
}
