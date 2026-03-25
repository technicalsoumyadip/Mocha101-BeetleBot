#!/bin/bash

# ==============================================================================
#  BREWLAND REMOTE BOOTSTRAPPER
# ==============================================================================

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
BLU='\033[0;34m'
RST='\033[0m'

REPO_URL="https://github.com/BeetleBot/BrewLand.git"
INSTALL_DIR="$HOME/BrewLand"

echo -e "${BLU}:: Initializing BrewLand Remote Installer...${RST}"

# 1. Check for Git
if ! command -v git &> /dev/null; then
    echo -e "${YLW}[ WARN ]${RST} Git not found. Attempting to install..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm git
    else
        echo -e "${RED}[ ERR! ]${RST} Git is required but not found, and this system doesn't use pacman."
        exit 1
    fi
fi

# 2. Clone Repository
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YLW}[ INFO ]${RST} $INSTALL_DIR already exists. Updating..."
    cd "$INSTALL_DIR" && git pull
else
    echo -e "${BLU}[ ACTN ]${RST} Cloning BrewLand into $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 3. Launch Main Installer
if [ -f "$INSTALL_DIR/install.sh" ]; then
    chmod +x "$INSTALL_DIR/install.sh"
    cd "$INSTALL_DIR" && ./install.sh
else
    echo -e "${RED}[ ERR! ]${RST} Failed to find install.sh in $INSTALL_DIR"
    exit 1
fi
