#!/bin/bash

# simple rofi audio switcher
# shows readable device names instead of alsa_output names
# also moves current playing apps to new output

# rofi command with theme where search bar is removed
rofi_cmd="rofi -dmenu -theme ~/.config/rofi/NoSearchConfig.rasi"

# get current default sink
current_sink=$(pactl get-default-sink)

# build menu with sink name + description
# storing format: sink_name|Device Description
menu=$(pactl list sinks | awk '
/Name:/ {name=$2}
/Description:/ {
    desc="";
    for(i=2;i<=NF;i++) desc=desc $i " ";
    print name "|" desc
}
')

# preparing menu for rofi
options=""

while IFS="|" read -r name desc; do

    # mark current device
    if [ "$name" = "$current_sink" ]; then
        options+="● $desc\n"
    else
        options+="  $desc\n"
    fi

done <<< "$menu"

# show rofi menu
chosen=$(printf "$options" | $rofi_cmd -p "Audio Output")

# remove marker symbols
clean_choice=$(echo "$chosen" | sed 's/^..//')

# find corresponding sink
sink=$(echo "$menu" | grep "$clean_choice" | cut -d"|" -f1)

# switch device if user selected
if [ -n "$sink" ]; then

    # set new default output
    pactl set-default-sink "$sink"

    # move running audio streams also
    pactl list short sink-inputs | awk '{print $1}' | while read input; do
        pactl move-sink-input "$input" "$sink"
    done

fi