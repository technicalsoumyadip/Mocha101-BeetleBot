<div align="center">

# **☕ Mocha 101**

**A sharp (rounded, if you prefer), elegant Hyprland setup brewed with Catppuccin Mocha.**  
</div>

### **About This Setup**

Mocha 101 is a dotfiles configuration that blends **style, performance, and minimalism** into one cohesive Hyprland experience. Built around the **Catppuccin Mocha** palette, it delivers rich colors, crisp edges (only if you need) 😁, and zero fluff.  
Think of it as the perfect espresso shot for your Linux desktop: smooth, bold, and just the right amount of aesthetic kick.

### **🎨 Design Highlights**

**Zero-nonsense philosophy:** Perfect blur for my taste and in my opinion. Clean. Minimal. Fast. No-Bloat, whatsoever.  

### **✨ Feature Highlights**

* **Wallpapers** — Uses **awww** for dynamic wallpaper switching via the awww wallpaper switcher extension in **Vicinae**.  
* **Unified theme** — Catppuccin Mocha everywhere, from terminal (Kitty) to the notification center (SwayNC).  
* **Vicinae Ecosystem** — Deeply integrated for application launching, system controls (Bluetooth/Wifi), clipboard history, and emoji search.  
* **Notification center** — Beautifully styled **SwayNC** with custom CSS, integrated directly with the Waybar logo.  
* **Master Layout** — Configured for a productive master-stack workflow with a custom "Shelf" special workspace.  
* **Integrated lock screen** — Cohesive **Hyprlock** + **Hypridle** setup.

### **☕ Screenshots**

Note: I am such a lazy guy. I did not take that many screenshots. These screenshots are just here for you guys to get the actual feel of the configuration. Thanks.

#### **Desktop with Waybar**

<img width="1920" height="1080" alt="Desktop Preview" src="https://github.com/user-attachments/assets/a2c85b17-50a8-408d-8976-b71a37c9444d">

#### **App launcher (Vicinae)**

<img width="881" height="576" alt="App Launcher" src="https://github.com/user-attachments/assets/1a21ebdc-62c2-4ee5-9256-0394268e60ab">

#### **Wallpaper Picker (Vicinae)**

<img width="821" height="539" alt="Wallpaper Picker" src="https://github.com/user-attachments/assets/61e54b5a-5d1f-4931-a5fd-c9918bc0d428">

#### **Wifi & Bluetooth menus (Vicinae)**

<img width="824" height="528" alt="Wifi Menu" src="https://github.com/user-attachments/assets/9be32d83-ea71-4224-82ed-5cf8005d728d">

### **⚙️ Installation**
Fire it up in just a few steps:  
```
git clone https://github.com/BeetleBot/Mocha101.git
```
```
cd Mocha101  
```
```
chmod +x install.sh  
```
```
./install.sh
```
The installer handles everything:

* Verifies you're on Arch Linux  
* Sets up **yay** if needed  
* Installs all required dependencies (AUR + official repos)  
* Backs up existing configs to ~/ConfigBackup/  
* Deploys new configs to ~/.config/  
* Copies walls.sh to your home directory  
* Suggests a reboot to apply changes

### **⌨️ Keybindings**

The **Super** key (Windows key) is your main modifier.

#### **General & System**

| Keybind | Action |
| :---- | :---- |
| Super + Return | Open Terminal (Kitty) |
| Super + Space | Open App Launcher (Vicinae) |
| Super + Q | Kill Active Window |
| Super + X | Exit Hyprland |
| Super + Shift + X | Poweroff |
| Super + Shift + R | Reboot |
| Super + Shift + L | Lock Screen (Hyprlock) |
| Super + Alt + Space | Search Files (Vicinae) |
| Super + . | Emoji Search (Vicinae) |
| Super + / | Clipboard History (Vicinae) |
| Super + Alt + N | Wifi Commander (Vicinae) |
| Super + Alt + B | Bluetooth Manager (Vicinae) |
| Super + Shift + W | Wallpaper Grid (Awww) |
| Super + R | Reload Waybar |

#### **Applications**

| Keybind | Action |
| :---- | :---- |
| Super + E | File Manager (Nautilus) |
| Super + W | Zen Browser |
| Super + C | Codium |
| Super + O | Obsidian |
| Super + F | Fadein |
| Super + Shift + M | Music Player (rmpc) |

#### **Screenshots (Hyprshot)**

| Keybind | Action |
| :---- | :---- |
| Super + Alt + 1 | Screenshot Monitor |
| Super + Alt + 2 | Screenshot Window |
| Super + Alt + 3 | Screenshot Region |

#### **Navigation & Layout**

| Keybind | Action |
| :---- | :---- |
| Super + Arrows | Move Focus (Up/Down/Left/Right) |
| Super + 0-9 | Switch Workspace |
| Super + Shift + 0-9 | Move Window to Workspace |
| Super + S | Toggle "Magic" Shelf (Special Workspace) |
| Super + Shift + S | Minimize Window (Move to Special) |
| Super + V | Toggle Floating |
| Super + G | Toggle Group (Tabs) |
| Super + Tab | Cycle Group Active |

### **🧰 Core Components**

| Type | Tool | Description |
| :---- | :---- | :---- |
| Compositor | **Hyprland** | Dynamic tiling Wayland compositor |
| Bar | **Waybar** | Highly customized status bar with blur |
| Wallpapers | **Awww** | Handles dynamic background management |
| Notifications | **SwayNC** | Notification center with Catppuccin CSS |
| Terminal | **Kitty** | GPU-accelerated terminal emulator |
| Launcher | **Vicinae** | Search-driven application and system launcher |
| Screenshots | **Hyprshot** | Essential screenshot utility |
| Lock Screen | **Hyprlock** | Integrated screen lock |
| Font | **iMWritingMono Nerd** | Primary font for Waybar and system UI |
