#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/rofi/wallpaper_dir"
NOTIFY_TITLE="Wallpaper"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
fi

# --- THEMES ---

# 1. FILMSTRIP THEME (Geometric Fix)
# - window padding: 40px (The Master Frame)
# - element-text: Added 'expand: true' to force vertical centering
THEME_GALLERY="
    configuration { show-icons: true; } 
    window { 
        width: 90%; 
        border-color: @wallpaper; 
        anchor: center; location: center;
        /* The Master Frame: Exact 40px space all around */
        padding: 20px; 
    } 
    mainbox {
        background-color: transparent;
        children: [ listview ]; /* Force only listview, no hidden inputs taking space */
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
        expand: true; /* Forces text to consume remaining space and center itself */
        background-color: transparent;
    } 
    
    /* Colors */
    element selected { background-color: @wallpaper; } 
    textbox { text-color: @wallpaper; } 
"

# 2. FILE BROWSER THEME
THEME_PICKER="
    window { width: 40%; height: 50%; border-color: @wallpaper; }
    prompt { background-color: @wallpaper; text-color: @bg-col; }
    element selected { background-color: @wallpaper; }
    element-text { vertical-align: 0.5; }
    element-icon { size: 24px; }
"

# --- FUNCTIONS ---

pick_dir() {
    local current_dir="$HOME"
    while true; do
        dirs=$(find "$current_dir" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf "%f\n" | sort)
        options="  Use This Folder\n..\n$dirs"
        chosen=$(echo -e "$options" | rofi -dmenu -i -p "$current_dir" -theme-str "$THEME_PICKER")
        if [ -z "$chosen" ]; then exit 1
        elif [ "$chosen" == "  Use This Folder" ]; then echo "$current_dir"; return 0
        elif [ "$chosen" == ".." ]; then current_dir=$(dirname "$current_dir")
        else current_dir="$current_dir/$chosen"; fi
    done
}

# --- MAIN LOGIC ---

if [ ! -f "$CONFIG_FILE" ]; then
    INIT_DIR=$(pick_dir)
    if [ -n "$INIT_DIR" ]; then echo "$INIT_DIR" > "$CONFIG_FILE"; else exit; fi
fi

WALL_DIR=$(cat "$CONFIG_FILE")

# 2. Generate Gallery List
ROFI_LIST="Change the Directory\0icon\x1ffolder\n"

shopt -s nullglob
for img in "$WALL_DIR"/*.{jpg,jpeg,png,gif,webp,bmp}; do
    filename=$(basename "$img")
    ROFI_LIST+="$filename\0icon\x1f$img\n"
done

# 3. Launch
CHOSEN=$(echo -e "$ROFI_LIST" | rofi -dmenu -i -p "Wallpapers" -theme-str "$THEME_GALLERY")

# 4. Handle Selection
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