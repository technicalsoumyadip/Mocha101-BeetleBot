#!/bin/bash

# ==============================================================================
#  ☕ MOCHA 101 ELITE INSTALLER v2.0
#  Architected for: BatArch / Hyprland
# ==============================================================================

# --- PRE-FLIGHT INITIALIZATION ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_FILE="$HOME/mocha_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# --- ELITE CATPPUCCIN PALETTE ---
MAUVE='\033[38;5;183m'    # Primary
LAVENDER='\033[38;5;147m' # Secondary
BLUE='\033[38;5;117m'     # Info
GREEN='\033[38;5;120m'    # Success
PEACH='\033[38;5;210m'    # Warning/Fail
FLAMINGO='\033[38;5;217m' # Accent
GRAY='\033[38;5;245m'     # Subtext
BOLD='\033[1m'
RESET='\033[0m'

# --- UI ASSETS ---
ICON_OK="[ ${GREEN}OK${RESET} ]"
ICON_FAIL="[ ${PEACH}!!${RESET} ]"
ICON_INFO="[ ${BLUE}..${RESET} ]"
ICON_STEP="[ ${MAUVE}>>${RESET} ]"

# --- CORE LOGIC FUNCTIONS ---
hide_cursor() { tput civis; }
restore_cursor() { tput cnorm; }
trap restore_cursor EXIT

print_banner() {
    clear
    echo -e "${MAUVE}${BOLD}"
    echo "  ███╗   ███╗ ██████╗  ██████╗██╗  ██╗ █████╗     ██╗ █████╗ ██╗"
    echo "  ████╗ ████║██╔═══██╗██╔════╝██║  ██║██╔══██╗   ███║██╔══██╗██║"
    echo "  ██╔████╔██║██║   ██║██║     ███████║███████║   ╚██║██║  ██║██║"
    echo "  ██║╚██╔╝██║██║   ██║██║     ██╔══██║██╔══██║    ██║██║  ██║██║"
    echo "  ██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║██║  ██║    ██║╚█████╔╝██║"
    echo "  ╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝ ╚════╝ ╚═╝"
    echo -e "${RESET}"
    echo -e "${GRAY}  ────────────────────────────────────────────────────────────${RESET}"
    echo -e "  ${FLAMINGO}PREMIUM HYPRLAND DOTFILES${RESET} | ${GRAY}SYSTEM DEPLOYMENT ENGINE v2.0${RESET}"
    echo -e "${GRAY}  ────────────────────────────────────────────────────────────${RESET}\n"
}

step_header() {
    echo -e "${BOLD}${LAVENDER}$1${RESET}"
    echo -e "${GRAY}------------------------------------------------------------${RESET}"
}

run_task() {
    local desc="$1"
    local cmd="$2"
    echo -ne "  ${ICON_INFO} ${desc}..."
    if eval "$cmd" > /dev/null 2>&1; then
        echo -ne "\r\033[K"
        echo -e "  ${ICON_OK} ${desc}"
    else
        echo -ne "\r\033[K"
        echo -e "  ${ICON_FAIL} ${desc} ${PEACH}(Check $LOG_FILE)${RESET}"
        sleep 0.5
    fi
}

# --- 1. SYSTEM VERIFICATION ---
hide_cursor
print_banner
step_header "PHASE 01: ENVIRONMENT VERIFICATION"

if ! grep -qi "arch" /etc/os-release; then
    echo -e "  ${PEACH}${ICON_FAIL} FATAL: Non-Arch Linux system detected.${RESET}"
    echo -e "\n  ${BOLD}MANUAL INSTALLATION PATHS:${RESET}"
    echo -e "  ${GRAY}1. Configs :${RESET} cp -r {hypr,kitty,fish,etc} ~/.config/"
    echo -e "  ${GRAY}2. Scripts :${RESET} mkdir -p ~/myscripts"
    echo -e "  ${GRAY}3. Logic   :${RESET} cp 'customshscripts/personal scripts/theme_switcher.sh' ~/myscripts/"
    echo -e "  ${GRAY}4. Permissions :${RESET} chmod +x ~/myscripts/theme_switcher.sh"
    exit 1
fi
echo -e "  ${ICON_OK} Host Architecture: $(uname -m) (Arch Linux)"

# --- 2. DEPENDENCY ORCHESTRATION ---
step_header "PHASE 02: COMPONENT ORCHESTRATION"

echo -ne "  ${ICON_INFO} Synchronizing Sudo Privileges..."
sudo -v
echo -e "\r  ${ICON_OK} Sudo Session Active              "

# Official Repo Packages
PACKAGES_CORE="hyprland waybar rofi swaync hypridle hyprlock hyprpolkitagent xdg-desktop-portal-hyprland xdg-desktop-portal-gnome kitty fish thunar pavucontrol hyprshot grim slurp jq wl-clipboard brightnessctl playerctl curl unzip"
for pkg in $PACKAGES_CORE; do
    run_task "Deploying $pkg" "sudo pacman -S --needed $pkg --noconfirm"
done

# AUR Helper & AUR Packages
if ! command -v yay &> /dev/null; then
    run_task "Bootstrapping yay" "git clone https://aur.archlinux.org/yay.git yay_tmp && cd yay_tmp && makepkg -si --noconfirm && cd .. && rm -rf yay_tmp"
fi

run_task "Deploying rmpc" "yay -S --needed rmpc --noconfirm"
run_task "Deploying awww-git" "yay -S --needed awww-git --noconfirm"

# --- 3. DATA PERSISTENCE & BACKUP ---
step_header "PHASE 03: CONFIGURATION SHADOWING (BACKUP)"
BACKUP_DIR="$HOME/ConfigBackups/$(date +%Y%m%d_%H%M%S)"
TARGET_FOLDERS=("hypr" "kitty" "rofi" "mpd" "rmpc" "swaync" "waybar" "fish")

mkdir -p "$BACKUP_DIR"
for folder in "${TARGET_FOLDERS[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        run_task "Shadowing $folder" "cp -r $HOME/.config/$folder $BACKUP_DIR/"
    fi
done

# --- 4. DEPLOYMENT ---
step_header "PHASE 04: MOCHA 101 CORE DEPLOYMENT"

for folder in "${TARGET_FOLDERS[@]}"; do
    if [ -d "$SCRIPT_DIR/$folder" ]; then
        rm -rf "$HOME/.config/$folder"
        run_task "Linking $folder" "cp -r \"$SCRIPT_DIR/$folder\" \"$HOME/.config/\""
    fi
done

# --- 5. SCRIPT ENGINE DEPLOYMENT ---
step_header "PHASE 05: SYSTEM ENGINE DEPLOYMENT"

mkdir -p "$HOME/myscripts"
THEME_SRC="$SCRIPT_DIR/customshscripts/personal scripts/theme_switcher.sh"
THEME_DEST="$HOME/myscripts/theme_switcher.sh"

if [ -f "$THEME_SRC" ]; then
    run_task "Installing Theme Switcher" "cp \"$THEME_SRC\" \"$THEME_DEST\" && chmod +x \"$THEME_DEST\""
else
    echo -e "  ${ICON_FAIL} Missing Engine: $THEME_SRC"
fi

# --- 6. FINALIZATION ---
echo -e "\n${MAUVE}  DEPLOYMENT SUCCESSFUL. SYSTEM REBOOT RECOMMENDED.${RESET}"
echo -e "  ${GRAY}All logs recorded in $LOG_FILE${RESET}\n"
echo -ne "  ${LAVENDER}${BOLD}➜ Press any key to finalize session...${RESET}"
read -n 1 -s

restore_cursor
hyprctl dispatch exit || pkill -u $USER