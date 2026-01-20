#!/bin/bash

# ==============================================================================
#  MOCHA 101 INSTALLER
# ==============================================================================

# get folder path
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG="$HOME/mocha_install.log"

# clear log file
echo "" > "$LOG"

# ------------------------------------------------------
# COLORS (Catppuccin Mocha)
# ------------------------------------------------------
BLK='\033[0;30m'
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
BLU='\033[0;34m'
MAG='\033[0;35m'
CYN='\033[0;36m'
WHT='\033[0;37m'
B_MAG='\033[1;35m'
B_CYN='\033[1;36m'
B_WHT='\033[1;37m'
RST='\033[0m'

# ------------------------------------------------------
# LISTS
# ------------------------------------------------------

# main apps
CORE_PKGS=(
    "hyprland" 
    "waybar" 
    "rofi" 
    "rofimoji" 
    "fd" 
    "swaync" 
    "hypridle" 
    "hyprlock" 
    "hyprpolkitagent" 
    "xdg-desktop-portal-hyprland"
)

# tools and utils
TOOL_PKGS=(
    "swww"
    "kitty" 
    "wl-clipboard" 
    "cliphist" 
    "wtype" 
    "jq" 
    "fish" 
    "thunar" 
    "pavucontrol" 
    "brightnessctl" 
    "playerctl" 
    "curl" 
    "unzip"
    "hyprshot"
    "grim"
    "slurp"
)

# folders to move
DOTFILES=(
    "hypr" 
    "kitty" 
    "rofi" 
    "swaync" 
    "waybar" 
    "fish"
)

# ------------------------------------------------------
# HELPERS
# ------------------------------------------------------

# print big line
separator() {
    echo -e "${B_MAG}================================================================================${RST}"
}

# print small line
sub_separator() {
    echo -e "${BLK}--------------------------------------------------------------------------------${RST}"
}

# show info
info() {
    echo -e "${BLU}[ INFO ]${RST} $1"
}

# show success
ok() {
    echo -e "${GRN}[ OKAY ]${RST} $1"
}

# show fail
fail() {
    echo -e "${RED}[ FAIL ]${RST} $1"
}

# show action
act() {
    echo -e "${CYN}[ ACTN ]${RST} $1"
}

# ------------------------------------------------------
# START
# ------------------------------------------------------

clear
echo -e "${B_MAG}"
echo "  ███╗   ███╗ ██████╗  ██████╗██╗  ██╗ █████╗      ██╗ ██████╗  ██╗"
echo "  ████╗ ████║██╔═══██╗██╔════╝██║  ██║██╔══██╗    ███║██╔═████╗███║"
echo "  ██╔████╔██║██║   ██║██║     ███████║███████║    ╚██║██║██╔██║╚██║"
echo "  ██║╚██╔╝██║██║   ██║██║     ██╔══██║██╔══██║     ██║████╔╝██║ ██║"
echo "  ██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║██║  ██║     ██║╚██████╔╝ ██║"
echo "  ╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝ ╚═════╝  ╚═╝"
echo -e "${RST}"
echo -e "  ${B_WHT}:: MOCHA 101 INSTALLER ::${RST}"
echo -e "  ${BLK}:: Installation Script v4.0 ::${RST}"
echo ""

# ask user start
read -p "  Start installation? (y/n) " choice
if [[ ! $choice =~ ^[Yy]$ ]]; then
    exit 1
fi

echo ""
separator
echo -e " ${B_CYN}PHASE 1 : SYSTEM PRE-FLIGHT${RST}"
separator

# check arch linux
act "Checking distribution..."
if grep -q "Arch" /etc/os-release; then
    ok "Distro match: Arch Linux"
else
    fail "Not Arch Linux. Stopping."
    exit 1
fi

# refresh sudo
act "Getting root power..."
sudo -v
ok "Root power active"

# ------------------------------------------------------
# INSTALL PACKAGES
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 2 : CORE INJECTION${RST}"
separator

# update pacman first
act "Refreshing package database..."
sudo pacman -Sy --noconfirm >> "$LOG" 2>&1

# loop install core
for pkg in "${CORE_PKGS[@]}"; do
    echo -ne "${BLU}[ .... ]${RST} Queuing $pkg..."
    sleep 0.1 
    
    # check if installed
    if pacman -Qi $pkg &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg already here."
    else
        echo -e "\r${CYN}[ INST ]${RST} Installing $pkg..."
        if sudo pacman -S --noconfirm --needed $pkg >> "$LOG" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} Installed $pkg successfully."
        else
            echo -e "\r${RED}[ ERR! ]${RST} Failed to install $pkg."
        fi
    fi
done

# loop install tools
sub_separator
echo -e " ${B_WHT}:: Installing Utilities ::${RST}"
sub_separator

for pkg in "${TOOL_PKGS[@]}"; do
    echo -ne "${BLU}[ .... ]${RST} Queuing $pkg..."
    sleep 0.1
    
    if pacman -Qi $pkg &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg already here."
    else
        echo -e "\r${CYN}[ INST ]${RST} Installing $pkg..."
        if sudo pacman -S --noconfirm --needed $pkg >> "$LOG" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} Installed $pkg successfully."
        else
            echo -e "\r${RED}[ ERR! ]${RST} Failed to install $pkg."
        fi
    fi
done

# ------------------------------------------------------
# FONT DEPLOYMENT
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 4.5 : FONT DEPLOYMENT${RST}"
separator

FONT_DIR="$HOME/.local/share/fonts"
SOURCE_FONTS="$SCRIPT_DIR/Fonts"

act "Preparing font vault..."
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
    ok "Created $FONT_DIR"
fi

if [ -d "$SOURCE_FONTS" ]; then
    act "Injecting fonts into system..."
    # Using -u to only copy if source is newer or doesn't exist
    cp -ru "$SOURCE_FONTS"/* "$FONT_DIR/"
    
    act "Rebuilding font cache (this may take a moment)..."
    fc-cache -f
    ok "Font library updated and indexed."
else
    fail "Source fonts folder NOT found in $SCRIPT_DIR/fonts"
fi



# ------------------------------------------------------
# BACKUP AND COPY
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 4 : DOTFILE MIGRATION${RST}"
separator

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$HOME/ConfigBackups/$TIMESTAMP"

# safety check block
echo -e "${YLW}  [ WAIT ]  ${B_WHT}SAFETY CHECKPOINT${RST}"
echo -e "  ------------------------------------------------"
echo -e "  Current config files will be moved to:"
echo -e "  ${B_CYN}$BACKUP_PATH${RST}"
echo -e "  New elite configs will replace them."
echo ""
read -p "  Proceed with deployment? (y/n) " confirm

# check answer
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo ""
    fail "User aborted. No files changed."
    echo -e "${B_WHT}  Exiting safe mode.${RST}"
    exit 0
fi

# if yes continue
act "Creating vault at: $BACKUP_PATH"
mkdir -p "$BACKUP_PATH"

# loop copy files
for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    
    if [ -d "$target" ]; then
        # backup old
        echo -e "${YLW}[ MOVE ]${RST} Archiving existing $folder..."
        cp -r "$target" "$BACKUP_PATH/"
        
        # delete old
        rm -rf "$target"
    fi
    
    # copy new
    source_folder="$SCRIPT_DIR/$folder"
    if [ -d "$source_folder" ]; then
        echo -e "${GRN}[ COPY ]${RST} Deploying $folder to system..."
        cp -r "$source_folder" "$HOME/.config/"
    else
        fail "Source folder $folder missing!"
    fi
done

# ------------------------------------------------------
# SCRIPTS
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 5 : SCRIPT EXECUTABLES${RST}"
separator

SCRIPT_DEST="$HOME/myscripts"
THEME_SCRIPT="$SCRIPT_DIR/customshscripts/personal scripts/theme_switcher.sh"

act "Initializing $SCRIPT_DEST..."
mkdir -p "$SCRIPT_DEST"

if [ -f "$THEME_SCRIPT" ]; then
    act "Copying theme logic..."
    cp "$THEME_SCRIPT" "$SCRIPT_DEST/theme_switcher.sh"
    chmod +x "$SCRIPT_DEST/theme_switcher.sh"
    ok "Theme Switcher operational."
else
    fail "Theme Switcher script missing."
fi

# ------------------------------------------------------
# DONE
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_GRN}SYSTEM READY${RST}"
separator
echo -e "  ${B_WHT}Log File :${RST} $LOG"
echo -e "  ${B_WHT}Backup   :${RST} $BACKUP_PATH"
echo ""
echo -e "  ${CYN}Please restart Hyprland to apply visual effects.${RST}"
echo ""
read -n 1 -s -r -p "Press any key to exit..."
echo ""
