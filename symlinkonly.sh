#!/bin/bash

# ==============================================================================
#  DEV SYMLINKER (FOR MAINTAINER USE ONLY)
# ==============================================================================

# 1. Define the folders you want to link
# (These must exist in your repo folder)
DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "fastfetch" "brewland")

# 2. Get Paths
REPO_DIR=$(pwd)
CONFIG_DIR="$HOME/.config"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/ConfigBackups/Dev_Link_$TIMESTAMP"

echo -e "\033[1;35m:: SYMLINKER ACTIVATED ::\033[0m"
echo "   Source (Repo): $REPO_DIR"
echo "   Target (Sys):  $CONFIG_DIR"
echo "   Backup Loc:    $BACKUP_DIR"
echo ""

# 3. Create Backup Directory
mkdir -p "$BACKUP_DIR"

# 4. Loop through folders
for folder in "${DOTFILES[@]}"; do
    target="$CONFIG_DIR/$folder"
    source="$REPO_DIR/$folder"

    # Check if source exists in repo
    if [ ! -d "$source" ]; then
        echo -e "\033[0;31m[ SKIP ]\033[0m $folder not found in current directory."
        continue
    fi

    # Check if target exists (folder or link)
    if [ -d "$target" ] || [ -L "$target" ]; then
        echo -e "\033[0;33m[ MOVE ]\033[0m Backing up existing $folder..."
        mv "$target" "$BACKUP_DIR/"
    fi

    # Create the Symlink
    echo -e "\033[0;32m[ LINK ]\033[0m Linking $folder -> $source"
    ln -sf "$source" "$target"
done

echo ""
echo -e "\033[1;32m:: DONE ::\033[0m"
echo "Your system is now using the config files directly from this folder."