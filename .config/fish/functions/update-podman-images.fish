function update-podman-images -d "Update all podman images and show only those that received updates"
    # Spinner characters
    set -l spinner_chars "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
    set -l updated_images

    # Get list of non-dangling images
    set -l images (podman images --format json | jq -r 'map(select(.dangling | not)) | map(.Names) | .[] | select(. != null) | .[]')

    if test (count $images) -eq 0
        echo "No images found to update"
        return 0
    end

    set -l total (count $images)
    set -l current 0

    for image in $images
        set current (math $current + 1)

        # Prepare temporary file for pull output
        set -l tmpfile (mktemp)

        # Start spinner in background
        set -l spinner_pid
        fish -c "
            set spinner_chars $spinner_chars
            while true
                for char in \$spinner_chars
                    printf '\r\033[K%s [%d/%d] Checking %s' \$char $current $total '$image' >&2
                    sleep 0.1
                end
            end
        " &
        set spinner_pid $last_pid

        # Pull the image and capture output
        podman pull $image >$tmpfile 2>&1

        # Stop spinner
        kill $spinner_pid 2>/dev/null
        wait $spinner_pid 2>/dev/null

        # Clear spinner line
        printf '\r\033[K' >&2

        # Check if image was actually updated by looking for download indicators
        if grep -qE "Copying blob|Copying config|Writing manifest|Downloaded newer image" $tmpfile
            set -a updated_images $image
            printf "✓ [%d/%d] Updated: %s\n" $current $total $image >&2
        else
            printf "  [%d/%d] Already up-to-date: %s\n" $current $total $image >&2
        end

        rm -f $tmpfile
    end

    # Output only updated images
    echo "" >&2
    if test (count $updated_images) -gt 0
        echo "Updated images:" >&2
        for image in $updated_images
            echo $image
        end
    else
        echo "All images are up to date" >&2
    end
end
