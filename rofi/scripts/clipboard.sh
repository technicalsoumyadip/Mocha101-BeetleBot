#!/usr/bin/env bash

# clipboard manager for rofi
# uses cliphist and wtype for pasting

NOTIFY_TITLE="Clipboard"
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @accent;} element selected {background-color: @accent;} button selected {text-color: @accent;} textbox {text-color: @accent;}"

if ! command -v cliphist &> /dev/null || ! command -v wtype &> /dev/null; then
    notify-send "$NOTIFY_TITLE" "cliphist or wtype is missing"
    exit 1
fi

DEL_OPT="  Clear History"
CLIP_LIST=$(cliphist list | head -n 50)

if [ -z "$CLIP_LIST" ]; then
    notify-send "$NOTIFY_TITLE" "history is empty"
    exit
fi

CHOSEN=$(echo -e "$DEL_OPT\n$CLIP_LIST" | rofi -dmenu -i -p "Clipboard" -theme ~/.config/rofi/NoSearchConfig.rasi -theme-str "$THEME_OVERRIDE")

# handle selection
if [ -z "$CHOSEN" ]; then
    exit
elif [ "$CHOSEN" == "$DEL_OPT" ]; then
    cliphist wipe
    notify-send "$NOTIFY_TITLE" "History cleared"
else
    # select, then try to auto-paste
    echo "$CHOSEN" | cliphist decode | wl-copy
    sleep 0.2
    
    active_window_class=$(hyprctl activewindow -j | jq -r '.class')
    
    if [[ "$active_window_class" =~ (kitty|Alacritty|foot|wezterm|konsole) ]]; then
        wtype -M ctrl -M shift -k v -m shift -m ctrl
    else
        wtype -M ctrl -k v -m ctrl
    fi
fi