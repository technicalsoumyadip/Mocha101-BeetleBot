#!/bin/bash

chosen=$(printf " Poweroff\n Reboot\n Suspend\n Logout" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/NoSearchConfig.rasi)

case "$chosen" in
    *Poweroff) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Logout) hyprctl dispatch exit ;;
esac