#!/bin/bash

# ================= CONFIGURATION =================
RELOAD_FISH_SHELL="false"
# =================================================

# Paths
THEME_DIR="$HOME/.config/hypr/themes"
GTK_THEME_DIR="$HOME/.config/brewland/themes/gtkthemes"
BRIDGE_FILE="$HOME/.config/hypr/HLconfigs/theme-colors.conf"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
FASTFETCH_CONFIG="$HOME/.config/fastfetch/config.jsonc"
FASTFETCH_THEMES="$HOME/.config/fastfetch/themes"
CAVA_DIR="$HOME/.config/cava"

# Helpers
safe_sed() {
    local pattern=$1
    local file=$2
    if [ -f "$file" ]; then
        sed -i "$pattern" "$file"
    fi
}

safe_ln() {
    local source=$1
    local target=$2
    if [ -e "$source" ]; then
        ln -sf "$source" "$target"
    fi
}

# Determine New Flavor
CURRENT_THEME=$(readlink "$BRIDGE_FILE")
if [[ "$1" == "latte" ]]; then
    NEW_FLAVOR="latte"
elif [[ "$1" == "mocha" ]]; then
    NEW_FLAVOR="mocha"
else
    if [[ "$CURRENT_THEME" == *"$THEME_DIR/mocha.conf" ]]; then
        NEW_FLAVOR="latte"
    else
        NEW_FLAVOR="mocha"
    fi
fi

# Variables based on choice
if [ "$NEW_FLAVOR" == "latte" ]; then
    GTK_THEME="catppuccin-latte-mauve-standard+default"
    KVANTUM_THEME="catppuccin-latte-mauve"
    COLOR_SCHEME="prefer-light"
    VSCODE_THEME="Catppuccin Latte"
else
    GTK_THEME="catppuccin-mocha-mauve-standard+default"
    KVANTUM_THEME="catppuccin-mocha-mauve"
    COLOR_SCHEME="prefer-dark"
    VSCODE_THEME="Catppuccin Mocha"
fi

# --- 1. Hyprland ---
safe_ln "$THEME_DIR/$NEW_FLAVOR.conf" "$BRIDGE_FILE"
hyprctl reload &

# --- 2. GTK & Nautilus ---
mkdir -p "$HOME/.local/share/themes"
if [ ! -d "$HOME/.local/share/themes/$GTK_THEME" ]; then
    safe_ln "$GTK_THEME_DIR/$GTK_THEME" "$HOME/.local/share/themes/$GTK_THEME"
fi

gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

mkdir -p "$HOME/.config/gtk-4.0"
safe_ln "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
safe_ln "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
safe_ln "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"

# --- 3. Waybar ---
safe_sed "s|@import .*|@import \"../waybar/colors/$NEW_FLAVOR.css\";|" "$WAYBAR_STYLE"
pkill -USR2 waybar

# --- 4. Kitty ---
if [ -f "$KITTY_CONF" ]; then
    sed -i "s|^include .*|include $NEW_FLAVOR.conf|" "$KITTY_CONF"
    if pgrep -x kitty > /dev/null; then
        pkill -USR1 -x kitty
    fi
fi

# --- 5. VSCodium ---
safe_sed "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$VSCODE_THEME\"/" "$CODIUM_SETTINGS"

# --- 6. SwayNC ---
safe_ln "$HOME/.config/swaync/colors/$NEW_FLAVOR.css" "$HOME/.config/swaync/colors/current_colors.css"
swaync-client -rs
echo "$NEW_FLAVOR" > ~/.config/swaync/current_flavor

# --- 7. rmpc ---
safe_ln "$HOME/.config/rmpc/themes/$NEW_FLAVOR.ron" "$HOME/.config/rmpc/themes/current_theme.ron"

# --- 8. Fish Shell ---
safe_ln "$HOME/.config/fish/themes/Catppuccin ${NEW_FLAVOR^}.theme" "$HOME/.config/fish/themes/current_theme.theme"
if [ "$RELOAD_FISH_SHELL" == "true" ]; then
    pkill -USR1 fish
fi

# --- 9. Rofi ---
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
if [ -d "$ROFI_THEME_DIR" ]; then
    cp "$ROFI_THEME_DIR/$NEW_FLAVOR.rasi" "$ROFI_THEME_DIR/colors.rasi"
fi
pkill -x rofi

# --- 10. Fastfetch ---
safe_ln "$FASTFETCH_THEMES/$NEW_FLAVOR.jsonc" "$FASTFETCH_CONFIG"

# --- 11. Cava ---
safe_ln "$CAVA_DIR/themes/$NEW_FLAVOR-transparent.cava" "$CAVA_DIR/config"
if pgrep -x "cava" > /dev/null; then
    pkill -x cava
fi

# --- 12. Neovim ---
NVIM_FLAVOR_FILE="$HOME/.config/nvim/current_flavor"
mkdir -p "$HOME/.config/nvim"
echo "$NEW_FLAVOR" > "$NVIM_FLAVOR_FILE"
if pgrep -x nvim > /dev/null; then
    pkill -USR1 -x nvim
fi

# --- 13. Qt / Kvantum ---
if command -v kvantummanager &> /dev/null; then
    kvantummanager --set "$KVANTUM_THEME" 2>/dev/null
fi

notify-send -a "System Switcher" "Theme Toggled" "System set to Catppuccin $NEW_FLAVOR"
