#!/usr/bin/env bash

# Reusable Directory Picker for Rofi
# Usage: ./dir_picker.sh [starting_dir]

starting_dir="${1:-$HOME}"
current_dir="$starting_dir"

while true; do
    dirs=$(find "$current_dir" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf "%f\n" | sort)
    options="  Use This Folder\n..\n$dirs"
    
    # Prevent empty trailing newline ghost-boxes in the picker too
    options=$(echo "$options" | sed '/^$/d')

    # Try to find the correct theme path
    theme_file="$HOME/.config/rofi/ListSearchConfig.rasi"
    if [ ! -f "$theme_file" ]; then
        # Fallback to current project path during development
        theme_file="$(dirname "$(readlink -f "$0")")/../ListSearchConfig.rasi"
    fi

    chosen=$(echo -e -n "$options" | rofi -dmenu -i -p "$current_dir" -theme "$theme_file")
    
    if [ -z "$chosen" ]; then 
        exit 1
    elif [ "$chosen" == "  Use This Folder" ]; then 
        echo "$current_dir"
        exit 0
    elif [ "$chosen" == ".." ]; then 
        current_dir=$(dirname "$current_dir")
    else 
        current_dir="$current_dir/$chosen"
    fi
done