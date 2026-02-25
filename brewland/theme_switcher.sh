#!/bin/bash

# ================= CONFIGURATION =================
# Set to "true" only if you are sure your Fish shell config handles signals correctly
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

# Toggle Logic
CURRENT_THEME=$(readlink "$BRIDGE_FILE")

# Determine New Flavor
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
ln -sf "$THEME_DIR/$NEW_FLAVOR.conf" "$BRIDGE_FILE"
# Reload in background to prevent blocking
hyprctl reload &

# --- 2. GTK & Nautilus ---
mkdir -p "$HOME/.local/share/themes"
if [ ! -d "$HOME/.local/share/themes/$GTK_THEME" ]; then
    ln -sf "$GTK_THEME_DIR/$GTK_THEME" "$HOME/.local/share/themes/$GTK_THEME"
fi

# Apply GTK Settings
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

# GTK4 Overrides
mkdir -p "$HOME/.config/gtk-4.0"
ln -sf "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -sf "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
ln -sf "$GTK_THEME_DIR/$GTK_THEME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"

# --- 3. Waybar ---
sed -i "s|@import .*|@import \"../waybar/colors/$NEW_FLAVOR.css\";|" "$WAYBAR_STYLE"
pkill -USR2 waybar

# --- 4. Kitty (Fixed) ---
# Ensure the config file exists before sed runs
if [ -f "$KITTY_CONF" ]; then
    sed -i "s|^include .*|include $NEW_FLAVOR.conf|" "$KITTY_CONF"
    
    # Wait for file write to complete
    sleep 0.1 
    
    # Reload Kitty safely
    if pgrep -x kitty > /dev/null; then
        pkill -USR1 -x kitty
    fi
fi

# --- 5. VSCodium ---
if [ -f "$CODIUM_SETTINGS" ]; then
    sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$VSCODE_THEME\"/" "$CODIUM_SETTINGS"
fi

# --- 6. SwayNC ---
ln -sf "$HOME/.config/swaync/colors/$NEW_FLAVOR.css" "$HOME/.config/swaync/colors/current_colors.css"
swaync-client -rs

# --- 7. rmpc ---
ln -sf "$HOME/.config/rmpc/themes/$NEW_FLAVOR.ron" "$HOME/.config/rmpc/themes/current_theme.ron"

# --- 8. Fish Shell (The likely culprit) ---
ln -sf "$HOME/.config/fish/themes/Catppuccin ${NEW_FLAVOR^}.theme" "$HOME/.config/fish/themes/current_theme.theme"
echo "$NEW_FLAVOR" > ~/.config/swaync/current_flavor

# DISABLED by default because this often kills the active terminal
if [ "$RELOAD_FISH_SHELL" == "true" ]; then
    pkill -USR1 fish
fi

# --- 10. Zen Browser ---
if [ "$NEW_FLAVOR" == "latte" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# --- 11. Rofi ---
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
if [ "$NEW_FLAVOR" == "latte" ]; then
    cp "$ROFI_THEME_DIR/latte.rasi" "$ROFI_THEME_DIR/colors.rasi"
else
    cp "$ROFI_THEME_DIR/mocha.rasi" "$ROFI_THEME_DIR/colors.rasi"
fi
pkill -x rofi

# --- 12. Fastfetch ---
ln -sf "$FASTFETCH_THEMES/$NEW_FLAVOR.jsonc" "$FASTFETCH_CONFIG"

# --- 13. Cava (Restart Strategy) ---
ln -sf "$CAVA_DIR/themes/$NEW_FLAVOR-transparent.cava" "$CAVA_DIR/config"

# If Cava is running, KILL and RESTART it.
# This prevents the window from closing if Cava crashes on "Reload"
if pgrep -x "cava" > /dev/null; then
    pkill -x cava
    sleep 0.1
    # Check if we should restart it (optional)
    # Uncomment the next line if you want Cava to launch automatically after toggle
    # kitty -e cava & disown 
fi

# --- 14. Neovim ---
NVIM_FLAVOR_FILE="$HOME/.config/nvim/current_flavor"

# Ensure the nvim config directory exists
mkdir -p "$HOME/.config/nvim"

# Write the new flavor to Neovim's dedicated file
echo "$NEW_FLAVOR" > "$NVIM_FLAVOR_FILE"

# Send SIGUSR1 to all running Neovim instances to trigger the live reload
if pgrep -x nvim > /dev/null; then
    pkill -USR1 -x nvim
fi

# --- 15. Qt / Kvantum ---
if command -v kvantummanager &> /dev/null; then
    kvantummanager --set "$KVANTUM_THEME"
fi

notify-send "Theme Toggled" "System set to Catppuccin $NEW_FLAVOR"
