# Theming System

BrewLand features a dynamic theming system built around the Catppuccin **Mocha** (Dark) and **Latte** (Light) palettes.

## Global Colors
The single source of truth for all colors is:
`brewland/themes/colors.json`

This file contains the hex codes for both flavors. When adding new applications to the theme switcher, you should pull colors from this JSON or the generated CSS files.

## Theme Switcher
The `theme_switcher.sh` script handles the heavy lifting of updating individual application configs.

**Manual Toggle:**
```bash
./brewland/theme_switcher.sh
```
Or use the keybinding: `Super + Shift + Z`.

**Supported Applications:**
- **Hyprland**: Updates window borders and workspace colors.
- **Waybar**: Switches between `colors/mocha.css` and `colors/latte.css`.
- **SwayNC**: Updates notification center colors.
- **Kitty**: Changes the included terminal theme.
- **VSCodium / Antigravity**: Updates the color and icon themes in settings.
- **Rofi**: Updates the Rasi color variables.
- **Fastfetch & Cava**: Hot-reloads configurations with new links.

## Customizing Flavors
If you want to modify a specific color:
1.  Update the hex value in `brewland/themes/colors.json`.
2.  Update the corresponding entries in `waybar/colors/` and `swaync/colors/`.
3.  Run the theme switcher to apply the change.
