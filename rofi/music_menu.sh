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
        children: [ inputbar, listview ];
    }
    inputbar {
        background-color: transparent;
        border: 0px;
        margin: 0px 0px 20px 0px;
        padding: 10px 0px;
    }
    entry {
        background-color: transparent;
        text-color: @fg-col;
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
    
    # Generic audio file fallback
    THUMB_CACHE["$dir_path"]="audio-x-generic"
    echo "audio-x-generic"
}

STATE="main"
CURRENT_DIR=""
CURRENT_ALBUM=""

while true; do
    DISPLAY_LIST=""
    PROMPT="Music"
    > "$MAP_FILE" 

    if [ "$STATE" = "main" ]; then
        PROMPT="Main Menu"
        DISPLAY_LIST="  Albums\0icon\x1ffolder-music\n  Songs\0icon\x1ffolder-music\n  Folders\0icon\x1ffolder"

    elif [ "$STATE" = "albums" ]; then
        PROMPT="Albums"
        DISPLAY_LIST="..  (Go Up)\0icon\x1fgo-up\n"
        
        if [ -z "${ALBUM_CACHE:-}" ]; then
            declare -A ALBUM_FILE_CACHE
            while IFS='|' read -r fil alb; do
                if [ -n "$alb" ] && [ -z "${ALBUM_FILE_CACHE["$alb"]}" ]; then
                    ALBUM_FILE_CACHE["$alb"]="$fil"
                fi
            done <<< "$(mpc --format "%file%|%album%" search filename "")"
            ALBUM_CACHE="built"
        fi
        
        while IFS= read -r alb; do
            [ -z "$alb" ] && continue
            icon="folder-music"
            if [ -n "${ALBUM_FILE_CACHE["$alb"]}" ]; then
                thumbnail=$(get_thumbnail "${ALBUM_FILE_CACHE["$alb"]}")
                if [ "$thumbnail" != "audio-x-generic" ]; then
                    icon="$thumbnail"
                fi
            fi
            DISPLAY_LIST+="  $alb\0icon\x1f$icon\n"
        done <<< "$(mpc list album | awk 'NF')"

    elif [ "$STATE" = "album_songs" ]; then
        PROMPT="Album: $CURRENT_ALBUM"
        DISPLAY_LIST="..  (Go Up)\0icon\x1fgo-up\n"
        
        while IFS='|' read -r file title; do
            [ -z "$file" ] && continue
            icon=$(get_thumbnail "$file")
            name="${title:-$(basename "$file")}"
            display_str="  $name"
            DISPLAY_LIST+="${display_str}\0icon\x1f$icon\n"
            echo "${display_str}|${file}" >> "$MAP_FILE"
        done <<< "$(mpc --format "%file%|%title%" search album "$CURRENT_ALBUM")"

    elif [ "$STATE" = "songs" ]; then
        PROMPT="All Songs"
        DISPLAY_LIST="..  (Go Up)\0icon\x1fgo-up\n"
        
        while IFS='|' read -r file title artist; do
            [ -z "$file" ] && continue
            icon=$(get_thumbnail "$file")
            if [ -n "$title" ] && [ -n "$artist" ]; then
                name="$title - $artist"
            elif [ -n "$title" ]; then
                name="$title"
            else
                name="$(basename "$file")"
            fi
            display_str="  $name"
            DISPLAY_LIST+="${display_str}\0icon\x1f$icon\n"
            echo "${display_str}|${file}" >> "$MAP_FILE"
        done <<< "$(mpc --format "%file%|%title%|%artist%" search filename "")"

    elif [ "$STATE" = "folders" ]; then
        PROMPT="Folders"
        PLAYLIST=$(mpc ls "$CURRENT_DIR" 2>/dev/null)
        DISPLAY_LIST="..  (Go Up)\0icon\x1fgo-up\n"
        
        while IFS= read -r item; do
            [ -z "$item" ] && continue
            name=$(basename "$item")
            
            if [[ "$item" == *.* ]]; then
                icon=$(get_thumbnail "$item")
                display_str="  $name"
                DISPLAY_LIST+="${display_str}\0icon\x1f$icon\n"
                echo "${display_str}|${item}" >> "$MAP_FILE"
            else
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
    fi

    # Using -n suppresses the trailing newline Bash naturally adds to echo [web:148]
    # We also remove any trailing \n added programmatically at the end of the built string
    DISPLAY_LIST=$(echo "$DISPLAY_LIST" | sed 's/\\n$//')
    CHOSEN=$(echo -e -n "$DISPLAY_LIST" | rofi -dmenu -i -p "$PROMPT" -theme-str "$THEME_OVERRIDE")

    if [ -z "$CHOSEN" ]; then
        exit 0
    fi

    if [ "$CHOSEN" = ":p" ]; then
        mpc toggle > /dev/null
        notify-send "$NOTIFY_TITLE" "Playback Toggled"
        continue
    elif [ "$CHOSEN" = ":s" ]; then
        mpc stop > /dev/null
        notify-send "$NOTIFY_TITLE" "Playback Stopped"
        continue
    fi

    if [[ "$CHOSEN" == "..  (Go Up)" ]]; then
        if [ "$STATE" = "folders" ]; then
            if [ -z "$CURRENT_DIR" ]; then
                STATE="main"
            else
                CURRENT_DIR=$(dirname "$CURRENT_DIR")
                [ "$CURRENT_DIR" = "." ] && CURRENT_DIR=""
            fi
        elif [ "$STATE" = "albums" ] || [ "$STATE" = "songs" ]; then
            STATE="main"
        elif [ "$STATE" = "album_songs" ]; then
            STATE="albums"
        fi
        continue
    fi

    if [ "$STATE" = "main" ]; then
        if [[ "$CHOSEN" == *"Albums"* ]]; then STATE="albums"; fi
        if [[ "$CHOSEN" == *"Songs"* ]]; then STATE="songs"; fi
        if [[ "$CHOSEN" == *"Folders"* ]]; then STATE="folders"; fi
        continue
    fi

    if [ "$STATE" = "albums" ]; then
        CURRENT_ALBUM="${CHOSEN:3}"
        STATE="album_songs"
        continue
    fi

    if [[ "$CHOSEN" == * ]]; then
        clean_name="${CHOSEN:3}"
        if [ -z "$CURRENT_DIR" ]; then
            CURRENT_DIR="$clean_name"
        else
            CURRENT_DIR="$CURRENT_DIR/$clean_name"
        fi
        continue
    fi

    if [[ "$CHOSEN" == * ]]; then
        file_path=$(grep -F "$CHOSEN|" "$MAP_FILE" | head -n 1 | cut -d'|' -f2-)
        
        if [ "$STATE" = "folders" ]; then
            mpc clear > /dev/null
            if [ -z "$CURRENT_DIR" ]; then
                mpc add "$file_path" > /dev/null
            else
                mpc add "$CURRENT_DIR" > /dev/null
            fi
            song_pos=$(mpc playlist -f "%file%" | grep -nFx "$file_path" | cut -d: -f1 | head -n 1)
            
            if [ -n "$song_pos" ]; then
                mpc play "$song_pos" > /dev/null
            else
                mpc play > /dev/null
            fi
            
        elif [ "$STATE" = "album_songs" ]; then
            mpc clear > /dev/null
            mpc findadd album "$CURRENT_ALBUM" > /dev/null
            song_pos=$(mpc playlist -f "%file%" | grep -nFx "$file_path" | cut -d: -f1 | head -n 1)
            
            if [ -n "$song_pos" ]; then
                mpc play "$song_pos" > /dev/null
            else
                mpc play > /dev/null
            fi
            
        elif [ "$STATE" = "songs" ]; then
            mpc clear > /dev/null
            mpc add "$file_path" > /dev/null
            mpc play > /dev/null
        fi
        
        notify-send "$NOTIFY_TITLE" "Playing: ${CHOSEN:3}"
        exit 0
    fi
done
