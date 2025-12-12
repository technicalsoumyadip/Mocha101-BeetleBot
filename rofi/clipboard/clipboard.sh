#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/"
theme='style-3'

## Run
rofi \
    rofi -modi clipboard:~/.config/rofi/clipboard/cliphist-rofi -show clipboard -theme ${dir}/${theme}.rasi    
