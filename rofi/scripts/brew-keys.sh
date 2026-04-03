#!/usr/bin/env bash

# config and theme paths
CONFIG="$HOME/.config/hypr/HLconfigs/keybindings.conf"
THEME="$HOME/.config/rofi/noleftpadding.rasi"

get_binds() {
    grep -E "^bind[a-z]* =" "$CONFIG" | while read -r line; do
        # MODS, KEY, ACTION, ARG # [desc: Description]
        clean_line=$(echo "$line" | sed -E 's/^bind[a-z]* *= *//')
        
        mods=$(echo "$clean_line" | cut -d',' -f1 | sed 's/\$mainMod/SUPER/g' | xargs)
        key=$(echo "$clean_line" | cut -d',' -f2 | xargs)
        
        # Pull description if added, otherwise use the action
        if [[ "$line" == *"# [desc:"* ]]; then
            desc=$(echo "$line" | sed -E 's/.*# \[desc: (.*)\]/\1/')
        else
            desc=$(echo "$clean_line" | cut -d',' -f3- | sed 's/exec, //' | sed 's/  */ /g' | xargs)
        fi
        
        printf "%-25s │ %s\n" "$mods $key" "$desc"
    done
}

choice=$(get_binds | rofi -dmenu \
    -i \
    -p "Cheat Sheet" \
    -theme "$THEME" \
    -theme-str 'entry { placeholder: "Search Binds..."; } listview { lines: 15; } window { width: 800px; } element-icon { enabled: false; } element { spacing: 0px; }')

# copy the shortcut to clipboard if chosen
if [ -n "$choice" ]; then
    shortcut=$(echo "$choice" | cut -d'│' -f1 | xargs)
    echo -n "$shortcut" | wl-copy
    notify-send "Brew-Keys" "Copied $shortcut to clipboard"
fi
