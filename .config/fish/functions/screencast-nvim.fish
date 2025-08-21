function screencast-nvim -d "Automatically record nvim sessions"
    # Configuration
    set -l OUTPUT_DIR (xdg-user-dir VIDEOS)"/screencasts"

    # Ensure output directory exists
    mkdir -p $OUTPUT_DIR

    # Main script
    if test (count $argv) -eq 0
        _screencast_print_usage
        return 1
    end

    set -l target $argv[1]
    set -l dry_run false

    # Check for dry-run flag
    if test (count $argv) -ge 2; and test "$argv[2]" = --dry-run
        set dry_run true
    end

    # Handle special arguments
    switch $target
        case -h --help help
            _screencast_print_usage
            return 0
        case --dry-run
            echo "Error: --dry-run must come after the target argument"
            _screencast_print_usage
            return 1
        case "*"
            if test $dry_run = true
                _screencast_dry_run_test $target $OUTPUT_DIR
            else
                _screencast_launch_nvim_with_recording $target $OUTPUT_DIR
            end
    end
end

function _screencast_print_usage
    echo "Usage: screencast-nvim <directory-or-file> [--dry-run]"
    echo ""
    echo "This script will:"
    echo "1. Change to directory (if dir provided) or open file"
    echo "2. Start recording automatically with wf-recorder"
    echo "3. Launch nvim"
    echo "4. Stop recording when nvim exits"
    echo ""
    echo "Options:"
    echo "  --dry-run             Test the script logic without actually recording"
    echo ""
    echo "Examples:"
    echo "  screencast-nvim ./demo-project           # cd to dir and launch nvim ."
    echo "  screencast-nvim ./src/main.ts            # open specific file"
    echo "  screencast-nvim . --dry-run              # test current directory"
    echo ""
    echo "Requirements:"
    echo "  - wf-recorder (for recording)"
    echo "  - hyprctl (for window management)"
    echo "  - kitty (terminal for nvim)"
    echo "  - jq (for JSON parsing)"
    echo "  - nvim (obviously)"
    echo ""
    echo "Output directory: ~/Videos/screencasts/"
end

function _screencast_setup_window_env
    echo "Setting up recording environment..."

    # Switch to dedicated recording workspace
    hyprctl dispatch workspace 10

    # Apply window rules for clean recording
    hyprctl keyword windowrulev2 "float, class:^(kitty)\$"
    hyprctl keyword windowrulev2 "size 1200 800, class:^(kitty)\$"
    hyprctl keyword windowrulev2 "move +320+180, class:^(kitty)\$"

    sleep 1
end

function _screencast_cleanup_window_env
    echo "Cleaning up window environment..."

    # Remove window rules
    hyprctl keyword windowrulev2 "unset, class:^(kitty)\$"
end

function _screencast_get_recording_filename
    set -l target $argv[1]
    set -l timestamp (date +%Y%m%d_%H%M%S)
    set -l target_name (basename (realpath $target) | sed 's/[^a-zA-Z0-9.-]/_/g')
    echo "nvim-screencast_$target_name"_"$timestamp.webm"
end

function _screencast_wait_for_kitty_window
    echo "⏳ Waiting for kitty window to appear..." >&2
    set -l max_attempts 20
    set -l attempt 0

    while test $attempt -lt $max_attempts
        echo "🔍 Attempt $attempt: Looking for kitty window on workspace 10..." >&2

        # Debug: show all windows first
        if test $attempt -eq 0
            echo "🔍 All current windows:" >&2
            hyprctl clients -j | jq -r '.[] | "\(.address) - \(.class) - workspace:\(.workspace.id) - \(.title)"' >&2
        end

        set -l kitty_window (hyprctl clients -j | jq -r '.[] | select(.class == "kitty" and .workspace.id == 10) | .address' | head -1)
        if test -n "$kitty_window"
            echo "✅ Found kitty window on workspace 10: $kitty_window" >&2
            echo $kitty_window
            return 0
        end

        # Fallback: look for any kitty window (maybe it didn't go to workspace 10)
        set -l any_kitty_window (hyprctl clients -j | jq -r '.[] | select(.class == "kitty") | .address' | head -1)
        if test -n "$any_kitty_window"
            echo "⚠️  Found kitty window on different workspace: $any_kitty_window" >&2
            echo $any_kitty_window
            return 0
        end
        sleep 0.5
        set attempt (math $attempt + 1)
    end

    echo "❌ Timeout waiting for kitty window" >&2
    echo "🔍 Final window list:" >&2
    hyprctl clients -j | jq -r '.[] | "\(.address) - \(.class) - workspace:\(.workspace.id) - \(.title)"' >&2
    return 1
end

function _screencast_get_window_geometry_with_margin
    set -l window_address $argv[1]
    set -l margin $argv[2]

    if test -z "$margin"
        set margin 20
    end

    echo "🔍 Debug: Looking for window $window_address" >&2

    # Get window info with debugging
    set -l window_json (hyprctl clients -j | jq ".[] | select(.address == \"$window_address\")")

    if test -z "$window_json"
        echo "❌ Could not find window with address $window_address" >&2
        echo "🔍 Available windows:" >&2
        hyprctl clients -j | jq -r '.[] | "\(.address) - \(.class) - \(.title)"' >&2
        return 1
    end

    echo "🔍 Found window info: $window_json" >&2

    # Extract coordinates and size
    set -l x (echo $window_json | jq -r '.at[0]')
    set -l y (echo $window_json | jq -r '.at[1]')
    set -l w (echo $window_json | jq -r '.size[0]')
    set -l h (echo $window_json | jq -r '.size[1]')

    echo "🔍 Window position: $x,$y size: $w"x"$h" >&2

    # Validate we got numbers
    if test "$x" = null -o "$y" = null -o "$w" = null -o "$h" = null
        echo "❌ Invalid window geometry data" >&2
        return 1
    end

    # Calculate geometry with margin
    set -l recording_x (math $x - $margin)
    set -l recording_y (math $y - $margin)
    set -l recording_w (math $w + $margin + $margin)
    set -l recording_h (math $h + $margin + $margin)

    # Ensure we don't go negative
    if test $recording_x -lt 0
        set recording_x 0
    end
    if test $recording_y -lt 0
        set recording_y 0
    end

    # wf-recorder uses format: "x,y WxH" not "WxH+x+y"
    echo "$recording_x,$recording_y $recording_w"x"$recording_h"
end

function _screencast_start_recording
    set -l filename $argv[1]
    set -l output_dir $argv[2]
    echo "🔴 Starting recording: $filename"

    # Wait for kitty window and get its geometry
    echo "🔍 About to wait for kitty window..."
    set -l kitty_window (_screencast_wait_for_kitty_window)
    set -l wait_status $status
    echo "🔍 wait_for_kitty_window returned status: $wait_status"
    echo "🔍 kitty_window value: '$kitty_window'"

    if test $wait_status -ne 0
        echo "❌ Failed to find kitty window for recording"
        return 1
    end

    set -l geometry (_screencast_get_window_geometry_with_margin $kitty_window 20)
    if test $status -ne 0
        echo "❌ Failed to get window geometry"
        return 1
    end

    echo "📐 Recording geometry: $geometry (window + 20px margin)"

    # Validate geometry format (should be "x,y WxH")
    if not echo $geometry | grep -q '^[0-9]*,[0-9]* [0-9]*x[0-9]*$'
        echo "❌ Invalid geometry format: $geometry (expected: x,y WxH)"
        return 1
    end

    # Start recording with dynamic geometry
    echo "🎥 Starting wf-recorder with geometry: $geometry"
    echo "🎥 Full command: wf-recorder -c libvpx-vp9 -r 60 -p crf=15 -p b:v=2M -g $geometry -f \"$output_dir/$filename\""
    wf-recorder -c libvpx-vp9 -r 60 -p crf=15 -p b:v=2M -g $geometry -f "$output_dir/$filename" 2>&1 &
    set -l recording_pid $last_pid

    # Store PID for cleanup
    echo $recording_pid >/tmp/screencast-nvim.pid

    # Check if wf-recorder started successfully
    sleep 2
    if not kill -0 $recording_pid 2>/dev/null
        echo "❌ wf-recorder process died after starting"
        return 1
    end

    hyprctl notify 1 2000 'rgb(51cf66)' "Recording started: $filename"

    return 0
end

function _screencast_stop_recording
    set -l output_dir $argv[1]
    echo "⏹️  Stopping recording..."

    # Get PID from file
    if test -f /tmp/screencast-nvim.pid
        set -l pid (cat /tmp/screencast-nvim.pid)
        if test -n "$pid"
            kill $pid 2>/dev/null || true
        end
        rm -f /tmp/screencast-nvim.pid
    end

    # Fallback: kill any wf-recorder processes
    pkill -f 'wf-recorder.*nvim-screencast' 2>/dev/null || true

    hyprctl notify 1 2000 'rgb(ff6b6b)' "Recording stopped"

    echo "✅ Recording saved to $output_dir/"
    if test -n (ls $output_dir/*.webm 2>/dev/null)
        ls -la $output_dir/*.webm | tail -1
    end
end

function _screencast_dry_run_test
    set -l target $argv[1]
    set -l output_dir $argv[2]

    echo "🧪 DRY RUN - Testing script logic"
    echo "Target: $target"
    echo ""

    # Validate target exists
    if not test -e "$target"
        echo "❌ Error: '$target' does not exist"
        return 1
    end

    # Generate filename based on target
    set -l filename (_screencast_get_recording_filename $target)

    echo "✅ Target validation: PASSED"
    echo "📁 Target type: "(if test -d "$target"; echo "directory"; else; echo "file"; end)
    echo "📹 Would record to: $output_dir/$filename"
    echo ""

    if test -d "$target"
        echo "📂 Would cd to: "(realpath $target)
        echo "🚀 Would run: kitty --directory \"$target\" -e nvim ."
    else
        echo "📄 Would open file: "(realpath $target)
        echo "🚀 Would run: kitty --directory \"$(dirname $target)\" -e nvim \"$(basename $target)\""
    end

    echo ""
    echo "🎬 Recording setup:"
    echo "   - Workspace: 10"
    echo "   - Window rules: Applied"
    echo "   - Geometry: Dynamic (kitty window + 20px margin)"
    echo "   - Output dir: $output_dir"
    echo ""
    echo "✅ Dry run completed successfully!"
    echo "To actually record, run: screencast-nvim $target"
end

function _screencast_check_dependencies
    set -l missing_deps

    if not command -v wf-recorder >/dev/null
        set missing_deps $missing_deps wf-recorder
    end

    if not command -v hyprctl >/dev/null
        set missing_deps $missing_deps hyprctl
    end

    if not command -v nvim >/dev/null
        set missing_deps $missing_deps nvim
    end

    if not command -v kitty >/dev/null
        set missing_deps $missing_deps kitty
    end

    if not command -v jq >/dev/null
        set missing_deps $missing_deps jq
    end

    if test (count $missing_deps) -gt 0
        echo "❌ Missing dependencies: $missing_deps"
        echo "Please install them before running this script."
        return 1
    end

    return 0
end

function _screencast_launch_nvim_with_recording
    set -l target $argv[1]
    set -l output_dir $argv[2]

    # Check dependencies
    if not _screencast_check_dependencies
        return 1
    end

    # Validate target exists
    if not test -e "$target"
        echo "Error: '$target' does not exist"
        return 1
    end

    # Generate filename based on target
    set -l filename (_screencast_get_recording_filename $target)

    echo "🎬 Auto-recording nvim session"
    echo "Target: $target"
    echo "Output: $output_dir/$filename"
    echo ""

    # Set up environment
    _screencast_setup_window_env

    # Launch nvim in a new kitty window first
    echo "🚀 Launching kitty window..."
    if test -d "$target"
        echo "📁 Opening directory: $target"
        # Launch kitty with nvim for directory
        kitty \
            --override font_size=16.0 \
            --override window_padding_width=10 \
            --override scrollback_lines=1000 \
            --override cursor_blink_interval=0 \
            --override initial_window_width=120 \
            --override initial_window_height=40 \
            --directory "$target" \
            -e nvim . &
    else
        echo "📄 Opening file: $target"
        # Launch kitty with nvim for specific file
        set -l target_dir (dirname "$target")
        set -l target_file (basename "$target")
        kitty \
            --override font_size=16.0 \
            --override window_padding_width=10 \
            --override scrollback_lines=1000 \
            --override cursor_blink_interval=0 \
            --override initial_window_width=120 \
            --override initial_window_height=40 \
            --directory "$target_dir" \
            -e nvim "$target_file" &
    end

    # Store kitty PID for cleanup
    set -l kitty_pid $last_pid

    # Wait longer for window to appear and settle  
    echo "⏳ Waiting for kitty window to fully load..."
    sleep 3

    # Start recording (this will wait for the window and get its geometry)
    _screencast_start_recording $filename $output_dir
    if test $status -ne 0
        echo "❌ Recording failed to start"
        kill $kitty_pid 2>/dev/null || true
        _screencast_cleanup_window_env
        return 1
    end

    # Wait for kitty process to finish (when nvim exits)
    echo "✅ Recording active. Waiting for nvim to exit..."
    wait $kitty_pid

    # When nvim exits, stop recording and cleanup
    _screencast_stop_recording $output_dir
    _screencast_cleanup_window_env

    echo ""
    echo "🎉 Session complete!"
    echo "Recording saved: $output_dir/$filename"
end
