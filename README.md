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

- **Dynamic wallpapers** — Custom `walls.sh` script cycles wallpapers seamlessly
- **Unified theme** — Catppuccin Mocha everywhere, from terminal to notifications
- **Custom Rofi** — Tweaked adi1090x Type 1/Style 3 theme for perfect color harmony
- **Notification center** — Beautifully styled Swaync with custom CSS
- **Integrated lock screen** — Cohesive Hyprlock + Hypridle setup
- **Lean and snappy** — Built for performance and low resource overhead

### Screenshots

Note: I am such a lazy guy. I did not take that many screenshot. These screenshots are just here, for you guys to get the actual feel of the configuration. Thanks.

<img width="1920" height="1080" alt="2025-12-22-122925_hyprshot" src="https://github.com/user-attachments/assets/48e63585-2609-4f2a-b81c-83d103cc0350" />

<img width="495" height="416" alt="2025-12-22-122948_hyprshot" src="https://github.com/user-attachments/assets/8671045f-0166-4402-8ad1-a42ba9c2babe" />


### ⚙️ Installation

Fire it up in just a few steps:

```bash
git clone https://github.com/BeetleBot/Mocha101.git
cd Mocha101
chmod +x install.sh
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
| `Super + Space` | Open App Launcher (Rofi) |
| `Super + X` | Logout |
| `Super + Shift + X` | Poweroff |
| `Super + Shift + R` | Reboot |
| `Super + Period` | Emoji picker |
| `Super + /` | Clipboard |
| `Super + Alt + Space` | File browser |
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
| `Super + Shift + W` | Set Random Wallpaper |
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
| Launcher | Rofi-wayland | Quick app launcher |
| Bluetooth | Bluetuith | For the Waybar module |
| Screenshots | Hyprshot | Fast and minimal |
| Lock Screen | Hyprlock + Hypridle | Screen lock and idle control |
| System Info | Fastfetch | System info in Mocha colors |
| Shell | ZSH + Oh My Zsh | Command-line, styled beautifully |
| Display Manager | SDDM | Recommended login manager |
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

### 💻 Terminal Vibes

ZSH runs with a **custom Powerlevel10k** prompt, colored to match Catppuccin Mocha. Dark backgrounds, glowing accents, and a smooth typing rhythm make every line of code satisfying.

### 🌌 KDE Integration

Want Dolphin and Qt apps to blend perfectly with Hyprland? Set KDE Plasma as a fallback session. It keeps theme consistency system-wide — no mismatched UI nightmares.

***

<div align="center">

**Mocha 101 — because a good desktop setup should feel as smooth as your first sip of coffee.**

</div>

---
