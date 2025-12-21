#!/bin/bash

# Define paths
RICE_DIR="/home/nkr/Documents/Rices/Mocha101"
CONFIG_DIR="/home/nkr/.config/"

# Array of folder names to sync
FOLDERS=("hypr" "kitty" "rofi" "swaync" "waybar")

echo "Starting config sync to Mocha101 rice..."

# Loop through each folder
for folder in "${FOLDERS[@]}"; do
    echo "Processing $folder..."
    
    # Delete folder from rice directory if it exists
    if [ -d "$RICE_DIR/$folder" ]; then
        echo "  Deleting old $folder from rice directory..."
        rm -rf "$RICE_DIR/$folder"
    fi
    
    # Copy folder from .config to rice directory
    if [ -d "$CONFIG_DIR/$folder" ]; then
        echo "  Copying $folder from .config..."
        cp -r "$CONFIG_DIR/$folder" "$RICE_DIR/"
        echo "  ✓ $folder synced successfully"
    else
        echo "  ⚠ Warning: $folder not found in .config"
    fi
    
    echo ""
done

# Delete backup folder inside kitty
KITTY_BACKUP="$RICE_DIR/kitty/backup"
if [ -d "$KITTY_BACKUP" ]; then
    echo "Deleting backup folder from kitty..."
    rm -rf "$KITTY_BACKUP"
    echo "  ✓ Backup folder deleted"
else
    echo "  ⚠ No backup folder found in kitty"
fi

echo ""
echo "Config sync complete!"
