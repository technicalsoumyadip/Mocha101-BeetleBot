#!/usr/bin/env bash

# find rofi configs - check standard location or fallback to script's parent
dir="$HOME/.config/rofi"
if [ ! -d "$dir" ]; then
    dir="$(dirname "$(readlink -f "$0")")/.."
fi

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

# Use the default app launcher config (config.rasi) as requested
chosen=$(echo -e "$menu_items" | rofi -dmenu -i -p "Hyprsession " -theme "$dir/config.rasi")

case "$chosen" in
    "$MENU_ADD")
        new_session=$(rofi -dmenu -p "New Session Name: " -theme "$dir/config.rasi")
        if [ -n "$new_session" ]; then
            hyprsession save "$new_session"
            notify-send -a "Hyprsession" "Session Saved" "Successfully saved session: $new_session"
        fi
        ;;
    "$MENU_DEL")
        if [ -z "$sessions" ]; then
            notify-send -a "Hyprsession" "Error" "No sessions to remove"
            exit 1
        fi
        # We need to make sure the user only selects from valid sessions,
        # but we can just use the same list format.
        to_remove=$(echo "$sessions" | rofi -dmenu -i -p "Remove Session: " -theme "$dir/config.rasi")
        if [ -n "$to_remove" ]; then
            hyprsession delete "$to_remove"
            notify-send -a "Hyprsession" "Session Deleted" "Successfully deleted session: $to_remove"
        fi
        ;;
    "No sessions found"|"")
        exit 0
        ;;
    *)
        hyprsession load "$chosen"
        ;;
esac
