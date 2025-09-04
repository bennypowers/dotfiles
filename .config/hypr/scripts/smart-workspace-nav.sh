#!/bin/bash

# Smart workspace navigation script
# Implements hyprnome-style navigation with special:workmode integration
# Usage: smart-workspace-nav.sh [left|right|up|down]

DIRECTION="$1"

# Get current workspace info
# Check if special:workmode is currently visible by checking if any window in it is focused
ACTIVE_WINDOW_WS=$(hyprctl activewindow -j 2>/dev/null | jq -r '.workspace.name // empty')

if [ "$ACTIVE_WINDOW_WS" = "special:workmode" ]; then
    # We're viewing the special workspace (a window in it has focus)
    CURRENT_WS="special:workmode"
    CURRENT_WS_ID=-98
else
    # We're on a regular workspace (or no focused window)
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name')
    CURRENT_WS_ID=$(hyprctl activeworkspace -j | jq -r '.id')
fi

# Get all workspaces and find the highest occupied regular workspace
HIGHEST_WS=$(hyprctl workspaces -j | jq -r '.[].id' | grep -E '^[0-9]+$' | sort -n | tail -1)

# Special workspace name for workmode
WORKMODE_SPECIAL="special:workmode"

# Check if workmode is ON (VM running AND virt-viewer open)
# Only two valid states: ON (running+viewer) or OFF (suspended+no viewer)
check_workmode_active() {
    # Check if VM is running (not paused or suspended)
    VM_STATE=$(virsh domstate silverblue 2>/dev/null | tr -d '\n')
    if [ "$VM_STATE" != "running" ]; then
        return 1
    fi
    
    # Check if virt-viewer is running
    if ! pgrep -f "virt-viewer" >/dev/null 2>&1; then
        return 1
    fi
    
    return 0
}

case "$DIRECTION" in
    "left"|"up")
        if [ "$CURRENT_WS" = "$WORKMODE_SPECIAL" ]; then
            # From workmode special workspace, go back to highest regular workspace
            hyprctl dispatch togglespecialworkspace workmode
            hyprctl dispatch workspace "$HIGHEST_WS"
        elif [ "$CURRENT_WS_ID" = "1" ] && check_workmode_active; then
            # From workspace 1, go to workmode special workspace (if active)
            hyprctl dispatch togglespecialworkspace workmode
        else
            # Regular left/up navigation (workspace n-1)
            hyprctl dispatch workspace e-1
        fi
        ;;
    
    "right"|"down")
        if [ "$CURRENT_WS" = "$WORKMODE_SPECIAL" ]; then
            # From workmode special workspace (N+1), wraparound to workspace 1
            hyprctl dispatch togglespecialworkspace workmode
            hyprctl dispatch workspace 1
        elif [ "$CURRENT_WS_ID" = "$HIGHEST_WS" ] && check_workmode_active; then
            # From highest regular workspace (N), go to workmode special workspace (N+1)
            # BUT only if workmode is actually active (VM running + viewer open)
            hyprctl dispatch togglespecialworkspace workmode
        else
            # Regular right/down navigation (existing behavior)
            hyprctl dispatch workspace e+1
        fi
        ;;
    
    *)
        echo "Usage: $0 [left|right|up|down]"
        exit 1
        ;;
esac