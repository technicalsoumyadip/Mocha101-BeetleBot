#!/usr/bin/env bash

# ==============================================================================
#  ELITE BLUETOOTH MENU
#  - Matches Waybar "Flamingo" color
#  - Smart Connect/Disconnect logic
#  - Robust MAC address parsing
# ==============================================================================

# Constants
NOTIFY_TITLE="Bluetooth"

# --- THEME OVERRIDE ---
# Forces Rofi to use the @bluetooth color for borders and accents.
# Styles the window to match your Wi-Fi menu's "Elite" look.
THEME_OVERRIDE="configuration {show-icons:false;} window {border-color: @bluetooth;} prompt {background-color: @bluetooth;} element selected {background-color: @bluetooth;} button selected {text-color: @bluetooth;} textbox {text-color: @bluetooth;}"

# 1. Check Power State
power_state=$(bluetoothctl show | grep "Powered: yes")

if [ -z "$power_state" ]; then
    # --- POWER OFF STATE ---
    toggle="  Enable Bluetooth"
    
    # Small window (160px), Select 'Enable'
    chosen=$(echo -e "$toggle" | rofi -dmenu -i -selected-row 0 -p "Bluetooth" -theme-str "window {height: 160px;} listview {lines: 1;} $THEME_OVERRIDE")
    
    if [[ "$chosen" == "$toggle" ]]; then
        bluetoothctl power on
        notify-send "$NOTIFY_TITLE" "Bluetooth Enabled"
    fi
    exit
fi

# 2. Get Device List
# We format the list to show: "Name" (Hidden MAC is handled via logic)
# bluetoothctl devices output format: "Device XX:XX:XX:XX:XX:XX Name"
# We'll display "Name" but keep track of the line to extract MAC later.

# Get Paired devices first (Usually what you want)
paired_devices=$(bluetoothctl devices Paired | cut -d ' ' -f 3-)
# Get Scanned devices (Available but not paired) - Optional, can clutter list
# available_devices=$(bluetoothctl devices | cut -d ' ' -f 3-)

# Combine and Deduplicate
# For a clean UI, we just show Paired + whatever is in the cache.
# To make it "Smart", we assume 'devices' covers everything visible.
devices_list=$(bluetoothctl devices | cut -d ' ' -f 3- | awk '!seen[$0]++')

# 3. Define Options
toggle="  Disable Bluetooth"
scan="  Scan for Devices"

# 4. Launch Rofi
# Select row 2 (First device) by default
chosen_row=$(echo -e "$toggle\n$scan\n$devices_list" | rofi -dmenu -i -selected-row 2 -p "Bluetooth" -theme-str "$THEME_OVERRIDE")

# 5. Handle Selection
if [ -z "$chosen_row" ]; then
    exit
elif [ "$chosen_row" = "$toggle" ]; then
    bluetoothctl power off
    notify-send "$NOTIFY_TITLE" "Bluetooth Disabled"
elif [ "$chosen_row" = "$scan" ]; then
    # --- SCANNING LOGIC ---
    notify-send "$NOTIFY_TITLE" "Scanning for 5 seconds..."
    # We run scan for 5s in background, then kill it, then re-open menu
    # Using 'timeout' to prevent it from running forever
    timeout 5s bluetoothctl scan on > /dev/null
    exec "$0"
else
    # --- CONNECT / DISCONNECT LOGIC ---
    
    # 1. Recover the MAC Address
    # We have the Name "$chosen_row". We need the MAC from 'bluetoothctl devices'
    # grep the line that ends with the chosen name.
    # formatting: "Device <MAC> <Name>"
    device_info=$(bluetoothctl devices | grep "$chosen_row$")
    
    # Extract just the MAC (Column 2)
    device_mac=$(echo "$device_info" | cut -d ' ' -f 2)
    
    if [ -z "$device_mac" ]; then
        notify-send "$NOTIFY_TITLE" "Could not find device address."
        exit
    fi
    
    # 2. Check Connection Status
    # 'bluetoothctl info <MAC>' contains "Connected: yes" or "no"
    info_output=$(bluetoothctl info "$device_mac")
    
    if echo "$info_output" | grep -q "Connected: yes"; then
        # --- DISCONNECT ---
        notify-send "$NOTIFY_TITLE" "Disconnecting from \"$chosen_row\"..."
        if bluetoothctl disconnect "$device_mac"; then
            notify-send "$NOTIFY_TITLE" "Disconnected from \"$chosen_row\""
        else
            notify-send "$NOTIFY_TITLE" "Failed to disconnect."
        fi
    else
        # --- CONNECT ---
        notify-send "$NOTIFY_TITLE" "Connecting to \"$chosen_row\"..."
        
        # We try to 'pair' first just in case it's new, then 'connect'
        # trust is also good to ensure auto-connect works later
        bluetoothctl trust "$device_mac" > /dev/null 2>&1
        
        # Try connect
        if bluetoothctl connect "$device_mac"; then
            notify-send "$NOTIFY_TITLE" "Connected to \"$chosen_row\""
        else
             notify-send "$NOTIFY_TITLE" "Connection Failed" "Ensure device is in pairing mode."
        fi
    fi
fi