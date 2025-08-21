#!/bin/bash

# Get window list from hyprctl and format for rofi
windows=$(hyprctl clients -j | jq -r '.[] | "\(.address):\(.class) - \(.title)"')

if [ -z "$windows" ]; then
    echo "No windows found"
    exit 1
fi

# Show rofi with window list
selected=$(echo "$windows" | rofi -dmenu -theme catppuccin-macchiato -show-icons -p "Switch to window:")

if [ -n "$selected" ]; then
    # Extract window address
    address=$(echo "$selected" | cut -d':' -f1)
    # Focus the selected window
    hyprctl dispatch focuswindow "address:$address"
fi