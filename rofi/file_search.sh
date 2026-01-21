#!/usr/bin/env bash

NOTIFY_TITLE="File Search"

# --- THEME OVERRIDE ---
# We use @accent for the border color to keep it consistent with your main theme.
# If you want a specific color (like Green for files), replace @accent with that hex code.
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @accent;} element selected {background-color: @accent;} button selected {text-color: @accent;} textbox {text-color: @accent;}"

# 1. Check for fd
if ! command -v fd &> /dev/null; then
    notify-send "$NOTIFY_TITLE" "Error: 'fd' is not installed. Please install it."
    exit 1
fi

# 2. Launch Rofi with the file list
# We pipe fd directly into rofi to handle large file counts efficiently.
# --type f      : Only look for files (not directories)
# --hidden      : Search hidden files/dotfiles
# --exclude .git: Ignore git history folders (too much noise)
# --base-directory: Forces the output to be relative paths (cleaner look)

chosen=$(fd --type f --hidden --exclude .git --base-directory "$HOME" | \
    rofi -dmenu -i -p "Find" -theme-str "$THEME_OVERRIDE")

# 3. Handle Selection
if [ -n "$chosen" ]; then
    full_path="$HOME/$chosen"
    
    notify-send "$NOTIFY_TITLE" "Opening: $chosen"
    
    # Open the file and detach the process so closing the terminal/script doesn't kill the app
    xdg-open "$full_path" > /dev/null 2>&1 & disown
fi