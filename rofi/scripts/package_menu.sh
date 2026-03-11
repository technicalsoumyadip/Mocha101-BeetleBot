#!/bin/bash

terminal="kitty"

rofi_cmd="rofi -dmenu -theme ~/.config/rofi/NoSearchConfig.rasi"

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
  FLATPAK\n\
󰜺  EXIT\n" | $rofi_cmd
}

remove_menu() {
printf \
"󰆴  PACMAN\n\
󰆴  AUR\n\
  FLATPAK\n\
󰜺  EXIT\n" | $rofi_cmd
}

update_menu() {
printf \
"󰚰  PACMAN\n\
󰚰  AUR\n\
  FLATPAK\n\
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
        pkg=$(pacman -Slq | rofi -dmenu -i -p "Install (PACMAN)")
        [ -n "$pkg" ] && $terminal -e bash -c "sudo pacman -S $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"AUR")
        pkg=$(yay -Slq | rofi -dmenu -i -p "Install (AUR)")
        [ -n "$pkg" ] && $terminal -e bash -c "yay -S $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"FLATPAK")
        app=$(flatpak search --columns=application | rofi -dmenu -i -p "Install (FLATPAK)")
        [ -n "$app" ] && $terminal -e bash -c "flatpak install flathub $app; echo; read -p 'Press Enter to close...'"
        ;;

    esac
;;

*"REMOVE PACKAGES")
    sub=$(remove_menu)

    case "$sub" in

    *"PACMAN")
        pkg=$(pacman -Qq | rofi -dmenu -i -p "Remove (PACMAN)")
        [ -n "$pkg" ] && $terminal -e bash -c "sudo pacman -R $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"AUR")
        pkg=$(yay -Qqm | rofi -dmenu -i -p "Remove (AUR)")
        [ -n "$pkg" ] && $terminal -e bash -c "yay -R $pkg; echo; read -p 'Press Enter to close...'"
        ;;

    *"FLATPAK")
        app=$(flatpak list --app --columns=application | rofi -dmenu -i -p "Remove (FLATPAK)")
        [ -n "$app" ] && $terminal -e bash -c "flatpak uninstall $app; echo; read -p 'Press Enter to close...'"
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

    *"FLATPAK")
        $terminal -e bash -c "flatpak update; echo; read -p 'Press Enter to close...'"
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