# Configuration Guide

BrewLand is highly modular. Most settings are located in the `hypr/HLconfigs/` directory.

## Directory Structure
- `monitors.conf`: Display resolution and positioning.
- `keybindings.conf`: All system and app shortcuts.
- `lookandfeel.conf`: Animations, gaps, and decoration settings.
- `autostart.conf`: Services that launch on login.
- `windowsandworkspaces.conf`: Window rules and workspace behaviors.

## Modifying the Bar (Waybar)
Waybar configuration is located in `waybar/`.
- `config.jsonc`: Module layout and logic.
- `style.css`: Global styling.
- `colors/`: Themed color definitions.

## Modifying Notifications (SwayNC)
SwayNC configuration is located in `swaync/`.
- `config.json`: Notification behaviors and widgets.
- `style.css`: Visual styling.

## Customizing Rofi
Rofi themes are found in `rofi/themes/`. The `colors.rasi` file is dynamically updated by the theme switcher. 
To modify the layout, edit the `.rasi` files in the root of the `rofi/` directory.
