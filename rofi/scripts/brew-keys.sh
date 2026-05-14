#!/usr/bin/env bash

# config and theme paths
CONFIG="$HOME/.config/hypr/hyprland.lua"
THEME="$HOME/.config/rofi/noleftpadding.rasi"

get_binds() {
    grep -E "hl\.bind\(" "$CONFIG" | while read -r line; do
        # Extract the first argument (key combination)
        # Handles: hl.bind(mainMod .. " + RETURN", ...) or hl.bind("XF86AudioNext", ...)
        key_comb=$(echo "$line" | sed -E 's/.*hl\.bind\(([^,]+),.*/\1/' | sed "s/mainMod \.\. /SUPER /g" | tr -d '"' | tr -d "'" | xargs)
        
        # Skip if key_comb contains variables we couldn't resolve (like in loops)
        if [[ "$key_comb" == *"key"* || "$key_comb" == *"i"* ]]; then
            continue
        fi

        # Pull description if added, otherwise use the action
        if [[ "$line" == *"-- [desc:"* ]]; then
            desc=$(echo "$line" | sed -E 's/.*-- \[desc: (.*)\].*/\1/')
        else
            # Extract action as fallback: hl.bind(key, action, ...)
            # We look for the second argument and clean it up
            desc=$(echo "$line" | sed -E 's/.*hl\.bind\([^,]+,\s*([^,]+).*/\1/' | sed 's/hl\.dsp\.//' | sed -E 's/\)+$//' | xargs)
        fi
        
        printf "%-25s │ %s\n" "$key_comb" "$desc"
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
