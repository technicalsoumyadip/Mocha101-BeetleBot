# BrewLand v2.0

A refined Hyprland configuration centered on the Catppuccin Mocha and Latte palettes. BrewLand prioritizes a minimalist workflow, smooth animations, and consistent system-wide aesthetics.

![BrewLand Preview](https://github.com/user-attachments/assets/548e7985-0143-4f40-b35c-d10ef3d750e1)

## Core Concepts

- **Dynamic Theming**: Swap between Mocha (Dark) and Latte (Light) on-the-fly. The system-wide colors are controlled by `brewland/themes/colors.json`.
- **Workflow**: Optimized for a scrolling-stack layout with a dedicated "Magic Shelf" (special workspace) for background tasks.
- **Modularity**: Configurations for Hyprland, Waybar, and SwayNC are split into logical modules for easy modification.

## Installation

### Remote Install (Recommended)
This clones the repository to `~/BrewLand`, records the installation path for future updates, and launches the installer.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BeetleBot/BrewLand/main/setup.sh)"
```

### Manual Install
```bash
git clone https://github.com/BeetleBot/BrewLand.git
cd BrewLand && ./install.sh
```

## Essential Keybindings

| Key | Action |
| :--- | :--- |
| `Super + Return` | Terminal (Kitty) |
| `Super + Space` | App Launcher (Rofi) |
| `Super + Shift + Z` | Toggle Theme (Dark/Light) |
| `Super + Shift + P` | Package & Update Menu |
| `Super + S` | Toggle Magic Shelf |
| `Super + R` | Reload UI (Waybar/SwayNC) |
| `Super + Q` | Close Active Window |

*Full keybinds are defined in `hypr/HLconfigs/keybindings.conf`.*

## System Management

### Updating
BrewLand can be updated directly from the UI:
1. Open the Package Menu (`Super + Shift + P`).
2. Select **UPDATE PACKAGES** -> **BREWLAND**.
This will pull the latest code and re-apply configurations automatically.

### Health Check
If you experience issues, run the verification tool:
```bash
./brewland/brewland-doctor.sh
```
It verifies package dependencies, configuration symlinks, and the status of background services.

## Customization
- **Monitor Settings**: `hypr/HLconfigs/monitors.conf`
- **Window Rules**: `hypr/HLconfigs/windowsandworkspaces.conf`
- **Bar Layout**: `waybar/config.jsonc`
- **Global Colors**: `brewland/themes/colors.json`

---
*Maintained by BeetleBot.*
