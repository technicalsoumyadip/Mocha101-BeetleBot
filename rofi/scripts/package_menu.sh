#!/bin/bash

terminal="kitty"

rofi_cmd="rofi -dmenu -theme ~/.config/rofi/NoSearchConfig.rasi"
rofi_search_cmd="rofi -dmenu -i -theme ~/.config/rofi/ListSearchConfig.rasi"

main_menu() {
printf \
"󰏖  INSTALL PACKAGES\n\
󰆴  REMOVE PACKAGES\n\
󰚰  UPDATE PACKAGES\n\
󰃢  CLEAN CACHE\n" | $rofi_cmd
}

install_menu() {
printf \
"󰏖  PACMAN\n\
󰏖  AUR\n\
󰜺  EXIT\n" | $rofi_cmd
}

remove_menu() {
printf \
"󰆴  PACMAN\n\
󰆴  AUR\n\
󰜺  EXIT\n" | $rofi_cmd
}

update_menu() {
printf \
"󰚰  PACMAN\n\
󰚰  AUR\n\
󰚰  BREWLAND\n\
󰜺  EXIT\n" | $rofi_cmd
}

cache_menu() {
printf \
"󰃢  Clear Old Packages Cache\n\
󰃢  Clear System Cache\n\
󰜺  EXIT\n" | $rofi_cmd
}

choice=$(main_menu)

case "$choice" in

*"INSTALL PACKAGES")
    sub=$(install_menu)

    case "$sub" in

    *"PACMAN")
        pkg=$(pacman -Slq | $rofi_search_cmd -p "Install (PACMAN)")
        [ -n "$pkg" ] && $terminal -e bash -c "sudo pacman -S $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"AUR")
        pkg=$(yay -Slq | $rofi_search_cmd -p "Install (AUR)")
        [ -n "$pkg" ] && $terminal -e bash -c "yay -S $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    esac
;;

*"REMOVE PACKAGES")
    sub=$(remove_menu)

    case "$sub" in

    *"PACMAN")
        pkg=$(pacman -Qq | $rofi_search_cmd -p "Remove (PACMAN)")
        [ -n "$pkg" ] && $terminal -e bash -c "sudo pacman -R $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"AUR")
        pkg=$(yay -Qqm | $rofi_search_cmd -p "Remove (AUR)")
        [ -n "$pkg" ] && $terminal -e bash -c "yay -R $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    esac
;;

*"UPDATE PACKAGES")
    sub=$(update_menu)

    case "$sub" in

    *"PACMAN")
        $terminal -e bash -c "sudo pacman -Syu; echo; read -p 'Press Enter to close...'"
        ;;

    *"AUR")
        $terminal -e bash -c "yay -Sua; echo; read -p 'Press Enter to close...'"
        ;;

    *"BREWLAND")
        # Dynamic discovery
        REPO_PATH=""
        if [ -f "$HOME/.config/brewland/repo.path" ]; then
            REPO_PATH=$(cat "$HOME/.config/brewland/repo.path")
        elif [ -d "$HOME/BrewLand/.git" ]; then
            REPO_PATH="$HOME/BrewLand"
        elif [ -d "$HOME/Projects/Brewland/.git" ]; then
            REPO_PATH="$HOME/Projects/Brewland"
        fi

        if [ -n "$REPO_PATH" ] && [ -d "$REPO_PATH" ]; then
            $terminal -e bash -c "cd $REPO_PATH; echo 'Updating BrewLand in $REPO_PATH...'; git pull; ./install.sh; echo; read -p 'Update complete. Press Enter to close...'"
        else
            notify-send -a "BrewLand Update" "Failed" "Repository path not found. Please run install.sh manually."
        fi
        ;;
    
    esac
;;

*"CLEAN CACHE")
    sub=$(cache_menu)

    case "$sub" in

    *"Clear Old Packages Cache")
        $terminal -e bash -c "sudo pacman -Sc; echo; read -p 'Press Enter to close...'"
        ;;

    *"Clear System Cache")
        $terminal -e bash -c "sudo journalctl --vacuum-time=7d; sudo rm -rf /tmp/*; echo 'System cache cleaned'; echo; read -p 'Press Enter to close...'"
        ;;

    esac
;;

esac