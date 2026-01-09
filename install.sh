#!/bin/bash

# --- Colors (Catppuccin Mocha) ---
MAUVE="\033[38;2;203;166;247m"
LAVENDER="\033[38;2;180;190;254m"
GREEN="\033[38;2;166;227;161m"
PEACH="\033[38;2;250;179;135m"
RED="\033[38;2;243;139;168m"
BLUE="\033[38;2;137;180;250m"
FLAMINGO="\033[38;2;242;205;205m"
SUBTEXT="\033[38;2;166;173;200m"
RESET="\033[0m"

# --- Variables ---
REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/ConfigBackup/backup_$(date +%Y%m%d_%H%M%S)"
WALLPAPER_DEST="$HOME/Pictures/Catppuccin-Wallpapers"

# --- Package List (Force Reinstall Items) ---
PACKAGES=(
    "hyprland" "waybar" "swaync" "kitty" "hyprlock"
    "hypridle" "fastfetch" "zsh" "hyprshot" "ttf-jetbrains-mono-nerd"
    "awww-git" "vicinae-bin"
)

# --- Banner Function ---
show_banner() {
    clear
    echo -e "${MAUVE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  INSTALLING: $(echo $1 | tr '[:lower:]' '[:upper:]')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${RESET}"
}

msg() {
    echo -e "${BLUE}==>${RESET} ${LAVENDER}$1${RESET}"
}

# --- Step 1: Verification ---
clear
echo -e "${MAUVE}"
cat << "EOF"
{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
{}███╗   ███╗ ██████╗  ██████╗██╗  ██╗ █████╗      ██╗ ██████╗  ██╗ {}
{}████╗ ████║██╔═══██╗██╔════╝██║  ██║██╔══██╗    ███║██╔═████╗███║ {}
{}██╔████╔██║██║   ██║██║     ███████║███████║    ╚██║██║██╔██║╚██║ {}
{}██║╚██╔╝██║██║   ██║██║     ██╔══██║██╔══██║     ██║████╔╝██║ ██║ {}
{}██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║██║  ██║     ██║╚██████╔╝ ██║ {}
{}╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝ ╚═════╝  ╚═╝ {}
{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
EOF
echo -e "${RESET}"
echo -e "${MAUVE}::: Mocha101 - High Impact Force Install :::${RESET}\n"

read -p "$(echo -e ${PEACH}"Confirm Arch Linux System? (y/n): "${RESET})" confirm
[[ "$confirm" != [yY] ]] && exit 1

# --- Step 2: Yay Check ---
if ! command -v yay &> /dev/null; then
    show_banner "YAY HELPER"
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm && cd "$REPO_DIR"
fi

# --- Step 3: Force Installation Loop ---
echo -e "${LAVENDER}Preparing to force install components...${RESET}"
read -p "$(echo -e ${PEACH}"Begin Force Installation? (y/n): "${RESET})" proceed
[[ "$proceed" != [yY] ]] && exit 1

for pkg in "${PACKAGES[@]}"; do
    show_banner "$pkg"
    # Reinstalls even if already present
    yay -S --noconfirm "$pkg"
done

# --- Step 4: Configs & Wallpapers ---
show_banner "Wallpapers & Configs"
mkdir -p "$WALLPAPER_DEST"
[ -d "$REPO_DIR/Wallpapers" ] && cp -r "$REPO_DIR/Wallpapers/"* "$WALLPAPER_DEST/"

mkdir -p "$BACKUP_DIR"
CONFIGS=("hypr" "waybar" "kitty" "swaync" "customshscripts")

for folder in "${CONFIGS[@]}"; do
    if [ -d "$REPO_DIR/$folder" ]; then
        [ -d "$CONFIG_DIR/$folder" ] && mv "$CONFIG_DIR/$folder" "$BACKUP_DIR/"
        cp -r "$REPO_DIR/$folder" "$CONFIG_DIR/"
    fi
done

# --- Step 5: Shell Setup ---
show_banner "ZSH Setup"
read -p "$(echo -e ${PEACH}"Force Reinstall Oh My Zsh? (y/n): "${RESET})" zsh_confirm
if [[ "$zsh_confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Step 6: Final Instructions Banner ---
clear
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
clear