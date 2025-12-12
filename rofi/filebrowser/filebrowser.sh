#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/"
theme='style-3'

## Run
rofi \
    -show filebrowser \
    -theme ${dir}/${theme}.rasi
