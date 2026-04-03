#!/usr/bin/env bash

# switcher for hyprland layouts
# toggles between dwindle, master, and scrolling

config_dir="$HOME/.config/rofi"
[ ! -d "$config_dir" ] && config_dir="$(dirname "$(readlink -f "$0")")/.."
rofi_cmd="rofi -dmenu -i -theme $config_dir/NoSearchConfig.rasi"

current_layout=$(hyprctl -j getoption general:layout | jq -r '.str')
layouts=("dwindle" "scrolling" "master")

options=""
for layout in "${layouts[@]}"; do
    if [ "$layout" == "$current_layout" ]; then
        options+="● ${layout^}\n"
    else
        options+="  ${layout^}\n"
    fi
done

chosen=$(printf "$options" | $rofi_cmd -p "Layout")

if [ -n "$chosen" ]; then
    # remove the marker and lowercase it for hyprctl
    clean_choice=$(echo "$chosen" | sed 's/^..//' | tr '[:upper:]' '[:lower:]')
    
    if [ "$clean_choice" != "$current_layout" ]; then
        hyprctl keyword general:layout "$clean_choice"
        notify-send -a "Hyprland" "Layout Switched" "Now using ${clean_choice^}"
    fi
fi
