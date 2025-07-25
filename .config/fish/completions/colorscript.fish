# fish completion for colorscript

function __fish_colorscript_get_scripts
    set -l SCRIPTDIR (colorscript -S | string trim)
    if test -d $SCRIPTDIR
        ls -1p $SCRIPTDIR | grep -v '/$'
    end
end

function __fish_colorscript_get_animation_names
    set -l SCRIPTDIR (colorscript -S | string trim)
    if test -d $SCRIPTDIR
        find $SCRIPTDIR -type f -regextype posix-extended -regex '.*\.[0-9]+\..*' | sed -E 's/.*\/(.*)\.[0-9]+\..*$/\1/' | sort -u
    end
end

# Main command completions
set -l subcommands "-h --help -l --list -r --random -e --exec --animate generate -d --delay -S --show-script-dir"
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -s h -l help -d "Show this help message"
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -s l -l list -d "List all color scripts"
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -s r -l random -d "Run a random color script"
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -s e -l exec -d "Execute a specific color script by name" -r
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -l animate -d "Animate a sequence of colorscripts"
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -a "generate" -d "Generate a new colorscript from a sprite sheet" -r
complete -c colorscript -n "not __fish_seen_subcommand_from $subcommands" -s S -l show-script-dir -d "Show the directory where colorscripts are stored"

# Argument completions for subcommands
complete -c colorscript -n "__fish_seen_subcommand_from -e --exec" -f -a "(__fish_colorscript_get_scripts)" -d "Script name"
complete -c colorscript -n "__fish_seen_subcommand_from --animate" -f -a "(__fish_colorscript_get_animation_names)" -d "Animation name"
complete -c colorscript -n "__fish_seen_subcommand_from --animate" -s d -l delay -d "Animation delay in milliseconds" -r
complete -c colorscript -n "__fish_seen_subcommand_from generate" -d "Path or URL to sprite sheet"
