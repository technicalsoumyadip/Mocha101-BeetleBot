#!/bin/bash

# Get the current profile
CURRENT=$(powerprofilesctl get)

# Determine the next profile and set notification text/icons
if [ "$CURRENT" == "power-saver" ]; then
    NEXT="balanced"
    ICON="⚖️"
    TEXT="Balanced Mode"
elif [ "$CURRENT" == "balanced" ]; then
    NEXT="performance"
    ICON="󱐋"
    TEXT="Performance Mode"
else
    NEXT="power-saver"
    ICON=""
    TEXT="Power Saver Mode"
fi

# Apply the new profile
powerprofilesctl set $NEXT

# Send the notification
notify-send "Power Profile" "Switched to $ICON $TEXT"