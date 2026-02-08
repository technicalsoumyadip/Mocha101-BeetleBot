<div align="center">

# **☕ BrewLand v2.0**

**An elegant Hyprland setup brewed with Catppuccin Mocha and Latte.**  
</div>

### **About This Setup**

BrewLand is a dotfiles configuration that blends **style, performance, and minimalism** into one cohesive Hyprland experience. Built around the **Catppuccin Mocha and Latte** palette, it delivers rich colors, smooth animations and zero fluff.  

Think of it as the perfect espresso shot for your Linux desktop: smooth, bold, and just the right amount of aesthetic kick.

### **🎨 Design Highlights**

**Zero-nonsense philosophy:** Perfect blur for my taste and in my opinion. Clean. Minimal. Fast. No-Bloat, whatsoever.  

### **✨ Feature Highlights**

* **Wallpapers** — Uses **swww** for dynamic wallpaper switching via a custom wallpaper picker made with rofi.
* **Dual theme** — Catppuccin Mocha and Latte, everywhere. From Terminal to Notification centre. You can manually configure the same for GTK and QT apps as well. Check theme_switcher.sh for the details.
* **Rofi Ecosystem** — Deeply integrated for application launching, emoji picker, file search, wallpaper picker and music picker.
* **Notification center** — Beautifully styled **SwayNC** with custom CSS, integrated directly with the Waybar module.  
* **Master Layout** — Configured for a productive master-stack workflow with a custom "Shelf" ie., special workspace.  
* **Integrated lock screen** — Cohesive **Hyprlock** + **Hypridle** setup.
* **Wifi and Bluetooth** - A well built impala and bluetui for Bluetooth and Wifi setups. Integrated with a custom keybind and respective waybar module.

### **☕ Screenshots**

#### Full - Dark
<img width="1920" height="1080" alt="20260122_163322" src="https://github.com/user-attachments/assets/0ed748b8-c7e5-4b9d-a1b0-d74369604d6f" />

#### Full - Light
<img width="1920" height="1080" alt="20260122_163306" src="https://github.com/user-attachments/assets/8f8d0824-cc3f-4f0e-a791-036e91522315" />

#### Waybar - Dark
<img width="1920" height="87" alt="20260122_164623" src="https://github.com/user-attachments/assets/b5284412-9a95-426a-b729-6b8fc4d813d3" />

#### Waybar - Light
<img width="1920" height="104" alt="20260122_164614" src="https://github.com/user-attachments/assets/0a9920b5-c750-4b86-9c39-3dc602ae97d7" />

#### App Launcher - Dark
<img width="581" height="402" alt="20260122_163513" src="https://github.com/user-attachments/assets/719aa639-330b-42ee-b244-97ee5cab29cb" />

#### App Launcher - Light
<img width="553" height="380" alt="20260122_163541" src="https://github.com/user-attachments/assets/9fd8cdbb-7fa0-409d-8b7f-0a075610a46a" />

#### File Search - Dark
<img width="541" height="334" alt="20260122_163805" src="https://github.com/user-attachments/assets/1ed34009-5fcd-4bea-a940-5c8a4f4869e5" />

#### File Search - Light
<img width="567" height="332" alt="20260122_163752" src="https://github.com/user-attachments/assets/017550a5-0c9e-4902-b3cd-0753a850520d" />

#### Emoji Picker - Dark
<img width="526" height="416" alt="20260122_165423" src="https://github.com/user-attachments/assets/33b1d3fb-f568-4de8-95d7-5e61938f4565" />

#### Emoji Picker - Light
<img width="507" height="408" alt="20260122_165415" src="https://github.com/user-attachments/assets/1b6b6445-ed62-4a68-933e-309d0b33bca8" />

#### Clipboard Manager - Dark
<img width="536" height="355" alt="20260122_165432" src="https://github.com/user-attachments/assets/86a6da0c-eae6-498b-bf10-38cef79fbed9" />

#### Clipboard Manager - Light
<img width="526" height="349" alt="20260122_165444" src="https://github.com/user-attachments/assets/ce09ff41-cbd6-4302-ac01-d296a2fd5c31" />

#### Wallpaper Picker - Dark
<img width="1830" height="514" alt="20260122_163104" src="https://github.com/user-attachments/assets/d0311a50-89e1-4c2e-9598-a31feee0d2fd" />

#### Wallpaper Picker - Light
<img width="1807" height="505" alt="20260122_163150" src="https://github.com/user-attachments/assets/94d3474d-b34b-4601-b38f-bb57fd1838bb" />

#### SwayNC - Dark
<img width="568" height="347" alt="20260122_164430" src="https://github.com/user-attachments/assets/d288702c-c489-4658-8ca8-df0d4f1ff56c" />

#### SwayNC - Light
<img width="572" height="340" alt="20260122_164435" src="https://github.com/user-attachments/assets/dd661f2b-8f90-43b4-86ab-89d71531c202" />

#### Custom Music Launcher - Dark
<img width="564" height="375" alt="20260122_164749" src="https://github.com/user-attachments/assets/619a6a7b-7de6-4d3c-8410-a268d9899d72" />

#### Custom Music Launcher - Light
<img width="524" height="366" alt="20260122_164814" src="https://github.com/user-attachments/assets/1d7ff2c9-7ded-4b60-a45c-a268d8db0efb" />

### **⚙️ Installation**
Fire it up in just a few steps(ONLY RUN THIS ON **ARCH LINUX**):  
```
git clone https://github.com/BeetleBot/BrewLand.git
```
```
cd BrewLand  
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
* Deploys new configs to ~/.config/  (or symlink, your choice)
* Suggests a reboot to apply changes

### **⌨️ Keybindings**

The **Super** key (Windows key) is your main modifier.

#### **General & System**

| Keybind | Action |
| :---- | :---- |
| Super + Return | Open Terminal (Kitty) |
| Super + Space | Open App Launcher |
| Super + Q | Kill Active Window |
| Super + X | Exit Hyprland |
| Super + Shift + X | Poweroff |
| Super + Shift + R | Reboot |
| Super + Shift + L | Lock Screen (Hyprlock) |
| Super + Alt + Space | Search Files |
| Super + . | Emoji Search |
| Super + / | Clipboard History |
| Super + Alt + N | Network (impala) |
| Super + Alt + B | Bluetooth Manager (bluetui) |
| Super + Shift + W | Wallpaper Grid |
| Super + R | Reload Waybar |
| Super + Shift + Z | Toggle Theme (Mocha and Latte) |

#### **Applications**

| Keybind | Action |
| :---- | :---- |
| Super + E | File Manager (thunar) |
| Super + W | Zen Browser |
| Super + C | Codium |
| Super + O | Obsidian |
| Super + F | Fadein |
| Super + Shift + M | Music launcher |

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
| Wallpapers | **swww** | Handles dynamic background management |
| Notifications | **SwayNC** | Notification center with Catppuccin CSS |
| Terminal | **Kitty** | GPU-accelerated terminal emulator |
| Launcher | **Rofi** | Search-driven application and system launcher |
| Screenshots | **Grimblast** | Essential screenshot utility |
| Lock Screen | **Hyprlock** | Integrated screen lock |
| Font | **iMWritingMono Nerd** | Primary font for Waybar and system UI |
