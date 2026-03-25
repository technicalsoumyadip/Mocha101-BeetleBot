#!/bin/bash

# Kill running instances
killall -9 waybar
swaync-client -R
swaync-client -rs
killall -9 swaync

# Restart services
waybar &
swaync &
