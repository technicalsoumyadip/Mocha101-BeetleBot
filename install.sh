#!/bin/bash

# brewland installer
# handles dependencies, configs, and setup for arch linux

# paths
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG_FILE="$HOME/brewland_install.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/ConfigBackups/$TIMESTAMP"
FAILED_ACTIONS=()

echo "--- BrewLand Install Log: $TIMESTAMP ---" > "$LOG_FILE"

# colors
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

# output helpers
separator() { echo -e "${B_MAG}================================================================================${RST}"; }
sub_separator() { echo -e "${MAG}--------------------------------------------------------------------------------${RST}"; }
info() { echo -e "${BLU}[ INFO ]${RST} $1"; }
ok() { echo -e "${GRN}[ OKAY ]${RST} $1"; }
fail() { echo -e "${RED}[ FAIL ]${RST} $1"; FAILED_ACTIONS+=("$1"); }
act() { echo -e "${CYN}[ ACTN ]${RST} $1"; }
warn() { echo -e "${YLW}[ WARN ]${RST} $1"; }

# setup lists
CORE_PKGS=("hyprland" "waybar" "rofi" "iwd" "swaync" "hypridle" "hyprlock" "hyprpolkitagent" "xdg-desktop-portal-hyprland" "libpulse" "sound-theme-freedesktop")
TOOL_PKGS=("kitty" "thunar" "mpd-mpris" "fish" "awww" "fastfetch" "rofimoji" "fd" "cliphist" "wl-clipboard" "wtype" "kvantum" "qt5ct" "qt6ct" "jq" "curl" "unzip" "pavucontrol" "brightnessctl" "playerctl" "bluetui" "impala" "grim" "slurp" "tumbler" "ffmpegthumbnailer" "poppler-glib" "libgsf" "libopenraw" "freetype2")
YAY_PKGS=("grimblast-git" "hyprsession" "hyprpicker" "kvantum-theme-catppuccin-git")
DOTFILES=("hypr" "kitty" "rofi" "swaync" "waybar" "cava" "brewland" "fastfetch" "brew-task")

install_pacman() {
    local pkg=$1
    echo -ne "${BLU}[ .... ]${RST} checking $pkg..."
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg already installed."
    else
        echo -e "\r${CYN}[ INST ]${RST} installing $pkg..."
        if sudo pacman -S --noconfirm --needed "$pkg" >> "$LOG_FILE" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} $pkg installed."
        else
            echo -e "\r${RED}[ ERR! ]${RST} failed to install $pkg. check $LOG_FILE"
            FAILED_ACTIONS+=("Pacman: $pkg")
        fi
    fi
}

install_yay() {
    local pkg=$1
    echo -ne "${BLU}[ .... ]${RST} checking $pkg (AUR)..."
    if pacman -Qi "$pkg" &> /dev/null; then
        echo -e "\r${YLW}[ SKIP ]${RST} $pkg already installed."
    else
        echo -e "\r${CYN}[ INST ]${RST} installing $pkg via yay..."
        if yay -S --noconfirm --needed "$pkg" >> "$LOG_FILE" 2>&1; then
            echo -e "\r${GRN}[ DONE ]${RST} $pkg installed."
        else
            echo -e "\r${RED}[ ERR! ]${RST} failed to install $pkg. check $LOG_FILE"
            FAILED_ACTIONS+=("Yay: $pkg")
        fi
    fi
}

pre_flight() {
    separator
    echo -e " ${B_CYN}PHASE 1 : SYSTEM PRE-FLIGHT${RST}"
    separator

    act "checking internet..."
    if ! ping -m 1 -c 1 -W 1 google.com &>/dev/null; then
        fail "no internet detected."
        exit 1
    fi

    act "checking OS..."
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
            fail "this is for arch only. you are running $PRETTY_NAME"
            exit 1
        fi
    fi

    if [[ "$EUID" -eq 0 ]]; then
        fail "don't run as root."
        exit 1
    fi

    act "validating sudo..."
    sudo -v || { fail "need sudo."; exit 1; }
}

# startup flags
if [[ "$1" == "--check" ]]; then
    pre_flight
    info "ready for deployment."
    exit 0
fi

# banner
echo -e "${B_MAG}"
echo "  ██████╗ ██████╗ ███████╗██╗    ██╗██╗      █████╗ ███╗   ██╗██████╗ "
echo "  ██╔══██╗██╔══██╗██╔════╝██║    ██║██║     ██╔══██╗████╗  ██║██╔══██╗"
echo "  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║██║     ███████║██╔██╗ ██║██║  ██║"
echo "  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║██║     ██╔══██║██║╚██╗██║██║  ██║"
echo "  ██████╔╝██║  ██║███████╗╚███╔███╔╝███████╗██║  ██║██║ ╚████║██████╔╝"
echo "  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ "
echo -e "${RST}"
echo -e "  ${B_WHT}:: brewland installer ::${RST}"
echo ""

read -p "  start install? (y/n) " choice
if [[ ! $choice =~ ^[Yy]$ ]]; then exit 1; fi

pre_flight

# --- phase 2: packages ---
echo ""
separator
echo -e " ${B_CYN}PHASE 2 : PACKAGE INJECTION${RST}"
separator

act "refreshing databases..."
sudo pacman -Sy --noconfirm >> "$LOG_FILE" 2>&1

sub_separator
info "core components..."
for pkg in "${CORE_PKGS[@]}"; do install_pacman "$pkg"; done

sub_separator
info "utility arsenal..."
for pkg in "${TOOL_PKGS[@]}"; do install_pacman "$pkg"; done

# --- phase 3: aur ---
echo ""
separator
echo -e " ${B_CYN}PHASE 3 : AUR ACCESS${RST}"
separator

if ! command -v yay &> /dev/null; then
    warn "yay not found."
    read -p "  install yay? (y/n) " install_yay_choice
    if [[ $install_yay_choice =~ ^[Yy]$ ]]; then
        act "installing yay..."
        sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin >> "$LOG_FILE" 2>&1
        cd /tmp/yay-bin && makepkg -si --noconfirm >> "$LOG_FILE" 2>&1
        cd "$SCRIPT_DIR" && rm -rf /tmp/yay-bin
    fi
fi

if command -v yay &> /dev/null; then
    info "AUR packages..."
    for pkg in "${YAY_PKGS[@]}"; do install_yay "$pkg"; done
fi

# --- phase 4: assets ---
echo ""
separator
echo -e " ${B_CYN}PHASE 4 : ASSET DEPLOYMENT${RST}"
separator

if [ -d "$SCRIPT_DIR/Fonts" ]; then
    mkdir -p "$HOME/.local/share/fonts"
    act "syncing fonts..."
    cp -ru "$SCRIPT_DIR/Fonts"/* "$HOME/.local/share/fonts/" >> "$LOG_FILE" 2>&1
    fc-cache -f >> "$LOG_FILE" 2>&1
else
    fail "fonts directory missing."
fi

# --- phase 5: configs ---
echo ""
separator
echo -e " ${B_CYN}PHASE 5 : DOTFILE MIGRATION${RST}"
separator

echo -e "  ${B_WHT}deployment mode:${RST}"
echo -e "  ${GRN}[1] SAFE COPY${RST}"
echo -e "  ${CYN}[2] SYMLINK MODE${RST}"
echo ""
read -p "  selection (1/2): " deploy_mode

act "backing up to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for folder in "${DOTFILES[@]}"; do
    target="$HOME/.config/$folder"
    source_folder="$SCRIPT_DIR/$folder"
    
    if [ ! -d "$source_folder" ]; then
        fail "source $folder missing!"
        continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -ne "${YLW}[ BACK ]${RST} archiving $folder..."
        mv "$target" "$BACKUP_DIR/$folder"
        echo -e "\r${GRN}[ BACK ]${RST} archived $folder."
    fi
    
    if [[ "$deploy_mode" == "2" ]]; then
        echo -e "${CYN}[ LINK ]${RST} linking $folder"
        ln -sf "$source_folder" "$HOME/.config/"
    else
        echo -e "${GRN}[ COPY ]${RST} copying $folder"
        cp -r "$source_folder" "$HOME/.config/"
    fi
done

# --- phase 6: network ---
echo ""
separator
echo -e " ${B_CYN}PHASE 6 : NETWORK CONFIG${RST}"
separator
warn "switches network to iwd/impala stack."
read -p "  configure now? (y/n) " net_choice
if [[ $net_choice =~ ^[Yy]$ ]]; then
    act "cleaning conflicts..."
    sudo systemctl disable --now NetworkManager wpa_supplicant 2>/dev/null || true
    
    act "setting up iwd..."
    sudo mkdir -p /etc/iwd
    sudo bash -c 'cat > /etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF'
    
    sudo systemctl enable --now systemd-resolved iwd 2>/dev/null
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    ok "use 'sudo impala' to connect."
fi

# --- phase 7: bookkeeping ---
mkdir -p "$HOME/.config/brewland"
echo "$SCRIPT_DIR" > "$HOME/.config/brewland/repo.path"

# --- finish ---
echo ""
separator
if [ ${#FAILED_ACTIONS[@]} -eq 0 ]; then
    echo -e " ${B_GRN}INSTALLATION SUCCESSFUL${RST}"
else
    echo -e " ${B_YLW}INSTALLATION COMPLETED WITH WARNINGS${RST}"
    sub_separator
    echo -e " ${RED}failed actions:${RST}"
    for action in "${FAILED_ACTIONS[@]}"; do echo -e "  - $action"; done
    sub_separator
fi
separator
echo -e "  backup : $BACKUP_DIR"
echo -e "  log    : $LOG_FILE"
echo ""
info "reboot recommended."
read -n 1 -s -r -p "press any key to exit..."
echo ""