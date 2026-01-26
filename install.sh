#!/bin/bash

# ==============================================================================
#  MOCHA 101 INSTALLER (v2.2 - Fast Deploy)
# ==============================================================================

# get folder path
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG="$HOME/brewland_install.log"

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
CORE_PKGS=("hyprland" "waybar" "rofi" "rofimoji" "fd" "swaync" "hypridle" "hyprlock" "hyprpolkitagent" "xdg-desktop-portal-hyprland")
TOOL_PKGS=("swww" "fastfetch" "kitty" "cliphist" "wtype" "wl-clipboard" "jq" "fish" "thunar" "pavucontrol" "brightnessctl" "playerctl" "bluetui" "impala" "curl" "unzip" "grim" "slurp" "libpulse" "sound-theme-freedesktop")
YAY_PKGS=("grimblast-git" "hyprpicker")
DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "brewland" "fastfetch")

# ------------------------------------------------------
# HELPERS
# ------------------------------------------------------
separator() { echo -e "${B_MAG}================================================================================${RST}"; }
sub_separator() { echo -e "${BLK}--------------------------------------------------------------------------------${RST}"; }
info() { echo -e "${BLU}[ INFO ]${RST} $1"; }
ok() { echo -e "${GRN}[ OKAY ]${RST} $1"; }
fail() { echo -e "${RED}[ FAIL ]${RST} $1"; }
act() { echo -e "${CYN}[ ACTN ]${RST} $1"; }

# ------------------------------------------------------
# START
# ------------------------------------------------------
echo -e "${B_MAG}"
echo "  ██████╗ ██████╗ ███████╗██╗    ██╗██╗      █████╗ ███╗   ██╗██████╗ "
echo "  ██╔══██╗██╔══██╗██╔════╝██║    ██║██║     ██╔══██╗████╗  ██║██╔══██╗"
echo "  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║██║     ███████║██╔██╗ ██║██║  ██║"
echo "  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║██║     ██╔══██║██║╚██╗██║██║  ██║"
echo "  ██████╔╝██║  ██║███████╗╚███╔███╔╝███████╗██║  ██║██║ ╚████║██████╔╝"
echo "  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ "
echo -e "${RST}"
echo -e "  ${B_WHT}:: BREWLAND INSTALLER ::${RST}"
echo -e "  ${BLK}:: System Deployment v2.2 ::${RST}"
echo ""

read -p "  Start installation? (y/n) " choice
if [[ ! $choice =~ ^[Yy]$ ]]; then exit 1; fi

# --- PHASE 1: PRE-FLIGHT ---
echo ""
separator
echo -e " ${B_CYN}PHASE 1 : SYSTEM PRE-FLIGHT${RST}"
separator
act "Checking distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release

    if [[ "$ID" == "arch" || "$ID_LIKE" =~ "arch" ]]; then
        ok "Distro match: $PRETTY_NAME"
    else
        fail "Detected $PRETTY_NAME. This script requires an Arch-based system."
        exit 1
    fi
else
    fail "/etc/os-release not found. Cannot verify OS."
    exit 1
fi
act "Getting root power..."
sudo -v
ok "Root power active"

# --- PHASE 2: CORE INJECTION ---
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
# INSTALL YAY & AUR PKGS
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 2.1 : AUR HELPER${RST}"
separator

if command -v yay &> /dev/null; then
    ok "Yay is already installed."
else
    act "Yay not found."
    read -p "  Install 'yay' AUR helper? (y/n) " install_yay
    if [[ $install_yay =~ ^[Yy]$ ]]; then
        act "Installing dependencies (git, base-devel)..."
        sudo pacman -S --needed --noconfirm git base-devel >> "$LOG" 2>&1
        
        act "Cloning yay-bin..."
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin >> "$LOG" 2>&1
        
        act "Building yay..."
        cd /tmp/yay-bin || exit
        makepkg -si --noconfirm >> "$LOG" 2>&1
        cd ..
        rm -rf /tmp/yay-bin
        
        if command -v yay &> /dev/null; then
            ok "Yay installed successfully."
        else
            fail "Yay installation failed."
            exit 1
        fi
    else
        echo -e "${YLW}[ SKIP ]${RST} Skipping AUR setup."
    fi
fi

if command -v yay &> /dev/null; then
    echo ""
    separator
    echo -e " ${B_CYN}PHASE 2.2 : AUR ARSENAL${RST}"
    separator
    
    for pkg in "${YAY_PKGS[@]}"; do
        echo -ne "${BLU}[ .... ]${RST} Queuing $pkg..."
        sleep 0.1
        
        if pacman -Qi $pkg &> /dev/null; then
            echo -e "\r${YLW}[ SKIP ]${RST} $pkg already here."
        else
            echo -e "\r${CYN}[ INST ]${RST} Installing $pkg..."
            if yay -S --noconfirm --needed $pkg >> "$LOG" 2>&1; then
                echo -e "\r${GRN}[ DONE ]${RST} Installed $pkg successfully."
            else
                echo -e "\r${RED}[ ERR! ]${RST} Failed to install $pkg."
            fi
        fi
    done
fi

# ------------------------------------------------------
# FONT DEPLOYMENT
# ------------------------------------------------------

echo ""
separator
echo -e " ${B_CYN}PHASE 3: FONT DEPLOYMENT${RST}"
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
# DEPLOYMENT MODE SELECTION
# ------------------------------------------------------
echo ""
echo -e "${B_MAG}"
echo "  ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗"
echo "  ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝"
echo "  ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝ "
echo "  ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝  "
echo "  ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║   "
echo "  ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝   "
echo -e "${RST}"
echo -e "  ${B_WHT}:: SELECT DEPLOYMENT STRATEGY ::${RST}"
sub_separator
echo -e "  ${GRN}[1] STANDARD COPY${RST}  : Independent folders (Safe)"
echo -e "  ${CYN}[2] SYMLINK LINK${RST}   : Link directly to this Repo (Dev Mode)"
echo ""
read -p "  Selection (1/2): " deploy_mode

SYMLINK_ACTIVE=false
if [[ "$deploy_mode" == "2" ]]; then
    echo -e "${RED}  [ WARNING ]  ${B_WHT}SYMLINK MODE ACTIVE${RST}"
    echo -e "  If you ever delete this repo folder, your system config will BREAK."
    read -p "  Are you absolutely sure? (y/n) " sym_confirm1
    read -p "  REALLY sure? (y/n) " sym_confirm2
    if [[ $sym_confirm1 =~ ^[Yy]$ && $sym_confirm2 =~ ^[Yy]$ ]]; then SYMLINK_ACTIVE=true; ok "Symlink mode confirmed."; else
        fail "Aborted. Using Standard Copy."; SYMLINK_ACTIVE=false
    fi
elif [[ "$deploy_mode" != "1" ]]; then
    fail "Invalid selection. Exiting."; exit 1
fi

# ------------------------------------------------------
# PHASE 4 : AUTOMATIC MIGRATION (NO EXTRA CONFIRMATION)
# ------------------------------------------------------
echo ""
separator
echo -e " ${B_CYN}PHASE 4 : DOTFILE MIGRATION${RST}"
separator

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$HOME/ConfigBackups/$TIMESTAMP"
act "Creating vault at: $BACKUP_PATH"
mkdir -p "$BACKUP_PATH"

for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    source_folder="$SCRIPT_DIR/$folder"
    
    if [ -d "$target" ] || [ -L "$target" ]; then
        echo -e "${YLW}[ MOVE ]${RST} Archiving existing $folder..."
        cp -r "$target" "$BACKUP_PATH/"
        rm -rf "$target"
    fi
    
    if [ -d "$source_folder" ]; then
        if [ "$SYMLINK_ACTIVE" = true ]; then
            echo -e "${CYN}[ LINK ]${RST} Linking $folder -> $source_folder"
            ln -sf "$source_folder" "$HOME/.config/"
        else
            echo -e "${GRN}[ COPY ]${RST} Deploying $folder to system..."
            cp -r "$source_folder" "$HOME/.config/"
        fi
    else
        fail "Source folder $folder missing!"
    fi
done

# --- FINISH ---
echo ""
separator
echo -e " ${B_GRN}SYSTEM READY${RST}"
separator
echo -e "  ${B_WHT}Log File :${RST} $LOG"
echo -e "  ${B_WHT}Backup   :${RST} $BACKUP_PATH"
echo ""
read -n 1 -s -r -p "Press any key to exit..."
echo ""