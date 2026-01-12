#!/bin/bash

# ==============================================================================
#  ☕ MOCHA 101 INSTALLER
#  A professional, aesthetic installation script for the Mocha101 Dotfiles.
# ==============================================================================

# Get the directory where the script is located
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- COLORS & STYLING ---
# Using distinct Catppuccin-inspired colors for a cohesive UI
MAUVE='\033[38;5;183m'
LAVENDER='\033[38;5;147m'
BLUE='\033[38;5;117m'
GREEN='\033[38;5;120m'
PEACH='\033[38;5;210m'
FLAMINGO='\033[38;5;217m'
GRAY='\033[38;5;245m'
BOLD='\033[1m'
RESET='\033[0m'

# --- UI CONSTANTS ---
ICON_OK="${GREEN}✔${RESET}"
ICON_FAIL="${PEACH}✘${RESET}"
ICON_INFO="${BLUE}➜${RESET}"
ICON_WAIT="${MAUVE}⧖${RESET}"

# --- HELPER FUNCTIONS ---

# Function to hide cursor
hide_cursor() { tput civis; }

# Function to restore cursor (ensure this runs on exit)
restore_cursor() { tput cnorm; }
trap restore_cursor EXIT

# Function to print a centered banner
print_banner() {
    clear
    echo -e "${MAUVE}"
    echo "   __  __  ____   _____ _    _          _  ___  __  "
    echo "  |  \/  |/ __ \ / ____| |  | |   /\   / |/ _ \/_ | "
    echo "  | \  / | |  | | |    | |__| |  /  \  | | | | || | "
    echo "  | |\/| | |  | | |    |  __  | / /\ \ | | | | || | "
    echo "  | |  | | |__| | |____| |  | |/ ____ \| | |_| || | "
    echo "  |_|  |_|\____/ \_____|_|  |_/_/    \_\_|\___/ |_| "
    echo -e "${RESET}"
    echo -e "${FLAMINGO}         A minimal and efficient dotfiles setup.${RESET}"
    echo ""
    echo -e "${GRAY}────────────────────────────────────────────────────────────${RESET}"
    echo ""
}

# Function to print a section header
print_step() {
    echo -e "\n${BOLD}${LAVENDER}:: $1${RESET}"
}

# Function to display a status message
log_info() {
    echo -e "   ${ICON_INFO} $1"
}

# Function to display success
log_success() {
    echo -e "   ${ICON_OK} $1"
}

# Function to display failure
log_error() {
    echo -e "   ${ICON_FAIL} $1"
}

# Function for processing indicator
# Usage: run_cmd "Description" "Command"
run_cmd() {
    local desc="$1"
    local cmd="$2"
    
    # Print the description with a wait icon, no newline
    echo -ne "   ${ICON_WAIT} ${desc}..."
    
    # Run the command, capturing output to a log (or /dev/null), preserving exit code
    if eval "$cmd" > /dev/null 2>&1; then
        # On success, clear line and print success
        echo -ne "\r\033[K"
        echo -e "   ${ICON_OK} ${desc}"
    else
        # On failure
        echo -ne "\r\033[K"
        echo -e "   ${ICON_FAIL} ${desc} ${PEACH}(Failed)${RESET}"
        # Optional: Exit or prompt? For this script, we warn.
        sleep 1
    fi
}

# --- MAIN SCRIPT ---

hide_cursor
print_banner

# --- STEP 2: ARCH VERIFICATION ---
print_step "System Verification"
echo -ne "   ${BLUE}?${RESET} Are you using Arch Linux? ${GRAY}[y/N]${RESET} "
read -r is_arch

if [[ ! "$is_arch" =~ ^[yY]$ ]]; then
    echo ""
    echo -e "${PEACH}   Installation Cancelled.${RESET}"
    echo -e "\n${BOLD}   MANUAL INSTALLATION INSTRUCTIONS:${RESET}"
    echo -e "   ${GRAY}──────────────────────────────────────${RESET}"
    echo -e "   1. Copy these folders to ${BLUE}~/.config/${RESET}:"
    echo -e "      ${GRAY}hypr, kitty, mpd, rmpc, swaync, vicinae, waybar${RESET}"
    echo -e "   2. Install dependencies manually (see README.md)."
    echo ""
    exit 0
fi

# --- STEP 3: YAY VERIFICATION ---
print_step "AUR Helper Check"
if ! command -v yay &> /dev/null; then
    echo -e "   ${PEACH}⚠ yay is missing.${RESET}"
    echo -ne "   ${BLUE}?${RESET} Install yay (requires sudo)? ${GRAY}[y/N]${RESET} "
    read -r install_yay
    if [[ "$install_yay" =~ ^[yY]$ ]]; then
        echo ""
        run_cmd "Installing base-devel, git, curl" "sudo pacman -S --needed base-devel git curl --noconfirm"
        
        echo -ne "   ${ICON_WAIT} Cloning and building yay (this may take a while)..."
        if git clone https://aur.archlinux.org/yay.git yay_tmp > /dev/null 2>&1; then
            cd yay_tmp
            if makepkg -si --noconfirm > /dev/null 2>&1; then
                cd .. && rm -rf yay_tmp
                echo -ne "\r\033[K"
                log_success "yay installed successfully"
            else
                cd .. && rm -rf yay_tmp
                echo -ne "\r\033[K"
                log_error "Failed to build yay"
                exit 1
            fi
        else
            echo -ne "\r\033[K"
            log_error "Failed to clone yay"
            exit 1
        fi
    else
        log_error "yay is required. Exiting."
        exit 1
    fi
else
    log_success "yay is already installed"
fi

# --- STEP 4: DEPENDENCIES ---
print_step "Installing Dependencies"

# Refresh sudo privileges upfront to avoid breaking the UI later
echo -e "   ${GRAY}Requesting sudo privileges for installation...${RESET}"
sudo -v

# 1. Official Packages
echo -e "\n   ${BOLD}${MAUVE}CORE COMPONENTS${RESET} ${GRAY}(pacman)${RESET}"
PACKAGES_CORE="hyprland waybar swaync hypridle hyprlock hyprpolkitagent xdg-desktop-portal-hyprland xdg-desktop-portal-gnome kitty nautilus pavucontrol hyprshot grim slurp jq wl-clipboard brightnessctl playerctl curl unzip"

# NOTE: rmpc is often AUR. We try pacman, if fail, we move to yay logic.
# Splitting loop for better visuals
for pkg in $PACKAGES_CORE; do
    run_cmd "Installing $pkg" "sudo pacman -S --needed $pkg --noconfirm"
done

# 2. AUR Packages
echo -e "\n   ${BOLD}${FLAMINGO}AUR UTILITIES${RESET} ${GRAY}(yay)${RESET}"
# Added rmpc here just in case, as it's often not in official repos yet
PACKAGES_AUR="vicinae-bin awww-git rmpc"

for pkg in $PACKAGES_AUR; do
    run_cmd "Installing $pkg" "yay -S --needed $pkg --noconfirm"
done

# 3. Fonts
echo -e "\n   ${BOLD}${BLUE}TYPOGRAPHY${RESET} ${GRAY}(Local Fonts)${RESET}"
FONT_DIR="$HOME/.local/share/fonts"
REPO_FONT_DIR="$SCRIPT_DIR/Fonts"

run_cmd "Creating font directory" "mkdir -p $FONT_DIR"

if [ -d "$REPO_FONT_DIR" ]; then
    run_cmd "Copying fonts from repo" "cp -r $REPO_FONT_DIR/* $FONT_DIR/"
    run_cmd "Refreshing font cache" "fc-cache -fv"
else
    log_error "Fonts folder '$REPO_FONT_DIR' not found."
fi

# Cleanup
echo -e "\n   ${BOLD}${GRAY}CLEANUP${RESET}"
run_cmd "Removing pacman cache" "sudo pacman -Sc --noconfirm"
run_cmd "Removing yay cache" "yay -Sc --noconfirm"

# --- STEP 5: BACKUP ---
print_step "Backing Up Configurations"
BACKUP_DIR="$HOME/ConfigBackups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
TARGET_FOLDERS=("hypr" "kitty" "mpd" "rmpc" "swaync" "vicinae" "waybar")

run_cmd "Creating backup dir ($BACKUP_DIR)" "mkdir -p $BACKUP_DIR"

for folder in "${TARGET_FOLDERS[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        run_cmd "Backing up $folder" "cp -r $HOME/.config/$folder $BACKUP_DIR/${folder}_$TIMESTAMP"
    else
        log_info "No existing config for $folder (skipping backup)"
    fi
done

# --- STEP 6: INSTALL CONFIGS ---
print_step "Deploying Mocha101 Dotfiles"

for folder in "${TARGET_FOLDERS[@]}"; do
    if [ -d "$SCRIPT_DIR/$folder" ]; then
        # Remove existing folder to ensure clean link/copy
        rm -rf "$HOME/.config/$folder"
        run_cmd "Installing $folder" "cp -r $SCRIPT_DIR/$folder $HOME/.config/"
    else
        log_error "Source folder $SCRIPT_DIR/$folder not found in repo"
    fi
done

# Copy walls.sh
if [ -f "$SCRIPT_DIR/walls.sh" ]; then
    run_cmd "Installing walls.sh script" "cp $SCRIPT_DIR/walls.sh $HOME/ && chmod +x $HOME/walls.sh"
fi

# --- STEP 7: FINISH ---
# clear command removed to preserve terminal scrollback/history
echo -e "\n"
echo -e "${MAUVE}"
echo "  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "  ┃                                                                       ┃"
echo -e "  ┃                ${FLAMINGO}✨ MOCHA 101 INSTALLED SUCCESSFULLY! ✨${MAUVE}                ┃"
echo "  ┃                                                                       ┃"
echo "  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "${RESET}"
echo -e "   ${BOLD}Next Steps for the intended experience:${RESET}"
echo ""
echo -e "   ${PEACH}1. ACTIVATE VICINAE EXTENSIONS${RESET}"
echo -e "      ${GRAY}Open Vicinae Settings and enable:${RESET}"
echo -e "      ${BLUE}•${RESET} Wifi Commander ${GRAY}(SUPER + ALT + N)${RESET}"
echo -e "      ${BLUE}•${RESET} Bluetooth      ${GRAY}(SUPER + ALT + B)${RESET}"
echo -e "      ${BLUE}•${RESET} AWWW Switcher  ${GRAY}(SUPER + SHIFT + W)${RESET}"
echo ""
echo -e "   ${PEACH}2. EXPLORE KEYBINDINGS${RESET}"
echo -e "      ${GRAY}Full documentation at:${RESET} ${BLUE}github.com/BeetleBot/Mocha101${RESET}"
echo ""
echo -e "   ${PEACH}3. SYSTEM REBOOT${RESET}"
echo -e "      ${GRAY}A restart is recommended to apply all Wayland environments.${RESET}"
echo ""
echo -e "${GRAY}───────────────────────────────────────────────────────────────────────${RESET}"
echo -e "${FLAMINGO}   HAPPY RICING!${RESET}"
echo ""
echo -ne "   ${BOLD}Press any key to exit...${RESET}"
read -n 1 -s
echo ""
restore_cursor