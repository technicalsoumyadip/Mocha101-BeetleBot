#!/usr/bin/env bash

NOTIFY_TITLE="Music"
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @accent;} element selected {background-color: @accent;} button selected {text-color: @accent;} textbox {text-color: @accent;}"

## CONNECTIVITY CHECK
if ! mpc status > /dev/null 2>&1; then
    notify-send "$NOTIFY_TITLE" "Error: Could not connect to MPD."
    exit 1
fi

mpc update > /dev/null 2>&1 &

CURRENT_DIR=""

## BROWSER LOOP
while true; do
    PLAYLIST=$(mpc ls "$CURRENT_DIR" 2>/dev/null)

    if [ -z "$PLAYLIST" ] && [ -z "$CURRENT_DIR" ]; then
        notify-send "$NOTIFY_TITLE" "MPD Library is empty."
        exit 1
    fi

    DISPLAY_LIST=""
    if [ -n "$CURRENT_DIR" ]; then
        DISPLAY_LIST="..  (Go Up)\n"
    fi
    
    while IFS= read -r item; do
        if [ -z "$item" ]; then continue; fi
        name=$(basename "$item")
        
        # Simple file/folder icon logic
        if [[ "$item" == *.* ]]; then
            DISPLAY_LIST+="  $name\n"
        else
            DISPLAY_LIST+="  $name\n"
        fi
    done <<< "$PLAYLIST"

    CHOSEN=$(echo -e "$DISPLAY_LIST" | rofi -dmenu -i -p "Music" -theme-str "$THEME_OVERRIDE")

    if [ -z "$CHOSEN" ]; then
        exit
    fi

    ## SELECTION LOGIC
    if [[ "$CHOSEN" == "..  (Go Up)" ]]; then
        CURRENT_DIR=$(dirname "$CURRENT_DIR")
        if [ "$CURRENT_DIR" == "." ]; then CURRENT_DIR=""; fi

    elif [[ "$CHOSEN" == * ]]; then
        clean_name="${CHOSEN:3}"
        if [ -z "$CURRENT_DIR" ]; then
            CURRENT_DIR="$clean_name"
        else
            CURRENT_DIR="$CURRENT_DIR/$clean_name"
        fi

    elif [[ "$CHOSEN" == * ]]; then
        clean_name="${CHOSEN:3}"
        
        if [ -z "$CURRENT_DIR" ]; then
            full_path="$clean_name"
            add_path=""
        else
            full_path="$CURRENT_DIR/$clean_name"
            add_path="$CURRENT_DIR"
        fi
        
        # Clear queue and add the whole folder for continuous play
        mpc clear > /dev/null
        mpc add "$add_path" > /dev/null
        
        # Find the specific song position in the new queue
        song_pos=$(mpc playlist -f "%file%" | grep -nFx "$full_path" | cut -d: -f1 | head -n 1)
        
        if [ -n "$song_pos" ]; then
            mpc play "$song_pos" > /dev/null
            notify-send "$NOTIFY_TITLE" "Playing: $clean_name"
        else
            mpc play > /dev/null
            notify-send "$NOTIFY_TITLE" "Playing Folder"
        fi
        
        exit
    fi
done