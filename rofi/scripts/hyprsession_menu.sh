#!/usr/bin/env bash

# hyprsession menu to save/load/delete windows
dir="$HOME/.config/rofi"
[ ! -d "$dir" ] && dir="$(dirname "$(readlink -f "$0")")/.."

get_sessions() {
    hyprsession list | awk '/^ - / {print $2}'
}

MENU_ADD="󰐕  ADD SESSION"
MENU_DEL="󰆴  REMOVE SESSION"

sessions=$(get_sessions)
if [ -z "$sessions" ]; then
    menu_items="$MENU_ADD\n$MENU_DEL\nNo sessions found"
else
    menu_items="$MENU_ADD\n$MENU_DEL\n$sessions"
fi

chosen=$(echo -e "$menu_items" | rofi -dmenu -i -p "Hyprsession " -theme "$dir/config.rasi")

case "$chosen" in
    "$MENU_ADD")
        new_session=$(rofi -dmenu -p "New Session Name: " -theme "$dir/config.rasi")
        if [ -n "$new_session" ]; then
            hyprsession save "$new_session"
            notify-send -a "Hyprsession" "Session Saved" "Success: $new_session"
        fi
        ;;
    "$MENU_DEL")
        if [ -n "$sessions" ]; then
            to_remove=$(echo "$sessions" | rofi -dmenu -i -p "Remove Session: " -theme "$dir/config.rasi")
            if [ -n "$to_remove" ]; then
                hyprsession delete "$to_remove"
                notify-send -a "Hyprsession" "Session Deleted" "Deleted: $to_remove"
            fi
        else
            notify-send -a "Hyprsession" "Error" "No sessions to remove"
        fi
        ;;
    "No sessions found"|"")
        exit 0
        ;;
    *)
        hyprsession load "$chosen"
        ;;
esac
