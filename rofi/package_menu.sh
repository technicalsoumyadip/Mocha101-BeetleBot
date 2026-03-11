#!/bin/bash

terminal="kitty"

choice=$(printf \
"󰏖   Install package (PACMAN)\n\
󰏖   Install package (AUR)\n\
󰆴   Remove package\n\
󰚰   Update system\n\
󰄬   Clean orphan packages\n" \
| rofi -dmenu -no-custom -disable-history -p "Package Manager")

case "$choice" in

*"Install package (PACMAN)")
    pkg=$(pacman -Slq | rofi -dmenu -i -p "Install (PACMAN)")
    [ -n "$pkg" ] && $terminal -e sudo pacman -S "$pkg"
    ;;

*"Install package (AUR)")
    pkg=$(yay -Slq | rofi -dmenu -i -p "Install (AUR)")
    [ -n "$pkg" ] && $terminal -e yay -S "$pkg"
    ;;

*"Remove package")
    pkg=$(pacman -Qq | rofi -dmenu -i -p "Remove package")
    [ -n "$pkg" ] && $terminal -e sudo pacman -R "$pkg"
    ;;

*"Update system")
    $terminal -e yay -Syu
    ;;

*"Clean orphan packages")
    orphans=$(pacman -Qtdq)
    if [ -n "$orphans" ]; then
        $terminal -e sudo pacman -Rns $orphans
    else
        notify-send "Package Manager" "No orphan packages found"
    fi
    ;;

esac