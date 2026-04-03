#!/usr/bin/env bash

# wallpaper gallery for rofi
# uses awww-daemon to set wallpapers with transitions

CONFIG_FILE="$HOME/.config/rofi/wallpaper_dir"
NOTIFY_TITLE="Wallpaper"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
fi

# wide gallery view for wallpapers
THEME_GALLERY="
    configuration { show-icons: true; } 
    window { width: 90%; anchor: center; location: center; padding: 20px; } 
    mainbox { background-color: transparent; children: [ inputbar, listview ]; }
    entry { placeholder: \"Wallpapers...\"; }
    listview { 
        margin: 10px 0px 0px 0px;
        columns: 6; lines: 1; 
        flow: horizontal;
        fixed-height: true; fixed-columns: true; 
        cycle: false; layout: vertical;
        spacing: 20px;
        background-color: transparent;
    } 
    element { orientation: vertical; padding: 20px; spacing: 15px; border-radius: 12px; } 
    element-icon { enabled: true; size: 200px; horizontal-align: 0.5; background-color: transparent; } 
    element-text { horizontal-align: 0.5; vertical-align: 0.5; expand: true; background-color: transparent; } 
    element selected { background-color: @wallpaper; } 
    textbox { text-color: @wallpaper; } 
"

pick_dir() {
    local script_dir=$(dirname "$(readlink -f "$0")")
    local result=$("$script_dir/dir_picker.sh" "$HOME")
    if [ $? -eq 0 ]; then
        echo "$result"
    else
        exit 1
    fi
}

# check for directory config
if [ ! -f "$CONFIG_FILE" ]; then
    INIT_DIR=$(pick_dir)
    if [ -n "$INIT_DIR" ]; then echo "$INIT_DIR" > "$CONFIG_FILE"; else exit; fi
fi

WALL_DIR=$(cat "$CONFIG_FILE")

config_dir="$HOME/.config/rofi"
[ ! -d "$config_dir" ] && config_dir="$(dirname "$(readlink -f "$0")")/.."

# build the list for rofi
ROFI_LIST="Change the Directory\0icon\x1ffolder\n"
shopt -s nullglob
for img in "$WALL_DIR"/*.{jpg,jpeg,png,gif,webp,bmp}; do
    filename=$(basename "$img")
    ROFI_LIST+="$filename\0icon\x1f$img\n"
done

ROFI_LIST=$(echo "$ROFI_LIST" | sed 's/\\n$//')
CHOSEN=$(echo -e -n "$ROFI_LIST" | rofi -dmenu -i -p "Wallpapers" -theme "$config_dir/base.rasi" -theme-str "$THEME_GALLERY")

if [ -z "$CHOSEN" ]; then
    exit
elif [ "$CHOSEN" == "Change the Directory" ]; then
    NEW_DIR=$(pick_dir)
    if [ -n "$NEW_DIR" ]; then
        echo "$NEW_DIR" > "$CONFIG_FILE"
        exec "$0"
    fi
else
    FULL_PATH="$WALL_DIR/$CHOSEN"
    notify-send "$NOTIFY_TITLE" "Setting wallpaper..."
    awww img "$FULL_PATH" --transition-type grow --transition-step 90 --transition-fps 60
fi
