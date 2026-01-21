#!/usr/bin/env bash

NOTIFY_TITLE="Clipboard"

# --- THEME OVERRIDE ---
# Removed 'width' and 'height' constraints so it matches your config.rasi defaults.
# Kept the Peach color (#fab387) for the border so you know it's the Clipboard.
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @accent;} element selected {background-color: @accent;} button selected {text-color: @accent;} textbox {text-color: @accent;}"

# 1. Check dependencies
if ! command -v cliphist &> /dev/null; then
    notify-send "$NOTIFY_TITLE" "Error: 'cliphist' is missing."
    exit 1
fi
if ! command -v wtype &> /dev/null; then
    notify-send "$NOTIFY_TITLE" "Error: 'wtype' is missing. Install it for auto-paste."
    exit 1
fi

# 2. Define Options
DEL_OPT="  Clear History"

# 3. Generate List
CLIP_LIST=$(cliphist list | head -n 50)

if [ -z "$CLIP_LIST" ]; then
    notify-send "$NOTIFY_TITLE" "Clipboard history is empty."
    exit
fi

# 4. Launch Rofi
CHOSEN=$(echo -e "$DEL_OPT\n$CLIP_LIST" | rofi -dmenu -i -p "Clipboard" -theme-str "$THEME_OVERRIDE")

# 5. Handle Selection
if [ -z "$CHOSEN" ]; then
    exit
elif [ "$CHOSEN" == "$DEL_OPT" ]; then
    cliphist wipe
    notify-send "$NOTIFY_TITLE" "History cleared."
else
    # A. Decode and put back into system clipboard
    echo "$CHOSEN" | cliphist decode | wl-copy
    
    # B. Wait slightly for Rofi to close
    sleep 0.2
    
    # C. SMART PASTE LOGIC
    # Get active window class
    active_window_class=$(hyprctl activewindow -j | jq -r '.class')
    
    # Check if we are in a terminal (send Ctrl+Shift+V)
    if [[ "$active_window_class" =~ (kitty|Alacritty|foot|wezterm|konsole) ]]; then
        wtype -M ctrl -M shift -k v -m shift -m ctrl
    else
        # Standard Paste (Ctrl+V)
        wtype -M ctrl -k v -m ctrl
    fi
fi