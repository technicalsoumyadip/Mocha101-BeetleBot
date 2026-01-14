#!/bin/bash

# Paths
THEME_DIR="$HOME/.config/hypr/themes"
BRIDGE_FILE="$HOME/.config/hypr/HLconfigs/theme-colors.conf"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"

# Toggle Logic
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
    COLOR_SCHEME="prefer-light"
    VSCODE_THEME="Catppuccin Latte"
else
    GTK_THEME="catppuccin-mocha-mauve-standard+default"
    COLOR_SCHEME="prefer-dark"
    VSCODE_THEME="Catppuccin Mocha"
fi

# 1. Hyprland
ln -sf "$THEME_DIR/$NEW_FLAVOR.conf" "$BRIDGE_FILE"
hyprctl reload

# 2. GTK & Nautilus (The "Close & Reopen" Method)
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

mkdir -p "$HOME/.config/gtk-4.0"
ln -sf "/usr/share/themes/$GTK_THEME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -sf "/usr/share/themes/$GTK_THEME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
ln -sf "/usr/share/themes/$GTK_THEME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"

if pidof nautilus > /dev/null; then
    nautilus -q
    sleep 0.3
    nautilus --new-window & 
    disown
fi

# 3. Waybar
sed -i "s|@import .*|@import \"../waybar/colors/$NEW_FLAVOR.css\";|" "$WAYBAR_STYLE"
pkill -USR2 waybar

# 4. Kitty
sed -i "s|^include .*|include $NEW_FLAVOR.conf|" "$KITTY_CONF"
if pidof kitty > /dev/null; then
    kill -SIGUSR1 $(pidof kitty)
fi

# 5. VSCodium
if [ -f "$CODIUM_SETTINGS" ]; then
    sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$VSCODE_THEME\"/" "$CODIUM_SETTINGS"
fi

# --- 6. SwayNC ---
# Swap the color symlink for SwayNC
ln -sf "$HOME/.config/swaync/colors/$NEW_FLAVOR.css" "$HOME/.config/swaync/colors/current_colors.css"

# Reload SwayNC to apply changes
swaync-client -rs

# --- 7. rmpc ---
# Swap the theme symlink for rmpc
ln -sf "$HOME/.config/rmpc/themes/$NEW_FLAVOR.ron" "$HOME/.config/rmpc/themes/current_theme.ron"

# --- 8. Fish Shell ---
if [ "$NEW_FLAVOR" == "latte" ]; then
    FISH_THEME="Catppuccin Latte"
else
    FISH_THEME="Catppuccin Mocha"
fi

# Save the current flavor so Fish can read it
echo "$NEW_FLAVOR" > ~/.config/swaync/current_flavor

# --- 8. Fish Shell ---
# 1. Create/Update the symlink to point to the correct .theme file
ln -sf "$HOME/.config/fish/themes/Catppuccin ${NEW_FLAVOR^}.theme" "$HOME/.config/fish/themes/current_theme.theme"

# 2. Save the flavor for the startup check
echo "$NEW_FLAVOR" > ~/.config/swaync/current_flavor

# 3. Signal all open Fish instances to reload
pkill -USR1 fish

# --- 10. Zen Browser ---
# Note: Zen uses merged userChrome.css/userContent.css files.
# It relies on the system-wide color-scheme preference to switch.

if [ "$NEW_FLAVOR" == "latte" ]; then
    # Signal Zen to use @media (prefers-color-scheme: light)
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    log_info "Zen Browser set to Light Mode (Latte)"
else
    # Signal Zen to use @media (prefers-color-scheme: dark)
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    log_info "Zen Browser set to Dark Mode (Mocha)"
fi

# --- 11. Rofi Theme Switch (Atomic Method) ---
# We overwrite the 'colors.rasi' file that config.rasi imports
ROFI_THEME_DIR="$HOME/.config/rofi/themes"

if [ "$NEW_FLAVOR" == "latte" ]; then
    cp "$ROFI_THEME_DIR/latte.rasi" "$ROFI_THEME_DIR/colors.rasi"
else
    cp "$ROFI_THEME_DIR/mocha.rasi" "$ROFI_THEME_DIR/colors.rasi"
fi

# Kill any running Rofi instances so the next launch reads the new theme
pkill -x rofi

notify-send "Theme Toggled" "System set to Catppuccin $NEW_FLAVOR"