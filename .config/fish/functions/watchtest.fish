function watchtest --description "Watch file changes and run make test"
    set -l extensions ".go" ".scm" ".json" ".ts" ".css" ".md"

    # Parse arguments for custom extensions
    if test (count $argv) -gt 0
        set extensions $argv
    end

    # Build find command with all extensions
    set -l find_args
    for ext in $extensions
        if test (count $find_args) -gt 0
            set -a find_args "-o"
        end
        set -a find_args "-name" "*$ext"
    end

    echo "Watching for changes in files with extensions: $extensions"
    echo "Press Ctrl+C to stop watching"
    echo ""

    # Use find with entr to watch for file changes
    find . -type f \( $find_args \) | entr -c make test
end