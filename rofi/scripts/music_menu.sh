#!/usr/bin/env bash

# mpc/mpd controller for rofi
# handles browsing, shuffling, and base playback

NOTIFY_TITLE="Music Menu"
THEME_OVERRIDE="
    configuration { show-icons: false; }
    window { width: 600px; anchor: center; location: center; } 
    listview { columns: 1; lines: 12; spacing: 5px; } 
    element { orientation: horizontal; padding: 8px 12px; spacing: 12px; border-radius: 8px; } 
    element-text { vertical-align: 0.5; }
"

if ! mpc status > /dev/null 2>&1; then
    notify-send "$NOTIFY_TITLE" "Error: can't connect to mpd"
    exit 1
fi

mpc update > /dev/null 2>&1 &

# find where music lives
MUSIC_DIR="${XDG_MUSIC_DIR:-$HOME/Music}"
if [ -f "$HOME/.config/mpd/mpd.conf" ]; then
    conf_dir=$(grep -m 1 '^[[:space:]]*music_directory' "$HOME/.config/mpd/mpd.conf" | cut -d '"' -f 2)
    [ -z "$conf_dir" ] && conf_dir=$(grep -m 1 '^[[:space:]]*music_directory' "$HOME/.config/mpd/mpd.conf" | awk '{print $2}' | tr -d "\"'")
    [ -n "$conf_dir" ] && MUSIC_DIR="${conf_dir/#\~/$HOME}"
fi

MAP_FILE="/tmp/rofi_music_map"
CURRENT_DIR_FILE="/tmp/rofi_music_dir"

[ -f "$CURRENT_DIR_FILE" ] && CURRENT_DIR=$(cat "$CURRENT_DIR_FILE") || CURRENT_DIR=""

DISPLAY_LIST=""
> "$MAP_FILE" 

PLAYLIST=$(mpc ls "$CURRENT_DIR" 2>/dev/null)

# navigation tools
if [ -n "$CURRENT_DIR" ]; then
    DISPLAY_LIST="󰁝  .. (Go Up)\n"
    DISPLAY_LIST+="  Shuffle this folder\n"
else
    DISPLAY_LIST+="  Shuffle all music\n"
fi

while IFS= read -r item; do
    [ -z "$item" ] && continue
    name=$(basename "$item")
    
    if [[ "$item" == *.* ]]; then
        display_str="  $name"
        DISPLAY_LIST+="${display_str}\n"
        echo "${display_str}|${item}" >> "$MAP_FILE"
    else
        DISPLAY_LIST+="  $name\n"
    fi
done <<< "$PLAYLIST"

# get current status for the prompt
STATUS=$(mpc status | grep "\[" | awk '{print $1}' | tr -d '[]')
VOL=$(mpc status | grep "volume:" | awk '{print $2}')
CURRENT_SONG=$(mpc current -f "%title% - %artist%")

if [ -z "$CURRENT_SONG" ]; then
    PROMPT_TEXT="Music | Vol: $VOL"
else
    PROMPT_TEXT="[${STATUS^}] $CURRENT_SONG | Vol: $VOL"
fi

# launch the menu
CHOSEN=$(echo -e -n "$DISPLAY_LIST" | rofi -dmenu -i \
    -p "$PROMPT_TEXT" \
    -theme-str "$THEME_OVERRIDE" \
    -kb-custom-1 "Alt+equal" \
    -kb-custom-2 "Alt+n" \
    -kb-custom-3 "Alt+p")

EXIT_CODE=$?

case "$EXIT_CODE" in
    10) mpc toggle > /dev/null; exec "$0" ;;
    11) mpc next > /dev/null; exec "$0" ;;
    12) mpc prev > /dev/null; exec "$0" ;;
    0) 
        [ -z "$CHOSEN" ] && { echo "" > "$CURRENT_DIR_FILE"; exit 0; }

        # shuffle folder or all
        if [[ "$CHOSEN" == * ]]; then
            mpc clear > /dev/null
            [ -z "$CURRENT_DIR" ] && mpc add / || mpc add "$CURRENT_DIR"
            mpc shuffle > /dev/null
            mpc play > /dev/null
            notify-send "$NOTIFY_TITLE" "Shuffling: ${CHOSEN:3}"
            echo "" > "$CURRENT_DIR_FILE"
            exit 0
        fi

        # back one dir
        if [[ "$CHOSEN" == *".. (Go Up)"* ]]; then
            CURRENT_DIR=$(dirname "$CURRENT_DIR")
            [ "$CURRENT_DIR" = "." ] && CURRENT_DIR=""
            echo "$CURRENT_DIR" > "$CURRENT_DIR_FILE"
            exec "$0"
        fi

        # enter folder
        if [[ "$CHOSEN" == * ]]; then
            clean_name="${CHOSEN:3}"
            [ -z "$CURRENT_DIR" ] && CURRENT_DIR="$clean_name" || CURRENT_DIR="$CURRENT_DIR/$clean_name"
            echo "$CURRENT_DIR" > "$CURRENT_DIR_FILE"
            exec "$0"
        fi

        # play file
        if [[ "$CHOSEN" == * ]]; then
            file_path=$(grep -F "$CHOSEN|" "$MAP_FILE" | head -n 1 | cut -d'|' -f2-)
            mpc clear > /dev/null
            [ -z "$CURRENT_DIR" ] && mpc add "$file_path" || mpc add "$CURRENT_DIR"
            song_pos=$(mpc playlist -f "%file%" | grep -nFx "$file_path" | cut -d: -f1 | head -n 1)
            [ -n "$song_pos" ] && mpc play "$song_pos" || mpc play
            notify-send "$NOTIFY_TITLE" "Playing: ${CHOSEN:3}"
            echo "" > "$CURRENT_DIR_FILE"
            exit 0
        fi
        ;;
    *) exit 0 ;;
esac