<img width="2048" height="2048" alt="Icon" src="https://github.com/user-attachments/assets/ba428934-8c72-4dd8-946e-2c1abbfff1e1" />

# Mocha 101

A sharp-edged Hyprland dotfiles configuration featuring the Catppuccin Mocha color palette. Clean, minimal, and performance-focused.

![Catppuccin Mocha](https://img.shields.io/badge/theme-Catppuccin%20Mocha-cba6f7?style=for-the-badge)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-5865f2?style=for-the-badge)

## 🎨 Theme

Built on the beautiful [Catppuccin Mocha](https://catppuccin.com/palette/) color palette with zero border-radius design philosophy for crisp, angular aesthetics.

**Primary Colors:**
- Base: `#1e1e2e`
- Lavender: `#b4befe`
- Mauve: `#cba6f7`

## ✨ Features

- **Dynamic Wallpapers**: Custom script loads random wallpapers from designated folder
- **Custom Rofi Theme**: Based on adi1090x's Type 1 / Style 3 with modified Catppuccin colors
- **Unified Theme**: Consistent Catppuccin Mocha across all applications
- **Notification Center**: Swaync with custom CSS styling
- **Lock Screen**: Hyprlock with Hypridle integration

## 📦 Dependencies

### Core Components
- **Window Manager**: Hyprland
- **Status Bar**: Waybar
- **Wallpaper Manager**: Hyprpaper
- **Notifications**: Swaync
- **Terminal**: Kitty
- **Screenshots**: Hyprshot
- **Launcher**: Rofi
- **Lock Screen**: Hyprlock + Hypridle
- **System Info**: Fastfetch
- **Shell**: ZSH with Oh My Zsh
- **Display Manager**: SDDM (recommended if switching from GDM)

### Optional
- **File Manager**: Dolphin (KDE integration)
- **Browser**: Zen Browser
- **DE Fallback**: KDE Plasma for global theming

## 🎨 Customizations

### Applications

| Application | Theme Source | Notes |
|-------------|--------------|-------|
| Zen Browser | [catppuccin/zen-browser](https://github.com/catppuccin/zen-browser) | - |
| VS Code | [catppuccin/vscode](https://github.com/catppuccin/vscode) | - |
| Kitty | [catppuccin/kitty](https://github.com/catppuccin/kitty/tree/main/themes) | Slightly modified |
| Rofi | [adi1090x/rofi](https://github.com/adi1090x/rofi) | Type 1, Style 3 (modified colors) |
| SDDM | [catppuccin/sddm](https://github.com/catppuccin/sddm) | - |
| Swaync | Custom CSS | Included in repo |

### Terminal Setup
- **ZSH Theme**: Powerlevel10k
- **Prompt**: Customized for Mocha palette

### KDE Integration
For Dolphin file manager integration with KDE themes in Hyprland:
