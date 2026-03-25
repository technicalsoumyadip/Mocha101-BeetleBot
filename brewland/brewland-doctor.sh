#!/bin/bash

# ==============================================================================
#  BREWLAND DOCTOR
# ==============================================================================

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
BLU='\033[0;34m'
RST='\033[0m'

echo -e "${BLU}:: Checking BrewLand Health...${RST}"

# 1. Check Packages
CHECK_PKGS=("hyprland" "waybar" "rofi" "swaync" "kitty" "swww" "fastfetch")
MISSING=0

echo -e "\n${YLW}[ 1/4 ] Verifying Core Dependencies...${RST}"
for pkg in "${CHECK_PKGS[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "  [ ${GRN}OK${RST} ] $pkg"
    else
        echo -e "  [ ${RED}!!${RST} ] $pkg is missing!"
        MISSING=$((MISSING + 1))
    fi
done

# 2. Check AUR
echo -e "\n${YLW}[ 2/4 ] Verifying AUR Helpers...${RST}"
if command -v yay &> /dev/null; then
    echo -e "  [ ${GRN}OK${RST} ] yay is installed."
else
    echo -e "  [ ${RED}!!${RST} ] yay is missing!"
    MISSING=$((MISSING + 1))
fi

# 3. Check Config Links
echo -e "\n${YLW}[ 3/4 ] Verifying Configuration Links...${RST}"
DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar")
for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    if [[ -d "$target" || -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            echo -e "  [ ${GRN}OK${RST} ] $folder (Symlinked)"
        else
            echo -e "  [ ${YLW}OK${RST} ] $folder (Standard Copy)"
        fi
    else
        echo -e "  [ ${RED}!!${RST} ] $folder is missing from ~/.config!"
        MISSING=$((MISSING + 1))
    fi
done

# 4. Check Services
echo -e "\n${YLW}[ 4/4 ] Verifying Active Services...${RST}"
SERVICES=("waybar" "swww" "hypridle" "swaync")
for svc in "${SERVICES[@]}"; do
    if pgrep -x "$svc" &> /dev/null; then
        echo -e "  [ ${GRN}OK${RST} ] $svc is running."
    else
        echo -e "  [ ${YLW}!!${RST} ] $svc is NOT running."
    fi
done

if pgrep -f "xdg-desktop-portal-hyprland" &> /dev/null; then
    echo -e "  [ ${GRN}OK${RST} ] xdg-desktop-portal-hyprland is running."
else
    echo -e "  [ ${RED}!!${RST} ] xdg-desktop-portal-hyprland is NOT running!"
    MISSING=$((MISSING + 1))
fi

echo -e "\n--------------------------------------------------"
if [[ $MISSING -eq 0 ]]; then
    echo -e "${GRN}BrewLand is healthy and ready to brew!${RST}"
else
    echo -e "${RED}BrewLand has $MISSING issues. Please run install.sh again.${RST}"
fi
echo "--------------------------------------------------"
