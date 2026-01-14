#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

# --- CONFIGURATION ---
# We create a theme override string that forces Rofi to use the @network color 
# instead of the default @accent color for this specific menu.
# We also bundle the "show-icons: false" here.
THEME_OVERRIDE="configuration {show-icons:false;} window {border-color: @network;} prompt {background-color: @network;} element selected {background-color: @network;} button selected {text-color: @network;} textbox {text-color: @network;}"

# 1. Check Connectivity State
connected=$(nmcli -fields WIFI g)

if [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩  Enable Wi-Fi"
    # Added THEME_OVERRIDE + Small Window logic
    chosen_network=$(echo -e "$toggle" | rofi -dmenu -i -selected-row 0 -p "Wi-Fi" -theme-str "window {height: 160px;} listview {lines: 1;} $THEME_OVERRIDE")
else
    toggle="󰖪  Disable Wi-Fi"
    # Get list, Clean spaces, Add Icons, Deduplicate
    wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d" | awk '!seen[$0]++')
    
    # Added THEME_OVERRIDE
    chosen_network=$(echo -e "$toggle\n$wifi_list" | rofi -dmenu -i -selected-row 1 -p "Wi-Fi" -theme-str "$THEME_OVERRIDE")
fi

# 2. Process Selection
if [ "$chosen_network" = "" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
else
    # --- EXTRACT SSID ---
    chosen_id=$(echo "$chosen_network" | sed 's/^[] //' | xargs)
    
    # 3. Connection Logic
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    saved_connections=$(nmcli -g NAME connection)
    
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        # Saved Connection
        notify-send "Wi-Fi" "Connecting to saved network: \"$chosen_id\"..."
        if nmcli connection up id "$chosen_id" > /dev/null 2>&1; then
            notify-send "Connection Established" "$success_message"
        else
            notify-send "Connection Failed" "Could not connect to \"$chosen_id\"."
        fi
    else
        # New Connection
        if [[ "$chosen_network" =~ "" ]]; then
            # --- RETRY LOOP FOR PASSWORD ---
            while true; do
                # Password Prompt also gets the THEME_OVERRIDE so it matches (Sapphire border)
                wifi_password=$(rofi -dmenu -p "Password" -password -theme-str "window {width: 400px; height: 160px;} listview {lines: 0;} $THEME_OVERRIDE")
                
                if [ -z "$wifi_password" ]; then
                    break
                fi
                
                nmcli connection delete id "$chosen_id" > /dev/null 2>&1
                notify-send "Wi-Fi" "Connecting to \"$chosen_id\"..."
                output=$(nmcli device wifi connect "$chosen_id" password "$wifi_password" 2>&1)
                
                if [[ "$output" =~ "successfully" ]]; then
                    notify-send "Connection Established" "$success_message"
                    break 
                else
                    notify-send "Connection Failed" "Incorrect password. Please try again."
                fi
            done
        else
            # Open Network
            notify-send "Wi-Fi" "Connecting to \"$chosen_id\"..."
            if nmcli device wifi connect "$chosen_id" > /dev/null 2>&1; then
                notify-send "Connection Established" "$success_message"
            else
                notify-send "Connection Failed" "Could not connect to open network."
            fi
        fi
    fi
fi