<div align="center">

# ☕ Mocha 101

**A sharp(rounded, if you prefer), elegant Hyprland setup brewed with Catppuccin Mocha.**

</div>

***

### About This Setup

Mocha 101 is a dotfiles configuration that blends **style, performance, and minimalism** into one cohesive Hyprland experience. Built around the **Catppuccin Mocha** palette, it delivers rich colors, crisp edges(only if you need)😁, and zero fluff.

Think of it as the perfect espresso shot for your Linux desktop: smooth, bold, and just the right amount of aesthetic kick.

### 🎨 Design Highlights

**Zero-nonsense philosophy:** Perfect blur for my taste and in my opinion. Clean. Minimal. Fast. No-Bloat, whatsoever.

**Catppuccin Mocha core:**
- **Base** `#1e1e2e` — Deep, velvety background
- **Lavender** `#b4befe` — Soft highlight tone

### ✨ Feature Highlights

- **Wallpapers** — Uses awww for dynamic wallpaper switching using awww wallpaper switcher in vicinae.
- **Unified theme** — Catppuccin Mocha everywhere, from terminal to notifications
- **Custom Rofi** — Tweaked adi1090x Type 1/Style 3 theme for perfect color harmony
- **Notification center** — Beautifully styled Swaync with custom CSS
- **Integrated lock screen** — Cohesive Hyprlock + Hypridle setup
- **Lean and snappy** — Built for performance and low resource overhead

### ☕ Screenshots

Note: I am such a lazy guy. I did not take that many screenshot. These screenshots are just here, for you guys to get the actual feel of the configuration. Thanks.

#### Desktop with waybar
<img width="1920" height="1080" alt="2026-01-05-185740_hyprshot" src="https://github.com/user-attachments/assets/a2c85b17-50a8-408d-8976-b71a37c9444d" />

#### App launcher (vicinae)
<img width="881" height="576" alt="2026-01-05-185753_hyprshot" src="https://github.com/user-attachments/assets/1a21ebdc-62c2-4ee5-9256-0394268e60ab" />

#### Wallpaper Picker (vicinae)
<img width="821" height="539" alt="2026-01-05-185816_hyprshot" src="https://github.com/user-attachments/assets/61e54b5a-5d1f-4931-a5fd-c9918bc0d428" />

#### Wifi menu (vicinae)
<img width="824" height="528" alt="2026-01-05-185833_hyprshot" src="https://github.com/user-attachments/assets/9be32d83-ea71-4224-82ed-5cf8005d728d" />

#### Bluetooth menu (vicinae)
<img width="841" height="528" alt="2026-01-05-185850_hyprshot" src="https://github.com/user-attachments/assets/260d2989-ac6c-4ad7-86a5-d5b00300cda2" />

#### Just... idk... A typical screenshot of a hyprland user. Maybe?
<img width="1920" height="1080" alt="2026-01-05-192812_hyprshot" src="https://github.com/user-attachments/assets/9d76934a-817e-4a98-ad76-5ce8ca3d2800" />

#### Notification
<img width="575" height="275" alt="2026-01-05-192838_hyprshot" src="https://github.com/user-attachments/assets/f42b5c49-798a-4d0b-a983-28fa418bafc2" />

### ⚙️ Installation

Fire it up in just a few steps:

```bash
git clone https://github.com/BeetleBot/Mocha101.git
```
```bash
cd Mocha101
```
```bash
chmod +x install.sh
```
```bash
./install.sh
```

The installer handles everything:

- Verifies you're on Arch Linux
- Sets up **yay** if needed
- Force installs all required dependencies (AUR + official repos)
- Backs up existing configs to `~/ConfigBackup/`
- Deploys new configs to `~/.config/`
- Copies `walls.sh` to your home directory
- Optionally installs Oh My Zsh
- Suggests a reboot to apply changes

### ⌨️ Keybindings

The **Super** key (Windows key) is your main modifier.

### General & System

| Keybind | Action |
|---------|--------|
| `Super + Return` | Open Terminal (Kitty) |
| `Super + Q` | Kill Active Window |
| `Super + Space` | Open App Launcher (Vicinae) |
| `Super + X` | Logout |
| `Super + Shift + X` | Poweroff |
| `Super + Shift + R` | Reboot |
| `Super + Alt + Space` | Search Files (Vicinae) |
| `Super + .` | Emoji (Vicinae) |
| `Super + /` | Clipboard (Vicinae) |
| `Super + Alt + N` | Wifi - Scan, Connect and Disconnect. (Vicinae) |
| `Super + Alt + B` | Bluetooth - Scan, Pair, Connect and Disconnet (Vicinae) |
| `Super + Shift + W` | Wallpaper Picker (vicinae) |
| `Super + Shift + L` | Lock Screen |
| `Super + V` | Toggle Floating Window |
| `Super + P` | Pseudo Tiling (Dwindle) |
| `Super + J` | Toggle Split (Dwindle) |

### Applications

| Keybind | Action |
|---------|--------|
| `Super + E` | File Manager (Dolphin) |
| `Super + W` | Zen Browser |
| `Super + C` | VS Code |
| `Super + O` | Obsidian |
| `Super + F` | Fadein |

### Scripts & Utilities

| Keybind | Action |
|---------|--------|
| `Super + R` | Reload Waybar |

### Screenshots

| Keybind | Action |
|---------|--------|
| `Super + Alt + 1` | Screenshot Monitor |
| `Super + Alt + 2` | Screenshot a Window |
| `Super + Alt + 3` | Screenshot Region |

### Navigation

| Keybind | Action |
|---------|--------|
| `Super + Arrows` | Move Focus (Up/Down/Left/Right) |
| `Super + 0-9` | Switch Workspace |
| `Super + Shift + 0-9` | Move Window to Workspace |
| `Super + S` | Toggle Special Workspace (Scratchpad) |
| `Super + Mouse` | Move/Resize Window |

### 🧰 Core Components

| Type | Tool | Description |
|------|------|-------------|
| Compositor | Hyprland | Next-gen dynamic tiling Wayland compositor |
| Bar | Waybar | Clean and modular status bar |
| Wallpapers | Hyprpaper | Handles background rotations |
| Notifications | Swaync | Notification center with CSS styling |
| Terminal | Kitty | GPU-accelerated terminal |
| Launcher | Vicinae | Quick app launcher |
| Bluetooth | Vicinae Extension for Bluetooth | For the Waybar module (Middle Click) |
| Network | Vicinae Extension for Wifi | For the Waybar module (Middle Click) |
| Screenshots | Hyprshot | Fast and minimal |
| Lock Screen | Hyprlock + Hypridle | Screen lock and idle control |
| System Info | Fastfetch | System info in Mocha colors (Manual configuration needed) |
| Shell | ZSH + Oh My Zsh | Command-line, styled beautifully (Manual configuration needed) |
| Display Manager | SDDM | Recommended login manager (Manual configuration needed) |
| Font | JetBrains Mono Nerd | Clean, developer-friendly font |

**Optional tools:**
- File Manager — Dolphin
- Browser — Zen Browser
- Desktop Integration — KDE Plasma (fallback environment)

### 🎨 App-Specific Styling

| App | Theme | Notes |
|-----|-------|-------|
| Zen Browser | [catppuccin/zen-browser](https://github.com/catppuccin/zen-browser) | Manual configuration |
| VS Code | [catppuccin/vscode](https://github.com/catppuccin/vscode) | Manual configuration |
| Kitty | Modified Mocha | Included |
| Rofi | adi1090x (Type 1/Style 3) | Mocha-tuned colors |
| SDDM | [catppuccin/sddm](https://github.com/catppuccin/sddm) | Manual configuration |
| Swaync | Custom CSS | Included in repo |

### 🌌 KDE Integration

Want Dolphin and Qt apps to blend perfectly with Hyprland? Set KDE Plasma as a fallback session. It keeps theme consistency system-wide — no mismatched UI nightmares.

***

<div align="center">

**Mocha 101 — because a good desktop setup should feel as smooth as your first sip of coffee.**

</div>

---
