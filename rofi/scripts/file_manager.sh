#!/usr/bin/env bash

# simple rofi file browser
# opens files with xdg-open and navigates directories

theme_file="$HOME/.config/rofi/ListSearchConfig.rasi"
[ ! -f "$theme_file" ] && theme_file="$(dirname "$(readlink -f "$0")")/../ListSearchConfig.rasi"

rofi_cmd="rofi -dmenu -theme $theme_file"
current_dir="$HOME"

while true; do
    entries=""
    [ "$current_dir" != "$HOME" ] && entries="../\n"

    # group directories first, then files
    raw_list=$(ls -1pa --group-directories-first "$current_dir" | grep -v '^\./$')
    
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        [ "$line" == "../" ] && continue
        
        full_path="$current_dir/$line"
        
        if [[ "$line" == */ ]]; then
            name="${line%/}"
            entries+="📁 $name\n"
        else
            size=$(ls -sh "$full_path" | awk '{print $1}')
            entries+="📄 $line    [$size]\n"
        fi
    done <<< "$raw_list"

    selection=$(printf "$entries" | $rofi_cmd -p "$(basename "$current_dir")")
    [ -z "$selection" ] && exit

    if [ "$selection" = "../" ]; then
        current_dir=$(dirname "$current_dir")
        continue
    fi

    # strip icons and size info to get the raw name
    name=$(echo "$selection" | sed 's/^📁 //; s/^📄 //; s/    .*//')
    path="$current_dir/$name"

    if [[ "$selection" == 📁* ]]; then
        current_dir="$path"
    elif [[ "$selection" == 📄* ]]; then
        xdg-open "$path" & disown
        exit
    fi
done