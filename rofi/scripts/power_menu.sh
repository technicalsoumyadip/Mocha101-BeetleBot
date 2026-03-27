#!/bin/bash

# find rofi configs - check standard location or fallback to script's parent
dir="$HOME/.config/rofi"
if [ ! -d "$dir" ]; then
    dir="$(dirname "$(readlink -f "$0")")/.."
fi

# base command for rofi
rofi_cmd="rofi -dmenu -i -p Power -theme $dir/NoSearchConfig.rasi"

# menu options
actions="󰐥 Poweroff\n󰜉 Reboot\n󰤄 Suspend\n󰈆 Logout\n󱎫 Poweroff Timer"

# helper to show timer durations
show_timer_menu() {
    printf "󱎫  5 mins\n󱎫  10 mins\n󱎫  15 mins\n󱎫  30 mins\n󱎫  45 mins\n󱎫  1 hr" | $rofi_cmd
}

selection=$(printf "$actions" | $rofi_cmd)

case "$selection" in
    *Poweroff) systemctl poweroff ;;
    *Reboot)   systemctl reboot ;;
    *Suspend)  systemctl suspend ;;
    *Logout)   hyprctl dispatch exit ;;
    *"Poweroff Timer")
        timer_choice=$(show_timer_menu)
        case "$timer_choice" in
            *"5 mins") m=5 ;;
            *"10 mins") m=10 ;;
            *"15 mins") m=15 ;;
            *"30 mins") m=30 ;;
            *"45 mins") m=45 ;;
            *"1 hr") m=60 ;;
        esac
        
        # schedule shutdown if a time was picked
        if [ -n "$m" ]; then
            shutdown +"$m"
            notify-send "Poweroff Timer" "System will power off in $m minutes"
        fi
        ;;
esac