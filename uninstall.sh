#!/bin/bash

# ==============================================================================
#  BREWLAND UNINSTALLER
# ==============================================================================

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
RST='\033[0m'

echo -e "${RED}!!! BREWLAND UNINSTALLER !!!${RST}"
echo -e "This will remove BrewLand configurations from ~/.config/"
read -p "Are you sure you want to proceed? (y/n) " choice

if [[ ! $choice =~ ^[Yy]$ ]]; then
    exit 0
fi

DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "brewland" "fastfetch")

for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -e "${YLW}[ RM ]${RST} Removing $target..."
        rm -rf "$target"
    fi
done

echo -e "\n${GRN}BrewLand has been uninstalled.${RST}"
echo -e "Note: Packages installed via pacman/yay were not removed."
echo -e "You may want to restore your backups from ~/ConfigBackups/"
