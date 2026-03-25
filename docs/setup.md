# Installation Guide

BrewLand is designed to be installed on **Arch Linux**. The installer handles dependency management, font indexing, and configuration backups automatically.

## Remote Installation (Recommended)

Run the following command in your terminal to bootstrap the entire setup:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BeetleBot/BrewLand/main/setup.sh)"
```

### What the Remote Installer Does:
1.  **Dependency Check**: Verifies `git` and `curl`.
2.  **Clone**: Downloads the repository to `~/BrewLand`.
3.  **Deployment**: Launches the main `install.sh` script.
4.  **Path Recording**: Saves the repository path for future updates.

---

## Manual Installation

If you prefer to clone the repository yourself:

```bash
git clone https://github.com/BeetleBot/BrewLand.git
cd BrewLand
chmod +x install.sh
./install.sh
```

## Post-Installation
- **Reboot**: A system reboot is strongly recommended after the first install.
- **Health Check**: Run `./brewland/brewland-doctor.sh` to ensure all services are active.
