#!/bin/bash

# Check if any processes from the inhibit list are running
# Returns 0 (success) if any process is found (inhibit suspend)
# Returns 1 (failure) if no processes are found (allow suspend)

SCRIPT_DIR="$(dirname "$0")"
PROCESS_FILE="$SCRIPT_DIR/../inhibit-processes.txt"

# Check if the process file exists
if [[ ! -f "$PROCESS_FILE" ]]; then
    exit 1
fi

# Read process names from file and check if any are running
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    
    # Check if process is running
    if pidof "$line" > /dev/null 2>&1; then
        exit 0  # Process found, inhibit suspend
    fi
done < "$PROCESS_FILE"

# No processes found, allow suspend
exit 1