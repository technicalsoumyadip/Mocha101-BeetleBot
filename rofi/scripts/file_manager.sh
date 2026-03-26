#!/usr/bin/env bash

# Try to find the correct theme path
theme_file="$HOME/.config/rofi/ListSearchConfig.rasi"
if [ ! -f "$theme_file" ]; then
    # Fallback to current project path during development
    theme_file="$(dirname "$(readlink -f "$0")")/../ListSearchConfig.rasi"
fi

rofi_cmd="rofi -dmenu -theme $theme_file"

current_dir="$HOME"

while true; do
    # Efficiently list directories and files
    # Using ls -p to mark directories with / and --group-directories-first
    # Using ls -lh to get human readable sizes
    
    entries=""
    [ "$current_dir" != "$HOME" ] && entries="../\n"

    # Get directory listing in one go
    # Format: "icon name [size]"
    # Using a temporary file or process substitution to handle filenames with spaces
    
    raw_list=$(ls -1pa --group-directories-first "$current_dir" | grep -v '^\./$')
    
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        [ "$line" == "../" ] && continue
        
        full_path="$current_dir/$line"
        
        if [[ "$line" == */ ]]; then
            # Directory
            name="${line%/}"
            entries+="📁 $name\n"
        else
            # File - get size efficiently
            # We call du only if needed, but better yet use ls -lh for all files at once if possible
            # However, for rofi formatting, we'll do a quick check
            size=$(ls -sh "$full_path" | awk '{print $1}')
            entries+="📄 $line    [$size]\n"
        fi
    done <<< "$raw_list"

    selection=$(printf "$entries" | $rofi_cmd -p "$(basename "$current_dir")")

    [ -z "$selection" ] && exit

    # go up
    if [ "$selection" = "../" ]; then
        current_dir=$(dirname "$current_dir")
        continue
    fi

    # Extract name - remove icon and size suffix
    name=$(echo "$selection" | sed 's/^📁 //; s/^📄 //; s/    .*//')
    path="$current_dir/$name"

    if [[ "$selection" == 📁* ]]; then
        current_dir="$path"
        continue
    fi

    if [[ "$selection" == 📄* ]]; then
        xdg-open "$path" & disown
        exit
    fi

done