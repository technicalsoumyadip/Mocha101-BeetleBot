#!/bin/bash

# Catppuccin Mocha Colors
MAUVE='\033[0;35m'
FLAMINGO='\033[0;33m'
PEACH='\033[0;31m'
LAVENDER='\033[0;34m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
SUBTEXT='\033[0;37m'
RESET='\033[0m'

clear

# 1. Mocha101 ASCII Banner
echo -e "${MAUVE}"
echo "  __  __  ____   _____ _    _          _  ___  __ "
echo " |  \/  |/ __ \ / ____| |  | |   /\   / |/ _ \/_ |"
echo " | \  / | |  | | |    | |__| |  /  \  | | | | || |"
echo " | |\/| | |  | | |    |  __  | / /\ \ | | | | || |"
echo " | |  | | |__| | |____| |  | |/ ____ \| | |_| || |"
echo " |_|  |_|\____/ \_____|_|  |_/_/    \_\_|\___/ |_|"
echo -e "${RESET}"
echo -e "${FLAMINGO}      Brewed with Catppuccin Mocha${RESET}"
echo ""

# 2. Arch User Verification
read -p "Are you an Arch Linux user? (y/n): " is_arch

if [[ $is_arch != "y" && $is_arch != "Y" ]]; then
    echo -e "\n${PEACH}For non-Arch users, the configurations should be done manually.${RESET}"
    echo -e "${SUBTEXT}Please manually copy the following folders into your ~/.config folder:${RESET}"
    echo -e "${LAVENDER}  hypr, kitty, mpd, rmpc, swaync, vicinae, waybar${RESET}\n"
    
    echo -e "${GREEN}Required Dependencies to install manually:${RESET}"
    echo -e "1. Core: hyprland, waybar, swaync, hypridle, hyprlock, hyprpolkitagent, xdg-desktop-portal-hyprland/gnome"
    echo -e "2. Launcher: vicinae-bin"
    echo -e "3. Apps: kitty, nautilus, zen-browser, rmpc, pavucontrol"
    echo -e "4. Tools: hyprshot, grim, slurp, jq, wl-clipboard, brightnessctl, playerctl, awww-daemon"
    echo -e "5. Style: iMWritingMono Nerd Font Propo, Bibata-Modern-Ice cursor"
    echo ""
    read -n 1 -p "Press 'q' to exit the install..." exit_key
    exit 0
fi

# 3. Proceed with Arch Installation
echo -e "\n${GREEN}Detected Arch Linux. Starting automated installation...${RESET}"

# Install Yay if needed
if ! command -v yay &> /dev/null; then
    read -p "Yay (AUR Helper) not found. Install it now? (y/n): " install_yay
    if [[ $install_yay == "y" || $install_yay == "Y" ]]; then
        sudo pacman -S --needed base-devel git --noconfirm
        git clone https://aur.archlinux.org/yay.git
        cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
    else
        echo -e "${PEACH}Yay is required for AUR dependencies. Exiting.${RESET}"
        exit 1
    fi
fi

# 4. Install Dependencies
echo -e "\n${MAUVE}Installing dependencies...${RESET}"

# Official Repos
sudo pacman -S --needed \
    hyprland waybar swaynotificationcenter hypridle hyprlock \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gnome \
    kitty nautilus pavucontrol grim slurp jq wl-clipboard \
    brightnessctl playerctl fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt \
    --noconfirm

# AUR Repos
yay -S --needed \
    hyprpolkitagent-git vicinae-bin zen-browser-bin rmpc-bin \
    hyprshot-git awww-daemon-bin bibata-cursor-theme \
    --noconfirm

# 5. Backup and Configuration Deployment
echo -e "\n${BLUE}Backing up existing configs...${RESET}"
BACKUP_DIR="$HOME/ConfigBackup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

CONFIG_FOLDERS=("hypr" "kitty" "mpd" "rmpc" "swaync" "vicinae" "waybar")

for folder in "${CONFIG_FOLDERS[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        mv "$HOME/.config/$folder" "$BACKUP_DIR/"
        echo -e "  - Backed up $folder to $BACKUP_DIR"
    fi
    # Copy from repo folder to ~/.config/
    if [ -d "./$folder" ]; then
        cp -r "./$folder" "$HOME/.config/"
        echo -e "  - Installed $folder to ~/.config/"
    fi
done

# Copy walls.sh to home
if [ -f "./walls.sh" ]; then
    cp "./walls.sh" "$HOME/"
    chmod +x "$HOME/walls.sh"
fi

# 6. Fish Shell Prompt
read -p "Do you want to install the Fish shell? (y/n): " install_fish
if [[ $install_fish == "y" || $install_fish == "Y" ]]; then
    sudo pacman -S fish --noconfirm
    echo -e "${GREEN}Fish installed. Use 'chsh -s /usr/bin/fish' to make it default.${RESET}"
fi

# 7. Success Banner
echo -e "\n"
echo -e "${MAUVE}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET}"
echo -e "${MAUVE}┃${RESET}   ${FLAMINGO}✨ MOCHA101 INSTALLED SUCCESSFULLY! ✨${RESET}                           ${MAUVE}┃${RESET}"
echo -e "${MAUVE}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET}"
echo -e "  ${SUBTEXT}To complete your setup and have the best experience, follow these steps:${RESET}"
echo ""
echo -e "  ${PEACH}1. ACTIVATE VICINAE EXTENSIONS${RESET}"
echo -e "     ${LAVENDER}Open your Vicinae Settings and enable the following:${RESET}"
echo -e "     ${GREEN}󰖩  Wifi Commander${RESET}  ${SUBTEXT}(For network management via Waybar)${RESET}"
echo -e "     ${GREEN}󰂯  Bluetooth${RESET}       ${SUBTEXT}(For device management via Waybar)${RESET}"
echo -e "     ${GREEN}  AWWW Switcher${RESET}    ${SUBTEXT}(For the wallpaper picker interface)${RESET}"
echo ""
echo -e "  ${PEACH}2. REWIRE YOUR KEYBINDS${RESET}"
echo -e "     ${LAVENDER}Open ${BLUE}~/.config/hypr/HLconfigs/keybindings.conf${LAVENDER} to customize binds.${RESET}"
echo ""
echo -e "  ${PEACH}3. REBOOT SYSTEM${RESET}"
echo -e "     ${LAVENDER}A reboot is required to initialize the environment properly.${RESET}"
echo ""
echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  ${SUBTEXT}For a full keybind list, visit the repository:${RESET}"
echo -e "  ${GREEN}GitHub: https://github.com/BeetleBot/Mocha101${RESET}"
echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${PEACH}Press any key to finish and exit...${RESET}"
read -n 1 -s
echo -e "\n${FLAMINGO}Happy Ricing!${RESET}"