<div align="center">

# **☕ Mochalatte v1.0**

**A sharp (rounded, if you prefer), elegant Hyprland setup brewed with Catppuccin Mocha and Latte.**  
</div>

### **About This Setup**

Mochalatte is a dotfiles configuration that blends **style, performance, and minimalism** into one cohesive Hyprland experience. Built around the **Catppuccin Mocha and Latte** palette, it delivers rich colors, crisp edges (only if you need) 😁, and zero fluff.  
Think of it as the perfect espresso shot for your Linux desktop: smooth, bold, and just the right amount of aesthetic kick.

### **🎨 Design Highlights**

**Zero-nonsense philosophy:** Perfect blur for my taste and in my opinion. Clean. Minimal. Fast. No-Bloat, whatsoever.  

### **✨ Feature Highlights**

* **Wallpapers** — Uses **awww** for dynamic wallpaper switching via the awww wallpaper switcher extension in **Vicinae**.  
* **Dual theme** — Catppuccin Mocha and Latte, everywhere. From Terminal to Notification centre. You can manually configure the same for GTK and QT apps as well. Check theme_switcher.sh for the details.
* **Rofi Ecosystem** — Deeply integrated for application launching, and system controls (Bluetooth/Wifi). 
* **Notification center** — Beautifully styled **SwayNC** with custom CSS, integrated directly with the Waybar logo.  
* **Master Layout** — Configured for a productive master-stack workflow with a custom "Shelf" special workspace.  
* **Integrated lock screen** — Cohesive **Hyprlock** + **Hypridle** setup.

### **☕ Screenshots**

Note: I am such a lazy guy. I did not take that many screenshots. These screenshots are just here for you guys to get the actual feel of the configuration. Thanks.

> I can see some straight vertical lines some of the screenshots (especially in the light ones at top). NVM those. Those are just some artifacts of screenshoting tool and not how the actual setup is. This is a super clean setup. I am just lazy to replace those with a clean screenshots.

#### Full - Dark
<img width="1920" height="1080" alt="2026-01-19-154858_hyprshot" src="https://github.com/user-attachments/assets/87e62a18-8c36-4e5d-98e2-58281849342e" />

#### Full - Light
<img width="1920" height="1080" alt="2026-01-19-153910_hyprshot" src="https://github.com/user-attachments/assets/45b7b9e1-d6b5-4802-a490-63064a80d9b4" />

#### App Launcher - Light
<img width="749" height="504" alt="2026-01-19-153936_hyprshot" src="https://github.com/user-attachments/assets/8487e7fa-f1b1-421b-b369-94faa4c23d41" />

#### App Launcher - Dark
<img width="650" height="409" alt="2026-01-19-154058_hyprshot" src="https://github.com/user-attachments/assets/33a3f69c-6c6d-4be4-bbb1-aedfce107f55" />

#### Wifi Menu - Light
<img width="670" height="417" alt="2026-01-19-153947_hyprshot" src="https://github.com/user-attachments/assets/cc3e5565-1546-43c4-8030-24b32519728e" />

#### Wifi Menu - Dark
<img width="650" height="381" alt="2026-01-19-154114_hyprshot" src="https://github.com/user-attachments/assets/f6c64d21-8ee5-4678-864a-1df65a67c3f8" />

#### Bluetooth Menu - Light
<img width="669" height="416" alt="2026-01-19-154004_hyprshot" src="https://github.com/user-attachments/assets/2b71a3f8-94d7-404e-a018-46ab842b91dc" />

#### Bluetooth Menu - Dark
<img width="646" height="400" alt="2026-01-19-154122_hyprshot" src="https://github.com/user-attachments/assets/328851ea-fc87-4a0a-8af0-41b210f9b53b" />

#### Wallpaper Menu - Light
<img width="1848" height="445" alt="2026-01-19-154012_hyprshot" src="https://github.com/user-attachments/assets/e8fe19b8-a911-4967-887a-5d6dc9c04894" />

#### Wallpaper Menu - Dark
<img width="1819" height="433" alt="2026-01-19-155440_hyprshot" src="https://github.com/user-attachments/assets/04ca0461-4a70-4a80-beca-c29f7220268c" />

#### Notification - Light
<img width="572" height="166" alt="2026-01-19-155411_hyprshot" src="https://github.com/user-attachments/assets/62b1e37d-477a-4031-8690-c21961f9338b" />

#### Notification - Dark
<img width="584" height="258" alt="2026-01-19-154130_hyprshot" src="https://github.com/user-attachments/assets/e326fd9b-709b-4b49-b001-8a5b0a371f7e" />

#### SwayNC - Light
<img width="569" height="1080" alt="2026-01-19-155417_hyprshot" src="https://github.com/user-attachments/assets/5fcc0a92-d675-40c1-8ead-d67ae39333ed" />

#### SwayNC - Dark
<img width="588" height="1080" alt="2026-01-19-154151_hyprshot" src="https://github.com/user-attachments/assets/6aef4199-beb6-47f6-af72-e54dec13f32f" />

#### Just - Light
<img width="1920" height="1080" alt="2026-01-19-154517_hyprshot" src="https://github.com/user-attachments/assets/d0cfb97a-c747-4c3d-90ff-1c885cbf062b" />

#### Just - Dark
<img width="1920" height="1080" alt="2026-01-19-154558_hyprshot" src="https://github.com/user-attachments/assets/4a863e66-5087-463b-80c1-6209c0f22713" />


### **⚙️ Installation**
Fire it up in just a few steps:  
```
git clone https://github.com/BeetleBot/Mochalatte.git
```
```
cd Mochalatte  
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
| Super + Alt + Space | Search Files (Vicinae-manual configuration) |
| Super + . | Emoji Search (Vicinae-manual configuration) |
| Super + / | Clipboard History (Vicinae-manual configuration) |
| Super + Alt + N | Network (Rofi) |
| Super + Alt + B | Bluetooth Manager (Rofi) |
| Super + Shift + W | Wallpaper Grid (Rofi+AWWW) |
| Super + R | Reload Waybar |
| Super + Shift + Z | Toggle Theme (Mocha and Latte) |

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
| Launcher | **Rofi** | Search-driven application and system launcher |
| Screenshots | **Hyprshot** | Essential screenshot utility |
| Lock Screen | **Hyprlock** | Integrated screen lock |
| Font | **iMWritingMono Nerd** | Primary font for Waybar and system UI |
