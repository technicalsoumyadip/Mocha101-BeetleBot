#!/bin/bash

# brewland uninstaller
# removes configurations from ~/.config

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
RST='\033[0m'

echo -e "${RED}!! brewland uninstaller !!${RST}"
echo -e "this will wipe brewland configs from ~/.config"
read -p "sure you want to do this? (y/n) " choice

if [[ ! $choice =~ ^[Yy]$ ]]; then
    exit 0
fi

DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "brewland" "fastfetch")

for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -e "${YLW}[ RM ]${RST} removing $target"
        rm -rf "$target"
    fi
done

echo -e "\n${GRN}brewland configs removed.${RST}"
echo -e "reinstall via install.sh or restore from ~/ConfigBackups"
