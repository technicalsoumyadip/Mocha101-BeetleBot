#!/usr/bin/env bash

# ==============================================================================
#  MPD/RMPC MUSIC BROWSER (Continuous Play)
#  - Adds the whole folder context on selection
#  - Starts playing at the selected song
# ==============================================================================

NOTIFY_TITLE="Music"
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @accent;} element selected {background-color: @accent;} button selected {text-color: @accent;} textbox {text-color: @accent;}"

# 1. Connectivity Check
if ! mpc status > /dev/null 2>&1; then
    notify-send "$NOTIFY_TITLE" "Error: Could not connect to MPD."
    exit 1
fi

# 2. AUTO-REFRESH
mpc update > /dev/null 2>&1 &

CURRENT_DIR=""

while true; do
    # 3. Get Playlist
    PLAYLIST=$(mpc ls "$CURRENT_DIR" 2>/dev/null)

    if [ -z "$PLAYLIST" ] && [ -z "$CURRENT_DIR" ]; then
        notify-send "$NOTIFY_TITLE" "MPD Library is empty."
        exit 1
    fi

    # 4. Format List
    DISPLAY_LIST=""
    
    if [ -n "$CURRENT_DIR" ]; then
        DISPLAY_LIST="..  (Go Up)\n"
    fi
    
    while IFS= read -r item; do
        if [ -z "$item" ]; then continue; fi
        
        name=$(basename "$item")
        
        # Check extension for Icon logic
        if [[ "$item" == *.* ]]; then
            DISPLAY_LIST+="  $name\n"   # File
        else
            DISPLAY_LIST+="  $name\n"   # Directory
        fi
    done <<< "$PLAYLIST"

    # 5. Launch Rofi
    CHOSEN=$(echo -e "$DISPLAY_LIST" | rofi -dmenu -i -p "Music" -theme-str "$THEME_OVERRIDE")

    if [ -z "$CHOSEN" ]; then
        exit
    fi

    # 6. Handle Logic
    if [[ "$CHOSEN" == "..  (Go Up)" ]]; then
        CURRENT_DIR=$(dirname "$CURRENT_DIR")
        if [ "$CURRENT_DIR" == "." ]; then CURRENT_DIR=""; fi

    elif [[ "$CHOSEN" == * ]]; then
        # === DIRECTORY ===
        clean_name="${CHOSEN:3}"
        if [ -z "$CURRENT_DIR" ]; then
            CURRENT_DIR="$clean_name"
        else
            CURRENT_DIR="$CURRENT_DIR/$clean_name"
        fi

    elif [[ "$CHOSEN" == * ]]; then
        # === SONG SELECTED ===
        clean_name="${CHOSEN:3}"
        
        if [ -z "$CURRENT_DIR" ]; then
            full_path="$clean_name"
            # If at root, adding "" adds entire library. 
            # Use dot "." to represent current dir for mpc add
            add_path=""
        else
            full_path="$CURRENT_DIR/$clean_name"
            add_path="$CURRENT_DIR"
        fi
        
        # --- NEW LOGIC START ---
        
        # 1. Clear current queue
        mpc clear > /dev/null
        
        # 2. Add the ENTIRE directory (so next songs play automatically)
        mpc add "$add_path" > /dev/null
        
        # 3. Find the position of the song we just clicked
        # We search the playlist for the exact file path to get its number
        song_pos=$(mpc playlist -f "%file%" | grep -nFx "$full_path" | cut -d: -f1 | head -n 1)
        
        # 4. Play from that position
        if [ -n "$song_pos" ]; then
            mpc play "$song_pos" > /dev/null
            notify-send "$NOTIFY_TITLE" "Playing: $clean_name"
        else
            # Fallback (Just play start if detection fails)
            mpc play > /dev/null
            notify-send "$NOTIFY_TITLE" "Playing Folder"
        fi
        
        exit
        # --- NEW LOGIC END ---
    fi
done