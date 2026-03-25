# FAQ & Troubleshooting

## Frequently Asked Questions

### 1. How do I change my monitor resolution?
Edit `hypr/HLconfigs/monitors.conf`. You can find your monitor name by running `hyprctl monitors`.

### 2. Why are some icons missing?
BrewLand relies on **JetBrainsMono Nerd Font**. Ensure you've run the `install.sh` script, which automatically indexes the fonts in the `Fonts/` directory.

### 3. How do I add my own Rofi menu?
1. Create your script in `rofi/scripts/`.
2. Add a keybinding in `hypr/HLconfigs/keybindings.conf`.
3. (Optional) Add a custom Rasi theme in `rofi/themes/`.

## Troubleshooting

### "XDPH not found" errors
This usually happens if the XDG Desktop Portal isn't running correctly. 
- Run `./brewland/brewland-doctor.sh` to check the status.
- Ensure `xdg-desktop-portal-hyprland` is installed.

### Waybar doesn't reload after theme switch
Try manually reloading with `Super + R`. If it persists, check the log file at `~/.config/waybar/waybar.log` (if enabled) or run `waybar` from a terminal to see errors.

### Theme switch is inconsistent across apps
Ensure you have `gsettings` and `kvantummanager` installed. The `theme_switcher.sh` script relies on these to update GTK and QT themes.
