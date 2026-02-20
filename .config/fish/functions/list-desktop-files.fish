function list-desktop-files
    # Define the search paths
    # We include the user flatpak path explicitly to ensure it's caught
    set -l search_dirs (string split ":" "$XDG_DATA_DIRS") \
        $HOME/.local/share/flatpak/exports/share \
        $HOME/.local/share

    for dir in $search_dirs
        if test -d "$dir/applications"
            find "$dir/applications" -name "*.desktop" 2>/dev/null
        end
    end
end
