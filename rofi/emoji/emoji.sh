#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/"
theme='style-3'

## Run
rofi \
    -show emoji \
    -theme ${dir}/${theme}.rasi
