import QtQuick
import Quickshell.Io

BasePopover {
    id: popover

    property var candleLightingTimes: ({})  // Map of date -> time string

    // Date/time properties
    property var currentDate: new Date()
    property var gregorianHolidayDays: ({})  // Map of Gregorian day number -> holiday name
    property int hebrewFirstDayOfWeek: 0
    property var hebrewHolidayDays: ({})  // Map of Hebrew day number -> holiday name
    property var hebrewHolidays: ({})  // Map of Gregorian date -> holiday name
    property int hebrewMonthLength: 30

    // Hebrew calendar properties
    property string hebrewMonthName: ""
    property int hebrewToday: 1
    property string hebrewYear: ""
    property int sectionSpacing: 12

    // Helper function to convert numbers to Hebrew numerals
    function convertToHebrewNumeral(num) {
        var ones = ["", "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט"];
        var tens = ["", "י", "כ", "ל"];

        if (num < 1 || num > 30)
            return num.toString();

        var tensDigit = Math.floor(num / 10);
        var onesDigit = num % 10;

        var result = tens[tensDigit] + ones[onesDigit];

        // Add geresh or gershayim
        if (result.length === 1) {
            result += "׳";
        } else if (result.length > 1) {
            result = result.slice(0, -1) + "״" + result.slice(-1);
        }

        return result;
    }
    function getGregorianHoliday(day) {
        return gregorianHolidayDays[day] || "";
    }

    // Helper functions for holiday lookups
    function getHebrewHoliday(day) {
        return hebrewHolidayDays[day] || "";
    }

    // Helper function to parse Hebrew numbers
    function parseHebrewNumber(hebrewStr) {
        var hebrewNumbers = {
            "א": 1,
            "ב": 2,
            "ג": 3,
            "ד": 4,
            "ה": 5,
            "ו": 6,
            "ז": 7,
            "ח": 8,
            "ט": 9,
            "י": 10,
            "כ": 20,
            "ל": 30,
            "׳": 0,
            "״": 0
        };

        var result = 0;
        for (var i = 0; i < hebrewStr.length; i++) {
            var ch = hebrewStr[i];
            if (hebrewNumbers[ch] !== undefined) {
                result += hebrewNumbers[ch];
            }
        }
        return result > 0 ? result : 1;
    }

    anchorSide: "left"
    cornerPositions: ["topLeft", "topRight"]
    namespace: "quickshell-clock-popover"
    popoverWidth: 760
    transformOrigin: Item.Top

    onVisibleChanged: {
        if (visible) {
            // Update current date when showing
            currentDate = new Date();
            console.log("🔔 ClockPopover visible, starting Hebrew calendar fetch");
            hebrewCalendarProcess.running = true;
        }
    }

    // Process to fetch Hebrew calendar data
    Process {
        id: hebrewCalendarProcess

        property string accumulatedData: ""

        function processCalendarData(fullData) {
            var lines = fullData.trim().split('\n');
            var holidays = {};
            var candleTimes = {};
            var hebrewDays = {};

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i];
                var parts = line.split(' ');

                if (parts.length < 2)
                    continue;

                var gregorianDate = parts[0];  // e.g., "10/9/2025"
                var rest = parts.slice(1).join(' ');

                // Check if this is a Hebrew date line
                if (rest.includes('תשרי') || rest.includes('חשון') || rest.includes('כסלו') || rest.includes('טבת') || rest.includes('שבט') || rest.includes('אדר') || rest.includes('ניסן') || rest.includes('אייר') || rest.includes('סיון') || rest.includes('תמוז') || rest.includes('אב') || rest.includes('אלול')) {

                    // Extract Hebrew day and month
                    var hebrewParts = rest.split(' ');
                    if (hebrewParts.length >= 3) {
                        var hebrewDay = hebrewParts[0];  // e.g., "י״ז"
                        var hebrewMonth = hebrewParts[1];  // e.g., "תשרי"
                        var hebrewYr = hebrewParts[2];  // e.g., "תשפ״ו"

                        hebrewDays[gregorianDate] = {
                            day: hebrewDay,
                            month: hebrewMonth,
                            year: hebrewYr
                        };
                    }
                } else
                // Check if this is a holiday
                if (!rest.includes('הדלקת נרות') && !rest.includes('הבדלה')) {
                    holidays[gregorianDate] = rest;
                } else
                // Check if this is candle lighting time
                if (rest.includes('הדלקת נרות')) {
                    var time = rest.split(':')[1];
                    if (time) {
                        candleTimes[gregorianDate] = rest;
                    }
                }
            }

            // Find today's Hebrew date to extract current month info
            var today = Qt.formatDate(popover.currentDate, "M/d/yyyy");
            if (hebrewDays[today]) {
                popover.hebrewMonthName = hebrewDays[today].month;
                popover.hebrewYear = hebrewDays[today].year;

                // Extract Hebrew day number
                var hebrewDayStr = hebrewDays[today].day;
                popover.hebrewToday = parseHebrewNumber(hebrewDayStr);
            }

            popover.hebrewHolidays = holidays;
            popover.candleLightingTimes = candleTimes;

            // Build map of Gregorian days with holidays in current month
            var gregHolidayDays = {};
            for (var dateKey in holidays) {
                var parts = dateKey.split('/');
                if (parts.length === 3) {
                    var month = parseInt(parts[0]);
                    var day = parseInt(parts[1]);
                    if (month === popover.currentDate.getMonth() + 1) {
                        gregHolidayDays[day] = holidays[dateKey];
                    }
                }
            }
            popover.gregorianHolidayDays = gregHolidayDays;

            var gregHolidayCount = 0;
            for (var key in gregHolidayDays) {
                gregHolidayCount++;
                console.log("📅 Gregorian holiday day", key, ":", gregHolidayDays[key]);
            }

            console.log("📅 Found Hebrew month:", popover.hebrewMonthName, popover.hebrewYear, "Today:", popover.hebrewToday);
            console.log("📅 Gregorian holiday count:", gregHolidayCount);
            console.log("📅 Starting hebrewMonthProcess for month:", popover.hebrewMonthName);

            // Now get the full Hebrew month to determine its length and start day
            hebrewMonthProcess.running = true;
        }

        // Get current Hebrew month with all dates and candle lighting times
        command: ["bash", "-c", "MONTH=$(date +%m); YEAR=$(date +%Y); hebcal --lang=he-x-NoNikud -c -C Jerusalem -d $MONTH $YEAR"]

        stdout: SplitParser {
            onRead: function (data) {
                if (!data || !data.trim())
                    return;

                // Accumulate data since SplitParser gives us one line at a time
                hebrewCalendarProcess.accumulatedData += data + "\n";
            }
        }

        onRunningChanged: {
            if (!running && accumulatedData) {
                console.log("📅 Processing accumulated calendar data");
                processCalendarData(accumulatedData);
                accumulatedData = "";
            }
        }
    }

    // Process to get full Hebrew month details
    Process {
        id: hebrewMonthProcess

        property string accumulatedData: ""

        function processHebrewMonthData(fullData) {
            var lines = fullData.trim().split('\n');
            var hebrewDates = [];
            var firstGregorianDate = "";
            var hebrewHolidayDays = {};

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i];
                var parts = line.split(' ');

                if (parts.length < 2)
                    continue;

                var gregorianDate = parts[0];
                var rest = parts.slice(1).join(' ');

                // Check if this line contains the Hebrew date
                if (rest.includes(popover.hebrewMonthName)) {
                    var hebrewParts = rest.split(' ');
                    if (hebrewParts.length >= 2) {
                        var hebrewDay = hebrewParts[0];
                        var hebrewDayNum = parseHebrewNumber(hebrewDay);
                        hebrewDates.push({
                            gregorianDate: gregorianDate,
                            hebrewDay: hebrewDay,
                            hebrewDayNum: hebrewDayNum
                        });

                        // Check if this date has a holiday
                        if (popover.hebrewHolidays[gregorianDate]) {
                            hebrewHolidayDays[hebrewDayNum] = popover.hebrewHolidays[gregorianDate];
                        }

                        if (hebrewDay === "א׳") {
                            firstGregorianDate = gregorianDate;
                        }
                    }
                }
            }

            // Set month length
            popover.hebrewMonthLength = hebrewDates.length;
            popover.hebrewHolidayDays = hebrewHolidayDays;

            var hebrewHolidayCount = 0;
            for (var key in hebrewHolidayDays) {
                hebrewHolidayCount++;
                console.log("📅 Hebrew holiday day", key, ":", hebrewHolidayDays[key]);
            }

            // Calculate first day of week
            if (firstGregorianDate) {
                var dateParts = firstGregorianDate.split('/');
                if (dateParts.length === 3) {
                    var firstDate = new Date(parseInt(dateParts[2]), parseInt(dateParts[0]) - 1, parseInt(dateParts[1]));
                    popover.hebrewFirstDayOfWeek = firstDate.getDay();
                }
            }

            console.log("📅 Hebrew calendar calculated - Length:", popover.hebrewMonthLength, "First day:", popover.hebrewFirstDayOfWeek, "Hebrew holiday count:", hebrewHolidayCount);
        }

        command: ["bash", "-c", "hebcal --lang=he-x-NoNikud -H -d " + popover.hebrewMonthName + " 5786"]

        stdout: SplitParser {
            onRead: function (data) {
                if (!data || !data.trim())
                    return;

                // Accumulate data since SplitParser gives us one line at a time
                hebrewMonthProcess.accumulatedData += data + "\n";
            }
        }

        onRunningChanged: {
            if (!running && accumulatedData) {
                console.log("📅 Processing accumulated Hebrew month data");
                processHebrewMonthData(accumulatedData);
                accumulatedData = "";
            }
        }
    }
    Column {
        id: contentColumn

        spacing: sectionSpacing
        width: parent.width

        // Current date/time header
        Column {
            spacing: 4
            width: parent.width

            Text {
                color: colors.text
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                text: Qt.formatDate(popover.currentDate, "dddd")
            }
            Text {
                color: colors.subtext
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                text: Qt.formatDate(popover.currentDate, "MMMM d, yyyy")
            }
        }

        // Two calendars side by side
        Row {
            spacing: 16
            width: parent.width

            HebrewCalendar {
                colors: popover.colors
                firstDayOfWeek: popover.hebrewFirstDayOfWeek
                getHoliday: popover.getHebrewHoliday
                monthLength: popover.hebrewMonthLength
                monthName: popover.hebrewMonthName
                today: popover.hebrewToday
                width: (parent.width - parent.spacing) / 2
                year: popover.hebrewYear
            }
            GregorianCalendar {
                colors: popover.colors
                currentDate: popover.currentDate
                getHoliday: popover.getGregorianHoliday
                width: (parent.width - parent.spacing) / 2
            }
        }

        // Candle lighting times section
        Column {
            spacing: 4
            visible: candleTimesRepeater.model.length > 0
            width: parent.width

            Text {
                color: colors.subtext
                font.family: "Deja Vu Serif"
                font.pixelSize: 14
                text: "זמני נרות והבדלה (ירושלים)"
            }
            Repeater {
                id: candleTimesRepeater

                model: {
                    // Convert candleLightingTimes object to array for the next 7 days
                    var times = [];
                    var today = new Date(popover.currentDate);

                    for (var i = 0; i < 7; i++) {
                        var checkDate = new Date(today);
                        checkDate.setDate(today.getDate() + i);
                        var dateKey = (checkDate.getMonth() + 1) + "/" + checkDate.getDate() + "/" + checkDate.getFullYear();

                        if (popover.candleLightingTimes[dateKey]) {
                            times.push({
                                date: Qt.formatDate(checkDate, "dddd, MMM d"),
                                time: popover.candleLightingTimes[dateKey]
                            });
                        }
                    }
                    return times;
                }

                delegate: Row {
                    required property var modelData

                    spacing: 8
                    width: parent ? parent.width : 0

                    Text {
                        color: colors.text
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        text: modelData.date
                        width: parent.width * 0.5
                    }
                    Text {
                        color: colors.blue
                        font.family: "Deja Vu Serif"
                        font.pixelSize: 14
                        text: modelData.time
                    }
                }
            }
        }
    }
}
