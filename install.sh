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

# Define directories
REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/ConfigBackup"
WALLPAPER_DEST="$HOME/Pictures/Catppuccin-Wallpapers"

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
echo -e "${MAUVE}::: Mocha101 Installation Script :::${RESET}"
echo -e "${LAVENDER}This script is designed specifically for Arch Linux.${RESET}"
echo ""
read -p "$(echo -e ${PEACH}"Are you running this on Arch Linux? (y/n): "${RESET})" confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${RED}Installation aborted. This script is intended for Arch Linux only.${RESET}"
    exit 1
fi

# --- Step 2: Install Yay ---
if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}==> Installing yay...${RESET}"
    sudo pacman -S --needed git base-devel -y
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# --- Step 3: Selective Dependency Installation ---
echo -e "${BLUE}==> Dependency Selection${RESET}"
PACKAGES=(
    "hyprland" "waybar" "hyprpaper" "swaync" "kitty" "hyprlock"
    "hypridle" "fastfetch" "zsh" "hyprshot" "ttf-jetbrains-mono-nerd"
    "awww-git" "vicinae-bin"
)

for i in "${!PACKAGES[@]}"; do
    printf "${MAUVE}%2d)${RESET} %-25s" "$((i+1))" "${PACKAGES[$i]}"
    [[ $(( (i+1) % 2 )) -eq 0 ]] && echo ""
done
echo -e "\n${MAUVE}$(( ${#PACKAGES[@]} + 1 )))${RESET} ${GREEN}Force install all packages (Recommended)${RESET}"

echo ""
read -p "Enter your choices (separated by space): " user_choices

TO_INSTALL=()
FORCE_ALL=false
for choice in $user_choices; do
    if [[ "$choice" -eq "$(( ${#PACKAGES[@]} + 1 ))" ]]; then FORCE_ALL=true; break; fi
    [[ "$choice" -gt 0 && "$choice" -le "${#PACKAGES[@]}" ]] && TO_INSTALL+=("${PACKAGES[$((choice-1))]}")
done

if [ "$FORCE_ALL" = true ]; then
    yay -S --noconfirm "${PACKAGES[@]}"
    INSTALL_SUMMARY="All dependencies force installed."
elif [ ${#TO_INSTALL[@]} -gt 0 ]; then
    yay -S --needed --noconfirm "${TO_INSTALL[@]}"
    INSTALL_SUMMARY="${#TO_INSTALL[@]} specific packages installed."
else
    INSTALL_SUMMARY="No packages were selected for installation."
fi

# --- Step 4: Setup Wallpapers ---
mkdir -p "$WALLPAPER_DEST"
if [ -d "$REPO_DIR/Wallpapers" ]; then
    cp -r "$REPO_DIR/Wallpapers/"* "$WALLPAPER_DEST/"
fi

# --- Step 5: Backup & Install Configs ---
CONFIGS=("hypr" "waybar" "kitty" "rofi" "swaync" "customshscripts")
mkdir -p "$BACKUP_DIR"
for folder in "${CONFIGS[@]}"; do
    TARGET="$CONFIG_DIR/$folder"
    SOURCE="$REPO_DIR/$folder"
    if [ -d "$SOURCE" ]; then
        [ -d "$TARGET" ] && mv "$TARGET" "$BACKUP_DIR/${folder}_$(date +%Y%m%d_%H%M%S)"
        cp -r "$SOURCE" "$CONFIG_DIR/"
    fi
done

# --- Step 6: Oh My Zsh ---
ZSH_STATUS="Skipped"
read -p "$(echo -e ${PEACH}"Install Oh My Zsh? (y/n): "${RESET})" zsh_confirm
if [[ "$zsh_confirm" =~ ^[Yy]$ ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ZSH_STATUS="Installed Successfully"
fi

# --- Final Beautiful Summary ---
clear
echo -e "${MAUVE}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET}"
echo -e "${MAUVE}┃${RESET}  ${FLAMINGO}✨ MOCHA101 INSTALLATION COMPLETE ✨${RESET}                      ${MAUVE}┃${RESET}"
echo -e "${MAUVE}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET}"
echo -e "  ${SUBTEXT}The following tasks were completed successfully:${RESET}"
echo ""
echo -e "  ${BLUE}  Packages:${RESET}     ${LAVENDER}$INSTALL_SUMMARY${RESET}"
echo -e "  ${BLUE}  Wallpapers:${RESET}   ${LAVENDER}Deployed to ~/Pictures/Catppuccin-Wallpapers${RESET}"
echo -e "  ${BLUE}󰒓  Configs:${RESET}      ${LAVENDER}Installed to ~/.config/ (Backups in ~/ConfigBackup)${RESET}"
echo -e "  ${BLUE}📜 Scripts:${RESET}      ${LAVENDER}walls.sh is now ready in your Home directory${RESET}"
echo -e "  ${BLUE}󰚚  Shell:${RESET}        ${LAVENDER}Oh My Zsh: $ZSH_STATUS${RESET}"
echo ""
echo -e "  ${SUBTEXT}Please make sure to install these extensions from Vicinae${RESET}"
echo ""
echo -e "  ${BLUE}: Wifi Commander ${RESET}     ${LAVENDER}$ For Wifi keybindings and waybar ${RESET}"
echo -e "  ${BLUE}: Bluetooth ${RESET}     ${LAVENDER}$ For Bluetooth keybindings and waybar ${RESET}"
echo -e "  ${BLUE}: AWWW SWITCHER ${RESET}     ${LAVENDER}$ For wallpaper picker via keybinding ${RESET}"
echo ""
echo -e "  ${GREEN}Check the README for keybindings: https://github.com/BeetleBot/Mocha101${RESET}"
echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

echo -e "             ${PEACH}Please reboot your system to apply all changes!${RESET}"
echo ""