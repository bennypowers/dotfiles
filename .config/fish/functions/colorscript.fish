function colorscript -d "Simple CLI for shell-color-scripts, translated to Fish from the original by DT Linux"
    set -l usage "Usage: colorscript [option]
Options:
    -h, --help                Show this help message
    -l, --list                List all color scripts
    -r, --random              Run a random color script
    -e, --exec                Execute a specific color script by name
    -S, --show-script-dir     Show the directory where colorscripts are stored
    --animate <name>          Animate a sequence of colorscripts
        [-d|--delay <ms>]     Delay between frames in milliseconds (default: 333)"

    if test (count $argv) -eq 0
        echo $usage
        return 1
    end

    # Determine the script directory using XDG standards
    set -l SCRIPTDIR
    if set -q XDG_DATA_HOME
        set SCRIPTDIR "$XDG_DATA_HOME/colorscripts"
    else
        set SCRIPTDIR "$HOME/.local/share/colorscripts"
    end

    switch $argv[1]
        case -h --help
            echo $usage

        case -S --show-script-dir
            echo $SCRIPTDIR

        case 'generate'
            # Remove the 'generate' subcommand from argv
            set -l gen_args $argv[2..-1]
            if test -z "$gen_args"
                echo "Usage: colorscript generate <path_or_url_to_sprite_sheet>"
                return 1
            end
            # Execute the generator script
            set -l generator_script (dirname (status --current-filename))/../gen-colorscript.py
            $generator_script $gen_args

        case --animate
            set -l my_argv $argv[2..-1]
            argparse 'd/delay=' -- $my_argv
            or return 1

            if test (count $my_argv) -eq 0
                echo "Usage: colorscript --animate <name> [--delay <milliseconds>]"
                return 1
            end
            set -l name $my_argv[1]

            set -l delay 333 # default in ms
            if set -q _flag_delay
                if not string is-number -- "$_flag_delay"
                    echo "Error: --delay value must be a number in milliseconds." >&2
                    return 1
                end
                set delay $_flag_delay
            end

            set -l frames (find $SCRIPTDIR -type f -regextype posix-extended -regex ".*/$name"'(\.[0-9]+)?\.[^./]+$' | sort -V)

            if test (count $frames) -eq 0
                echo "No animation frames found for '$name'"
                return 1
            end

            # This function runs in the background
            function __animation_loop
                set -l loop_delay $argv[1]
                set -l loop_frames $argv[2..-1]
                while true
                    for frame in $loop_frames
                        echo -en "\e[H" # Move cursor to top-left
                        if string match -q -- "*.fish" "$frame"; fish "$frame"; else; sh "$frame"; end
                        sleep (math $loop_delay / 1000)
                    end
                end
            end

            # --- Direct Animation Control ---
            stty -echo
            tput civis
            clear
            __animation_loop $delay $frames &
            set -l anim_pid $last_pid
            read -s -n 1
            kill -- -$anim_pid 2>/dev/null
            tput cnorm
            stty echo
            return 0

        case -l --list
            if test -d $SCRIPTDIR
                for script in $SCRIPTDIR/*
                    basename $script
                end
            else
                echo "No color scripts directory found at $SCRIPTDIR"
                return 1
            end

        case -r --random
            if test -d $SCRIPTDIR
                set -l random_script_name (random choice (ls -1p $SCRIPTDIR | grep -v '/'))
                set -l random_script_path "$SCRIPTDIR/$random_script_name"
                if string match -q -- "*.fish" "$random_script_path"
                    fish "$random_script_path"
                else
                    sh "$random_script_path"
                end
            else
                echo "No color scripts directory found at $SCRIPTDIR"
                return 1
            end

        case -e --exec
            if test (count $argv) -lt 2
                echo "Please specify a color script name"
                return 1
            end

            set -l script_name "$argv[2]"
            set -l script_path ""

            if test -f "$SCRIPTDIR/$script_name"
                set script_path "$SCRIPTDIR/$script_name"
            else if test -f "$SCRIPTDIR/$script_name.sh"
                set script_path "$SCRIPTDIR/$script_name.sh"
            else if test -f "$SCRIPTDIR/$script_name.fish"
                set script_path "$SCRIPTDIR/$script_name.fish"
            end

            if test -n "$script_path"
                if string match -q -- "*.fish" "$script_path"
                    fish "$script_path"
                else
                    sh "$script_path"
                end
            else
                echo "Color script '$argv[2]' not found in $SCRIPTDIR"
                return 1
            end

        case '*'
            echo "Unknown option: $argv[1]"
            echo $usage
            return 1
    end
end