#!/usr/bin/env bash

# Hyprland Layout Switcher via Rofi

# Theme detection
config_dir="$HOME/.config/rofi"
if [ ! -d "$config_dir" ]; then
    config_dir="$(dirname "$(readlink -f "$0")")/.."
fi

rofi_cmd="rofi -dmenu -i -theme $config_dir/NoSearchConfig.rasi"

# Get current layout
current_layout=$(hyprctl -j getoption general:layout | jq -r '.str')

# Define layouts
layouts=("dwindle" "scrolling" "master")

# Build menu
options=""
for layout in "${layouts[@]}"; do
    if [ "$layout" == "$current_layout" ]; then
        options+="● ${layout^}\n"
    else
        options+="  ${layout^}\n"
    fi
done

# Show rofi menu
chosen=$(printf "$options" | $rofi_cmd -p "Layout")

# Action handler
if [ -n "$chosen" ]; then
    # Clean choice (remove dot and lowercase)
    clean_choice=$(echo "$chosen" | sed 's/^..//' | tr '[:upper:]' '[:lower:]')
    
    if [ "$clean_choice" != "$current_layout" ]; then
        hyprctl keyword general:layout "$clean_choice"
        notify-send -a "Hyprland" "Layout Changed" "Switched to ${clean_choice^} layout"
    fi
fi
