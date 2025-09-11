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

# Check for Steam games specifically (not Steam UI processes)
# Look for processes that are children of steam and running game executables
if pgrep -f "\.local/share/Steam/steamapps" > /dev/null 2>&1; then
    exit 0  # Steam game found, inhibit suspend
fi

# Check for wine/proton games launched by Steam
if pgrep -f "compatdata.*pfx" > /dev/null 2>&1; then
    exit 0  # Wine/Proton game found, inhibit suspend
fi

# No processes found, allow suspend
exit 1