#!/usr/bin/env bash

# config and theme paths
CONFIG="$HOME/.config/hypr/hyprland.lua"
THEME="$HOME/.config/rofi/noleftpadding.rasi"

if [ ! -f "$CONFIG" ]; then
    notify-send "Brew-Keys" "Error: Configuration not found at $CONFIG"
    exit 1
fi

get_binds() {
    
    while IFS= read -r line || [ -n "$line" ]; do

        # Parse hl.bind calls
        if [[ "$line" == *"hl.bind("* ]]; then
            # Extract key combination
            key_comb=$(echo "$line" | sed -E 's/.*hl\.bind\(([^,]+),.*/\1/' | sed "s/mainMod \.\. /SUPER /g" | tr -d '"' | tr -d "'" | xargs)
            
            # Skip loop-generated binds with variables
            [[ "$key_comb" == *"key"* || "$key_comb" == *"i"* ]] && continue

            # Extract description or use the action as fallback
            if [[ "$line" == *"-- [desc:"* ]]; then
                desc=$(echo "$line" | sed -E 's/.*-- \[desc: (.*)\].*/\1/')
            else
                desc=$(echo "$line" | sed -E 's/.*hl\.bind\([^,]+,\s*([^,]+).*/\1/' | sed 's/hl\.dsp\.//' | sed -E 's/\)+$//' | xargs)
            fi
            
            printf "%-25s │ %s\n" "$key_comb" "$desc"
        fi
    done < "$CONFIG"
}

# Launch Rofi
choice=$(get_binds | rofi -dmenu \
    -i \
    -p "Cheat Sheet" \
    -theme "$THEME" \
    -theme-str 'entry { placeholder: "Search Binds..."; } listview { lines: 15; } window { width: 800px; } element-icon { enabled: false; } element { spacing: 0px; }')

if [ -n "$choice" ]; then
    shortcut=$(echo "$choice" | cut -d'│' -f1 | xargs)
    echo -n "$shortcut" | wl-copy
    notify-send "Brew-Keys" "Copied $shortcut to clipboard"
fi
