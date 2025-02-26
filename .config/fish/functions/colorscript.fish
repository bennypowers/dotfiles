function colorscript -d "Simple CLI for shell-color-scripts, translated to Fish from the original by DT Linux"
    set -l usage "Usage: colorscript [option]
Options:
    -h, --help       Show this help message
    -l, --list       List all color scripts
    -r, --random     Run a random color script
    -e, --exec       Execute a specific color script by name"

    if test (count $argv) -eq 0
        echo $usage
        return 1
    end

    set -l SCRIPTDIR "$HOME/.config/colorscripts/"

    switch $argv[1]
        case -h --help
            echo $usage

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
                set -l random_script (random choice (ls -1p $SCRIPTDIR | grep -v '/'))
                sh $SCRIPTDIR/$random_script
            else
                echo "No color scripts directory found at $SCRIPTDIR"
                return 1
            end

        case -e --exec
            if test (count $argv) -lt 2
                echo "Please specify a color script name"
                return 1
            end

            set -l script_path "$SCRIPTDIR/$argv[2]"

            if test -f $script_path
                sh $script_path
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
