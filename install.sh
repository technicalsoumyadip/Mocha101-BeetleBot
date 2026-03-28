#!/bin/bash

# ==============================================================================
#  BREWLAND INSTALLER (v2.5 - Enhanced reliability)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SETUP & PATHS
# ------------------------------------------------------------------------------
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG_FILE="$HOME/brewland_install.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/ConfigBackups/$TIMESTAMP"
FAILED_ACTIONS=()

# Set exit on error (optional, but good for critical parts)
# set -e 

# Initial log cleanup
echo "--- BrewLand Install Log: $TIMESTAMP ---" > "$LOG_FILE"

# ------------------------------------------------------------------------------
# 2. COLORS & UI
# ------------------------------------------------------------------------------
# Catppuccin Mocha Palette
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

# Helpers
separator() { echo -e "${B_MAG}================================================================================${RST}"; }
sub_separator() { echo -e "${MAG}--------------------------------------------------------------------------------${RST}"; }
info() { echo -e "${BLU}[ INFO ]${RST} $1"; }
ok() { echo -e "${GRN}[ OKAY ]${RST} $1"; }
fail() { echo -e "${RED}[ FAIL ]${RST} $1"; FAILED_ACTIONS+=("$1"); }
act() { echo -e "${CYN}[ ACTN ]${RST} $1"; }
warn() { echo -e "${YLW}[ WARN ]${RST} $1"; }

# ------------------------------------------------------------------------------
# 3. PACKAGE LISTS
# ------------------------------------------------------------------------------
CORE_PKGS=("hyprland" "waybar" "rofi" "iwd" "swaync" "hypridle" "hyprlock" "hyprpolkitagent" "xdg-desktop-portal-hyprland" "libpulse" "sound-theme-freedesktop")
TOOL_PKGS=("kitty" "thunar" "mpd-mpris" "fish" "awww" "fastfetch" "rofimoji" "fd" "cliphist" "wl-clipboard" "wtype" "kvantum" "qt5ct" "qt6ct" "jq" "curl" "unzip" "pavucontrol" "brightnessctl" "playerctl" "bluetui" "impala" "grim" "slurp" "tumbler" "ffmpegthumbnailer" "poppler-glib" "libgsf" "libopenraw" "freetype2")
YAY_PKGS=("grimblast-git" "hyprpicker" "kvantum-theme-catppuccin-git")
DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "brewland" "fastfetch" "brew-task")

# ------------------------------------------------------------------------------
# 4. CORE FUNCTIONS
# ------------------------------------------------------------------------------

# Install package via pacman
install_pacman() {
    local pkg=$1
    echo -ne "${BLU}[ .... ]${RST} Checking $pkg..."
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg is already installed."
    else
        echo -e "\r${CYN}[ INST ]${RST} Installing $pkg..."
        if sudo pacman -S --noconfirm --needed "$pkg" >> "$LOG_FILE" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} Installed $pkg successfully."
        else
            echo -e "\r${RED}[ ERR! ]${RST} Failed to install $pkg. Check $LOG_FILE"
            FAILED_ACTIONS+=("Pacman: $pkg")
        fi
    fi
}

# Install package via yay
install_yay() {
    local pkg=$1
    echo -ne "${BLU}[ .... ]${RST} Checking $pkg (AUR)..."
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg is already installed."
    else
        echo -e "\r${CYN}[ INST ]${RST} Installing $pkg via yay..."
        if yay -S --noconfirm --needed "$pkg" >> "$LOG_FILE" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} Installed $pkg successfully."
        else
            echo -e "\r${RED}[ ERR! ]${RST} Failed to install $pkg. Check $LOG_FILE"
            FAILED_ACTIONS+=("Yay: $pkg")
        fi
    fi
}

# ------------------------------------------------------------------------------
# 5. PRE-FLIGHT CHECK
# ------------------------------------------------------------------------------
pre_flight() {
    separator
    echo -e " ${B_CYN}PHASE 1 : SYSTEM PRE-FLIGHT${RST}"
    separator

    act "Checking internet connectivity..."
    if ping -q -c 1 -W 1 google.com &>/dev/null; then
        ok "Internet connection active."
    else
        fail "No internet connection detected. Please connect and try again."
        exit 1
    fi

    act "Checking OS compatibility..."
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
            ok "Compatible OS detected: ${B_WHT}${PRETTY_NAME}${RST}"
        else
            fail "Incompatible OS: ${PRETTY_NAME:-$ID}"
            exit 1
        fi
    else
        fail "Cannot determine OS. /etc/os-release is missing."
        exit 1
    fi

    if [[ "$EUID" -eq 0 ]]; then
        fail "Do not run this script as root! Run it as your normal user."
        exit 1
    fi

    act "Validating sudo access..."
    if sudo -v; then
        ok "Sudo power active."
    else
        fail "Sudo access required for installation."
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# 6. EXECUTION MODES
# ------------------------------------------------------------------------------
if [[ "$1" == "--check" ]]; then
    pre_flight
    info "System check complete. Ready for BrewLand deployment."
    exit 0
fi

# Banner
echo -e "${B_MAG}"
echo "  ██████╗ ██████╗ ███████╗██╗    ██╗██╗      █████╗ ███╗   ██╗██████╗ "
echo "  ██╔══██╗██╔══██╗██╔════╝██║    ██║██║     ██╔══██╗████╗  ██║██╔══██╗"
echo "  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║██║     ███████║██╔██╗ ██║██║  ██║"
echo "  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║██║     ██╔══██║██║╚██╗██║██║  ██║"
echo "  ██████╔╝██║  ██║███████╗╚███╔███╔╝███████╗██║  ██║██║ ╚████║██████╔╝"
echo "  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ "
echo -e "${RST}"
echo -e "  ${B_WHT}:: BREWLAND v2.5 INSTALLER ::${RST}"
echo -e "  ${MAG}:: Professional Deployment Strategy ::${RST}"
echo ""

read -p "  Start installation? (y/n) " choice
if [[ ! $choice =~ ^[Yy]$ ]]; then exit 1; fi

pre_flight

# --- PHASE 2: CORE INJECTION ---
echo ""
separator
echo -e " ${B_CYN}PHASE 2 : PACKAGE INJECTION${RST}"
separator

act "Refreshing package database..."
sudo pacman -Sy --noconfirm >> "$LOG_FILE" 2>&1

sub_separator
info "Installing Core Components..."
for pkg in "${CORE_PKGS[@]}"; do install_pacman "$pkg"; done

sub_separator
info "Installing Utility Arsenal..."
for pkg in "${TOOL_PKGS[@]}"; do install_pacman "$pkg"; done

# --- PHASE 3: AUR HELPER ---
echo ""
separator
echo -e " ${B_CYN}PHASE 3 : AUR ACCESS${RST}"
separator

if command -v yay &> /dev/null; then
    ok "Yay helper detected."
else
    warn "Yay not found."
    read -p "  Install 'yay' AUR helper? (y/n) " install_yay
    if [[ $install_yay =~ ^[Yy]$ ]]; then
        act "Installing build dependencies..."
        sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin >> "$LOG_FILE" 2>&1
        cd /tmp/yay-bin && makepkg -si --noconfirm >> "$LOG_FILE" 2>&1
        cd "$SCRIPT_DIR" && rm -rf /tmp/yay-bin
        ok "Yay deployed."
    fi
fi

if command -v yay &> /dev/null; then
    info "Installing AUR Packages..."
    for pkg in "${YAY_PKGS[@]}"; do install_yay "$pkg"; done
fi

# --- PHASE 4: ASSET DEPLOYMENT ---
echo ""
separator
echo -e " ${B_CYN}PHASE 4 : FONT & THEME DEPLOYMENT${RST}"
separator

FONT_DIR="$HOME/.local/share/fonts"
SOURCE_FONTS="$SCRIPT_DIR/Fonts"

if [ -d "$SOURCE_FONTS" ]; then
    mkdir -p "$FONT_DIR"
    act "Syncing fonts..."
    cp -ru "$SOURCE_FONTS"/* "$FONT_DIR/" >> "$LOG_FILE" 2>&1
    fc-cache -f >> "$LOG_FILE" 2>&1
    ok "Fonts indexed."
else
    fail "Fonts directory missing in repository."
fi

# --- PHASE 5: DOTFILE MIGRATION ---
echo ""
separator
echo -e " ${B_CYN}PHASE 5 : DOTFILE MIGRATION${RST}"
separator

echo -e "  ${B_WHT}SELECT DEPLOYMENT MODE:${RST}"
echo -e "  ${GRN}[1] SAFE COPY${RST}     : Independent copies (Recommended)"
echo -e "  ${CYN}[2] SYMLINK MODE${RST}  : Link to this repo (For Developers)"
echo ""
read -p "  Selection (1/2): " deploy_mode

act "Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    source_folder="$SCRIPT_DIR/$folder"
    
    if [ ! -d "$source_folder" ]; then
        fail "Source $folder missing in repo!"
        continue
    fi

    # Backup existing
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -ne "${YLW}[ BACK ]${RST} Archiving $folder..."
        mv "$target" "$BACKUP_DIR/$folder"
        echo -e "\r${GRN}[ BACK ]${RST} Archived $folder."
    fi
    
    # Deploy
    if [[ "$deploy_mode" == "2" ]]; then
        echo -e "${CYN}[ LINK ]${RST} Linking $folder"
        ln -sf "$source_folder" "$HOME/.config/"
    else
        echo -e "${GRN}[ COPY ]${RST} Copying $folder"
        cp -r "$source_folder" "$HOME/.config/"
    fi
done

# --- PHASE 6: NETWORK (Optional) ---
echo ""
separator
echo -e " ${B_CYN}PHASE 6 : NETWORK CONFIG${RST}"
separator
warn "This will switch your network stack to iwd/impala."
read -p "  Configure network now? (y/n) " net_choice
if [[ $net_choice =~ ^[Yy]$ ]]; then
    act "Neutralizing conflicts..."
    sudo systemctl disable --now NetworkManager wpa_supplicant 2>/dev/null || true
    
    act "Configuring iwd..."
    sudo mkdir -p /etc/iwd
    sudo bash -c 'cat > /etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF'
    
    sudo systemctl enable --now systemd-resolved iwd 2>/dev/null
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    ok "Network stack updated. Use 'sudo impala' to connect."
fi

# --- PHASE 7: RECORD REPO PATH ---
mkdir -p "$HOME/.config/brewland"
echo "$SCRIPT_DIR" > "$HOME/.config/brewland/repo.path"
ok "Repository path recorded for updates."

# --- FINISH ---
echo ""
separator
if [ ${#FAILED_ACTIONS[@]} -eq 0 ]; then
    echo -e " ${B_GRN}INSTALLATION SUCCESSFUL${RST}"
else
    echo -e " ${B_YLW}INSTALLATION COMPLETED WITH WARNINGS${RST}"
    sub_separator
    echo -e " ${RED}The following actions failed:${RST}"
    for action in "${FAILED_ACTIONS[@]}"; do
        echo -e "  - $action"
    done
    sub_separator
fi
separator
echo -e "  Backup : $BACKUP_DIR"
echo -e "  Log    : $LOG_FILE"
echo ""
info "A system reboot is highly recommended."
read -n 1 -s -r -p "Press any key to exit..."
echo ""