<div align="center">

<img width="256" height="256" alt="Mocha 101 Icon" src="https://github.com/user-attachments/assets/ba428934-8c72-4dd8-946e-2c1abbfff1e1" />

# ☕ Mocha 101

**A sharp, elegant Hyprland setup brewed with Catppuccin Mocha.**

</div>

***

### About This Setup

Mocha 101 is a dotfiles configuration that blends **style, performance, and minimalism** into one cohesive Hyprland experience. It’s built around the **Catppuccin Mocha** palette — rich colors, crisp edges, and zero fluff.

Think of it as the perfect espresso shot for your Linux desktop: smooth, bold, and just the right amount of aesthetic kick.

### 🎨 Design Highlights

- **Zero-radius design:** everything has a sharp, modern edge. No curves here — just pure geometry.  
- **Catppuccin Mocha core:** the theme that ties everything together.  
  - **Base:** `#1e1e2e` — dark, velvety background  
  - **Lavender:** `#b4befe` — soft highlight tone  
  - **Mauve:** `#cba6f7` — elegant secondary accent  

### ✨ Feature Highlights

- **Dynamic wallpapers** — A custom `walls.sh` script cycles wallpapers seamlessly.  
- **Unified theme** — Catppuccin Mocha everywhere, from your terminal to your notifications.  
- **Custom Rofi** — Tweaked adi1090x Type 1 / Style 3 theme for perfect color harmony.  
- **Notification center** — Beautifully styled **Swaync** with custom CSS.  
- **Integrated lock screen** — Cohesive **Hyprlock + Hypridle** setup.  
- **Lean and snappy** — Built for performance and low resource overhead.

### ⚙️ Installation (Arch Linux)

Fire it up in just a few steps:

```bash
git clone https://github.com/BeetleBot/Mocha101.git
cd Mocha101
chmod +x install.sh
./install.sh
```

The installer will:

- Check that you’re on Arch Linux.  
- Set up **yay** if you don’t already have it.  
- Install all required dependencies (AUR + official).  
- Backup existing configs to `~/ConfigBackup/`.  
- Copy new configs into `~/.config/`.  
- Optionally install **Oh My Zsh**.  
- Offer a friendly reboot prompt to apply everything.

### 🧰 Core Components

| Type | Tool | Description |
|------|------|-------------|
| Compositor | Hyprland | Next‑gen dynamic tiling Wayland compositor |
| Bar | Waybar | Clean and modular status bar |
| Wallpapers | Hyprpaper | Handles background rotations |
| Notifications | Swaync | Notification center with CSS styling |
| Terminal | Kitty | GPU‑accelerated terminal |
| Launcher | Rofi-wayland | Quick app launcher |
| Screenshots | Hyprshot | Fast and minimal |
| Lock Screen | Hyprlock + Hypridle | Screen lock and idle control |
| System Info | Fastfetch | System info in Mocha colors |
| Shell | ZSH + Oh My Zsh | Command‑line, styled beautifully |
| Display Manager | SDDM | Recommended login manager |
| Font | JetBrains Mono Nerd | Clean, developer‑friendly font |

**Optional tools:**  
- File Manager — *Dolphin*  
- Browser — *Zen Browser*  
- Desktop Integration — *KDE Plasma (fallback environment)*  

### 🎨 App‑Specific Styling

| App | Theme | Notes |
|-----|--------|------|
| Zen Browser | [catppuccin/zen-browser](https://github.com/catppuccin/zen-browser) |  |
| VS Code | [catppuccin/vscode](https://github.com/catppuccin/vscode) |  |
| Kitty | Modified Mocha | Included |
| Rofi | adi1090x (Type 1 / Style 3) | Mocha‑tuned colors |
| SDDM | [catppuccin/sddm](https://github.com/catppuccin/sddm) |  |
| Swaync | Custom CSS | Included in repo |

### 💻 Terminal Vibes

ZSH runs with a **custom Powerlevel10k** prompt, colored to match Catppuccin Mocha.  
Dark backgrounds, glowing accents, and a smooth typing rhythm make every line of code satisfying.

### 🌌 KDE Integration

Want Dolphin and Qt apps to blend perfectly with Hyprland? Set KDE Plasma as a fallback session. It keeps theme consistency system‑wide — no mismatched UI nightmares.

***

<div align="center">

**Mocha 101 — because a good desktop setup should feel as smooth as your first sip of coffee.**

</div>

***
