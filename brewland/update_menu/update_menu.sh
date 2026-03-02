#!/bin/bash

# --- 1. Theme Detection ---
FLAVOR_FILE="$HOME/.config/swaync/current_flavor"
FLAVOR=$(cat "$FLAVOR_FILE" 2>/dev/null || echo "mocha")

# --- 2. Dynamic Catppuccin Colors ---
if [ "$FLAVOR" == "latte" ]; then
    # Catppuccin Latte Colors (ANSI 24-bit)
    MAUVE='\e[38;2;136;57;239m'
    BLUE='\e[38;2;30;102;245m'
    RED='\e[38;2;210;15;57m'
    GREEN='\e[38;2;64;160;43m'
    TEAL='\e[38;2;23;146;153m'
    PEACH='\e[38;2;254;100;11m'
else
    # Catppuccin Mocha Colors (ANSI 24-bit)
    MAUVE='\e[38;2;203;166;247m'
    BLUE='\e[38;2;137;180;250m'
    RED='\e[38;2;243;139;168m'
    GREEN='\e[38;2;166;227;161m'
    TEAL='\e[38;2;148;226;213m'
    PEACH='\e[38;2;250;179;135m'
fi
RESET='\e[0m'

# --- 3. Waybar Status Mode ---
if [ "$1" == "--status" ]; then
    arch=$(checkupdates 2>/dev/null | wc -l)
    aur=$(yay -Qu 2>/dev/null | wc -l)
    flat=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    total=$((arch + aur + flat))

    if [ "$total" -gt 0 ]; then
        printf '{"text": "%s", "class": "pending"}\n' "$total"
    else
        printf '{"text": "0", "class": "updated"}\n'
    fi
    exit 0
fi

# --- 4. Interactive Menu Mode ---
clear
fastfetch # Follows theme via theme_switcher.sh 

echo -e "${MAUVE}"
cat << "EOF"
   󰚰  S Y S T E M   U P D A T E S
   ─────────────────────────────
EOF
echo -e "${RESET}"

echo -e "${BLUE}󰣇 Fetching available updates...${RESET}"

PAC_LIST=$(checkupdates 2>/dev/null)
AUR_LIST=$(yay -Qu 2>/dev/null)
FLAT_LIST=$(flatpak remote-ls --updates 2>/dev/null)

echo -e "\n${TEAL}󰮯 [1] Pacman Updates:${RESET}"
if [ -n "$PAC_LIST" ]; then echo "$PAC_LIST"; else echo -e "${GREEN}No updates available${RESET}"; fi

echo -e "\n${MAUVE}󱓞 [2] AUR Updates:${RESET}"
if [ -n "$AUR_LIST" ]; then echo "$AUR_LIST"; else echo -e "${GREEN}No updates available${RESET}"; fi

echo -e "\n${GREEN}󰏆 [3] Flatpak Updates:${RESET}"
if [ -n "$FLAT_LIST" ]; then echo "$FLAT_LIST"; else echo -e "${GREEN}No updates available${RESET}"; fi

echo -e "\n${PEACH}──────────────────────────────────────────${RESET}"
echo -e "${BLUE}Select an action:${RESET}"
echo -e "  ${BLUE}1)${RESET} Update Pacman"
echo -e "  ${BLUE}2)${RESET} Update AUR"
echo -e "  ${BLUE}3)${RESET} Update Flatpak"
echo -e "  ${BLUE}4)${RESET} Update ${RED}ALL${RESET}"
echo -e "  ${RED}q)${RESET} Quit"
echo -ne "\n${PEACH}󰧚 Choice: ${RESET}"
read -r choice

case $choice in
    1) sudo pacman -Syu ;;
    2) yay -Syu ;;
    3) flatpak update ;;
    4) 
       echo -e "\n${RED}󱓞 Starting Full Update...${RESET}"
       sudo pacman -Syu && yay -Syu && flatpak update
       ;;
    *) exit ;;
esac

echo -e "\n${GREEN}󰄬 Process complete!${RESET}"
echo -e "${BLUE}Press Enter to close.${RESET}"
read -r
pkill -RTMIN+8 waybar