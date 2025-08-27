import QtQuick
import Quickshell.Io

Rectangle {
    id: cpuWidget
    height: 60
    color: "transparent"
    radius: 8

    property real cpuUsage: 0
    property var coreUsages: []  // Array to store individual core usage
    property var tooltipWindow: null  // Reference to tooltip window
    property var tempCoreData: []  // Temporary array to accumulate core data
    property var tooltipUpdateFunction: null  // Reference to tooltip update function
    property real mouseX: 0  // Store mouse X position
    property real mouseY: 0  // Store mouse Y position


    // Color module instance
    Colors {
        id: colors
    }

    // Color based on CPU usage
    property string usageColor: {
        if (cpuUsage < 25) return colors.green
        else if (cpuUsage < 50) return colors.yellow
        else if (cpuUsage < 75) return colors.peach
        else return colors.red
    }

    Column {
        anchors.centerIn: parent
        spacing: 4

        // CPU gauge
        Item {
            width: 36
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter

            // Background circle with usage color
            Rectangle {
                id: gaugeBackground
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 16
                color: cpuWidget.usageColor
                opacity: 0.3
                border.color: colors.overlay
                border.width: 1

                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }

            // Gauge ticks
            Canvas {
                id: gaugeTicks
                anchors.centerIn: parent
                width: 32
                height: 32

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var centerX = width / 2
                    var centerY = height / 2
                    var radius = 14

                    // Draw tick marks
                    ctx.strokeStyle = colors.overlay
                    ctx.lineWidth = 1

                    for (var i = 0; i <= 4; i++) {
                        var angle = Math.PI * 0.75 + (Math.PI * 1.5 * i / 4)  // 135° to 405° (270° span)
                        var innerRadius = radius - 2
                        var outerRadius = radius

                        var x1 = centerX + Math.cos(angle) * innerRadius
                        var y1 = centerY + Math.sin(angle) * innerRadius
                        var x2 = centerX + Math.cos(angle) * outerRadius
                        var y2 = centerY + Math.sin(angle) * outerRadius

                        ctx.beginPath()
                        ctx.moveTo(x1, y1)
                        ctx.lineTo(x2, y2)
                        ctx.stroke()
                    }
                }
            }

            // Dynamic colored bands with active highlighting
            Canvas {
                id: coloredBands
                anchors.centerIn: parent
                width: 32
                height: 32

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var centerX = width / 2
                    var centerY = height / 2
                    var radius = 12
                    var lineWidth = 7  // Thick colored bands
                    var totalAngle = Math.PI * 1.5  // 270 degrees total
                    var startAngle = Math.PI * 0.75  // Start at 135 degrees

                    ctx.lineWidth = lineWidth

                    // Determine which band is active based on CPU usage
                    var activeBand = 0  // 0=green, 1=yellow, 2=peach, 3=red
                    if (cpuWidget.cpuUsage >= 75) activeBand = 3
                    else if (cpuWidget.cpuUsage >= 50) activeBand = 2
                    else if (cpuWidget.cpuUsage >= 25) activeBand = 1
                    else activeBand = 0

                    // Green band (0-25%)
                    var greenStart = startAngle
                    var greenEnd = startAngle + (totalAngle * 0.25)
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, greenStart, greenEnd)
                    ctx.globalAlpha = activeBand === 0 ? 1.0 : 0.3
                    ctx.strokeStyle = colors.green
                    ctx.stroke()

                    // Yellow band (25-50%)
                    var yellowStart = greenEnd
                    var yellowEnd = startAngle + (totalAngle * 0.5)
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, yellowStart, yellowEnd)
                    ctx.globalAlpha = activeBand === 1 ? 1.0 : 0.3
                    ctx.strokeStyle = colors.yellow
                    ctx.stroke()

                    // Peach band (50-75%)
                    var peachStart = yellowEnd
                    var peachEnd = startAngle + (totalAngle * 0.75)
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, peachStart, peachEnd)
                    ctx.globalAlpha = activeBand === 2 ? 1.0 : 0.3
                    ctx.strokeStyle = colors.peach
                    ctx.stroke()

                    // Red band (75-100%)
                    var redStart = peachEnd
                    var redEnd = startAngle + totalAngle
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, redStart, redEnd)
                    ctx.globalAlpha = activeBand === 3 ? 1.0 : 0.3
                    ctx.strokeStyle = colors.red
                    ctx.stroke()

                    // Reset alpha for other drawings
                    ctx.globalAlpha = 1.0
                }
            }

            // Needle
            Canvas {
                id: needle
                anchors.centerIn: parent
                width: 32
                height: 32

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var centerX = width / 2
                    var centerY = height / 2
                    var needleLength = 8
                    var needleAngle = Math.PI * 0.75 + (Math.PI * 1.5 * cpuWidget.cpuUsage / 100)

                    var needleX = centerX + Math.cos(needleAngle) * needleLength
                    var needleY = centerY + Math.sin(needleAngle) * needleLength

                    // Draw needle with white color for visibility
                    ctx.strokeStyle = "#ffffff"
                    ctx.lineWidth = 3
                    ctx.lineCap = "round"
                    ctx.beginPath()
                    ctx.moveTo(centerX, centerY)
                    ctx.lineTo(needleX, needleY)
                    ctx.stroke()

                    // Draw center dot
                    ctx.fillStyle = "#ffffff"
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, 2.5, 0, 2 * Math.PI)
                    ctx.fill()
                }
            }

            // Circular mouse area for hover effect
            MouseArea {
                anchors.centerIn: parent
                width: 36
                height: 36
                hoverEnabled: true

                onEntered: {
                    gaugeBackground.opacity = 0.6
                    showTooltip()
                }

                onExited: {
                    gaugeBackground.opacity = 0.3
                    hideTooltip()
                }


                onClicked: {
                    clickProcess.running = true
                }

                function showTooltip() {
                    if (!cpuWidget.tooltipWindow) {
                        var component = Qt.createComponent("SimpleTooltip.qml")
                        if (component.status === Component.Ready) {
                            cpuWidget.tooltipWindow = component.createObject(null, {
                                "transientParent": cpuWidget.Window.window,
                                "fontFamily": "JetBrainsMono Nerd Font Mono",
                                "fontSize": 14,
                                "backgroundColor": colors.surface,
                                "borderColor": colors.overlay,
                                "textColor": colors.text
                            })
                        }
                    }

                    updateTooltipContent()
                    cpuWidget.tooltipUpdateFunction = updateTooltipContent
                }

                function updateTooltipContent() {
                    if (cpuWidget.tooltipWindow) {
                        var tooltip = ""
                        tooltip += "<h1>CPU Overall: " + Math.round(cpuWidget.cpuUsage) + "%</h1>"

                        if (cpuWidget.coreUsages.length > 0) {

                            // Add each core with a colored progress bar
                            for (var i = 0; i < cpuWidget.coreUsages.length; i++) {
                                var coreNum = String(i).padStart(2, '0')
                                var usage = Math.round(cpuWidget.coreUsages[i])
                                var usageStr = String(usage + "%").padStart(4, ' ')

                                // Determine color based on usage
                                var color = ""
                                if (usage < 25) color = colors.green
                                else if (usage < 50) color = colors.yellow
                                else if (usage < 75) color = colors.peach
                                else color = colors.red

                                // Create colored text bar (20 chars wide)
                                var barWidth = 20
                                var filledBars = Math.round((usage / 100) * barWidth)

                                var bar = "<span style='color: " + color + ";'>"
                                for (var j = 0; j < filledBars; j++) {
                                    bar += "█"
                                }
                                bar += "</span>"
                                for (var k = filledBars; k < barWidth; k++) {
                                    bar += "░"
                                }

                                tooltip += coreNum + "  " + bar + "  " + usageStr + "<br>"
                            }
                        } else {
                            tooltip += "Core data loading..."
                        }

                        tooltip += ""

                        if (cpuWidget.tooltipWindow.visible) {
                            // Just update text if tooltip is already visible
                            cpuWidget.tooltipWindow.updateText(tooltip)
                        } else {
                            // Show tooltip at fixed position relative to widget (right side)
                            var globalPos = mapToGlobal(40, 0)
                            cpuWidget.tooltipWindow.showAt(globalPos.x, globalPos.y, tooltip)
                        }
                    }
                }

                function hideTooltip() {
                    if (cpuWidget.tooltipWindow) {
                        cpuWidget.tooltipWindow.hide()
                    }
                    cpuWidget.tooltipUpdateFunction = null
                }
            }
        }

    }

    // Redraw gauge when CPU usage changes
    onCpuUsageChanged: {
        needle.requestPaint()
        coloredBands.requestPaint()
        if (tooltipUpdateFunction) {
            tooltipUpdateFunction()
        }
    }

    // Update tooltip when core data changes
    onCoreUsagesChanged: {
        if (tooltipUpdateFunction) {
            tooltipUpdateFunction()
        }
    }

    // Paint colored bands on component completion
    Component.onCompleted: {
        coloredBands.requestPaint()
    }

    // Overall CPU monitoring process
    Process {
        id: cpuProcess
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"]
        stdout: SplitParser {
            onRead: function(data) {
                try {
                    if (data && data.trim()) {
                        const usage = parseFloat(data.trim())
                        if (!isNaN(usage)) {
                            cpuWidget.cpuUsage = usage
                        }
                    }
                } catch (e) {
                    console.log("CpuWidget: Error parsing CPU usage:", e)
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
                        const usage = parseFloat(data.trim())
                        if (!isNaN(usage)) {
                            cpuWidget.tempCoreData.push(usage)
                        }
                    }
                } catch (e) {
                    console.log("CpuWidget: Error parsing core usage:", e)
                }
            }
        }

        onExited: {
            if (cpuWidget.tempCoreData.length > 0) {
                cpuWidget.coreUsages = cpuWidget.tempCoreData.slice()  // Copy array
                cpuWidget.tempCoreData = []  // Reset for next run
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProcess.running = true
            coreProcess.running = true
        }
    }

    // Click handler process
    Process {
        id: clickProcess
        command: [
          "kitty",
          "--class=floating-sysmon",
          "-e",
          "btop"
        ]
        stderr: SplitParser {
            onRead: function(data) {
                console.log("CpuWidget: Process stderr:", JSON.stringify(data))
            }
        }
    }
}
