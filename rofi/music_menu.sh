#!/usr/bin/env bash

NOTIFY_TITLE="Music Menu"

THEME_OVERRIDE="
    configuration { show-icons: true; }
    window { 
        width: 90%; 
        anchor: center; location: center;
        padding: 20px; 
    } 
    mainbox {
        background-color: transparent;
        children: [ listview ];
    }
    listview { 
        columns: 6; lines: 1; 
        fixed-height: false; 
        fixed-columns: true; 
        cycle: false; 
        layout: vertical; flow: horizontal;
        spacing: 20px;
        background-color: transparent;
    } 
    element { 
        orientation: vertical; 
        padding: 20px; 
        spacing: 15px; 
        border-radius: 12px;
    } 
    element-icon { 
        size: 200px; 
        horizontal-align: 0.5; 
        background-color: transparent;
    } 
    element-text { 
        horizontal-align: 0.5; 
        vertical-align: 0.5; 
        expand: true;
        background-color: transparent;
    } 
    element selected { background-color: @accent; } 
    textbox { text-color: @accent; }
"

## CONNECTIVITY CHECK
if ! mpc status > /dev/null 2>&1; then
    notify-send "$NOTIFY_TITLE" "Error: Could not connect to MPD."
    exit 1
fi

mpc update > /dev/null 2>&1 &

## MPD MUSIC DIRECTORY DETECTION
MUSIC_DIR="${XDG_MUSIC_DIR:-$HOME/Music}"
if [ -f "$HOME/.config/mpd/mpd.conf" ]; then
    conf_dir=$(grep -m 1 '^[[:space:]]*music_directory' "$HOME/.config/mpd/mpd.conf" | cut -d '"' -f 2)
    [ -z "$conf_dir" ] && conf_dir=$(grep -m 1 '^[[:space:]]*music_directory' "$HOME/.config/mpd/mpd.conf" | awk '{print $2}' | tr -d "\"'")
    [ -n "$conf_dir" ] && MUSIC_DIR="${conf_dir/#\~/$HOME}"
fi

declare -A THUMB_CACHE
MAP_FILE="/tmp/rofi_music_map"
CURRENT_DIR_FILE="/tmp/rofi_music_dir"

# Load last directory or start at root
if [ -f "$CURRENT_DIR_FILE" ]; then
    CURRENT_DIR=$(cat "$CURRENT_DIR_FILE")
else
    CURRENT_DIR=""
fi

get_thumbnail() {
    local file_path="$1"
    local full_path="$MUSIC_DIR/$file_path"
    local dir_path="${full_path%/*}"
    
    if [[ "$file_path" != */* ]]; then
        dir_path="$MUSIC_DIR"
    fi

    if [ -n "${THUMB_CACHE["$dir_path"]}" ]; then
        echo "${THUMB_CACHE["$dir_path"]}"
        return
    fi
    
    for ext in jpg png; do
        for name in cover folder front album art; do
            if [ -f "$dir_path/$name.$ext" ]; then
                THUMB_CACHE["$dir_path"]="$dir_path/$name.$ext"
                echo "${THUMB_CACHE["$dir_path"]}"
                return
            fi
            if [ -f "$dir_path/${name^}.$ext" ]; then
                THUMB_CACHE["$dir_path"]="$dir_path/${name^}.$ext"
                echo "${THUMB_CACHE["$dir_path"]}"
                return
            fi
        done
    done
    
    # Generic fallback
    THUMB_CACHE["$dir_path"]="audio-x-generic"
    echo "audio-x-generic"
}

# Fetch contents of current directory
DISPLAY_LIST=""
> "$MAP_FILE" 

PLAYLIST=$(mpc ls "$CURRENT_DIR" 2>/dev/null)

# Only show Go Up if we are not at the root
if [ -n "$CURRENT_DIR" ]; then
    DISPLAY_LIST="..  (Go Up)\0icon\x1fgo-up\n"
fi

while IFS= read -r item; do
    [ -z "$item" ] && continue
    name=$(basename "$item")
    
    if [[ "$item" == *.* ]]; then
        # It's a file
        icon=$(get_thumbnail "$item")
        display_str="  $name"
        DISPLAY_LIST+="${display_str}\0icon\x1f$icon\n"
        echo "${display_str}|${item}" >> "$MAP_FILE"
    else
        # It's a folder
        icon="folder"
        full_dir="$MUSIC_DIR/$item"
        for ext in jpg png; do
            for cname in cover folder front album art; do
                if [ -f "$full_dir/$cname.$ext" ]; then
                    icon="$full_dir/$cname.$ext"
                    break 2
                fi
                if [ -f "$full_dir/${cname^}.$ext" ]; then
                    icon="$full_dir/${cname^}.$ext"
                    break 2
                fi
            done
        done
        DISPLAY_LIST+="  $name\0icon\x1f$icon\n"
    fi
done <<< "$PLAYLIST"

# Clean trailing newline
DISPLAY_LIST=$(echo "$DISPLAY_LIST" | sed '/^$/d')

# Trigger Rofi Menu
# We added single-click functionality via command line arguments here instead of the theme!
CHOSEN=$(echo -e -n "$DISPLAY_LIST" | rofi -dmenu -i -theme-str "$THEME_OVERRIDE" -hover-select -me-select-entry '' -me-accept-entry MousePrimary)

# If empty (user pressed Escape or closed window)
if [ -z "$CHOSEN" ]; then
    # Reset dir file so it opens fresh next time
    echo "" > "$CURRENT_DIR_FILE"
    exit 0
fi

# --- FOLDER / FILE NAVIGATION ---
if [[ "$CHOSEN" == "..  (Go Up)" ]]; then
    if [ -n "$CURRENT_DIR" ]; then
        CURRENT_DIR=$(dirname "$CURRENT_DIR")
        [ "$CURRENT_DIR" = "." ] && CURRENT_DIR=""
        echo "$CURRENT_DIR" > "$CURRENT_DIR_FILE"
    fi
    # Re-run the script to show the new folder
    exec "$0"
fi

# If it's a Folder (Starts with the folder icon)
if [[ "$CHOSEN" == * ]]; then
    clean_name="${CHOSEN:3}"
    if [ -z "$CURRENT_DIR" ]; then
        CURRENT_DIR="$clean_name"
    else
        CURRENT_DIR="$CURRENT_DIR/$clean_name"
    fi
    echo "$CURRENT_DIR" > "$CURRENT_DIR_FILE"
    # Re-run the script to show the new folder
    exec "$0"
fi

# If it's a File (Starts with the music icon)
if [[ "$CHOSEN" == * ]]; then
    file_path=$(grep -F "$CHOSEN|" "$MAP_FILE" | head -n 1 | cut -d'|' -f2-)
    
    mpc clear > /dev/null
    
    # Add the entire directory to the playlist so you can skip through it
    if [ -z "$CURRENT_DIR" ]; then
        mpc add "$file_path" > /dev/null
    else
        mpc add "$CURRENT_DIR" > /dev/null
    fi
    
    # Find the exact position of the selected song in the new playlist
    song_pos=$(mpc playlist -f "%file%" | grep -nFx "$file_path" | cut -d: -f1 | head -n 1)
    
    if [ -n "$song_pos" ]; then
        mpc play "$song_pos" > /dev/null
    else
        mpc play > /dev/null
    fi
    
    notify-send "$NOTIFY_TITLE" "Playing: ${CHOSEN:3}"
    # Reset dir to root when a song is picked so it opens cleanly next time
    echo "" > "$CURRENT_DIR_FILE"
    exit 0
fi
