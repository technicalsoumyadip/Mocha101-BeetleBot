#!/bin/bash

# Check if the active window is floating
IS_FLOATING=$(hyprctl activewindow -j | jq -r ".floating")

if [ "$IS_FLOATING" == "true" ]; then
    # If it's floating, just tile it
    hyprctl dispatch togglefloating
else
    # If it's tiled, float it, resize it, and center it
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact 60% 60%
    hyprctl dispatch centerwindow
fi
