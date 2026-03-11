#!/bin/bash

chosen=$(printf " Poweroff\n Reboot\n Suspend\n Logout" | rofi -dmenu -i -p "Power")

case "$chosen" in
    *Poweroff) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Logout) hyprctl dispatch exit ;;
esac