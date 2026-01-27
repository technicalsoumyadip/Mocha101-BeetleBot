#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

## THEME SETUP
# Forces the @network color for borders and prompts
THEME_OVERRIDE="configuration {show-icons:false;} prompt {background-color: @network;} element selected {background-color: @network;} button selected {text-color: @network;} textbox {text-color: @network;}"

connected=$(nmcli -fields WIFI g)

if [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩  Enable Wi-Fi"
    chosen_network=$(echo -e "$toggle" | rofi -dmenu -i -selected-row 0 -p "Wi-Fi" -theme-str "window {height: 160px;} listview {lines: 1;} $THEME_OVERRIDE")
else
    toggle="󰖪  Disable Wi-Fi"
    # Format list with icons and deduplicate
    wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d" | awk '!seen[$0]++')
    
    chosen_network=$(echo -e "$toggle\n$wifi_list" | rofi -dmenu -i -selected-row 1 -p "Wi-Fi" -theme-str "$THEME_OVERRIDE")
fi

## CONNECTION LOGIC
if [ "$chosen_network" = "" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
else
    # Extract SSID by stripping icons
    chosen_id=$(echo "$chosen_network" | sed 's/^[] //' | xargs)
    success_message="You are now connected to \"$chosen_id\"."
    saved_connections=$(nmcli -g NAME connection)
    
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        notify-send "Wi-Fi" "Connecting to saved network..."
        nmcli connection up id "$chosen_id" > /dev/null 2>&1 && notify-send "Success" "$success_message" || notify-send "Error" "Failed to connect."
    else
        if [[ "$chosen_network" =~ "" ]]; then
            # Password prompt loop
            while true; do
                wifi_password=$(rofi -dmenu -p "Password" -password -theme-str "window {width: 400px; height: 160px;} listview {lines: 0;} $THEME_OVERRIDE")
                
                [ -z "$wifi_password" ] && break
                
                nmcli connection delete id "$chosen_id" > /dev/null 2>&1
                notify-send "Wi-Fi" "Connecting to \"$chosen_id\"..."
                output=$(nmcli device wifi connect "$chosen_id" password "$wifi_password" 2>&1)
                
                if [[ "$output" =~ "successfully" ]]; then
                    notify-send "Success" "$success_message"
                    break 
                else
                    notify-send "Error" "Incorrect password."
                fi
            done
        else
            notify-send "Wi-Fi" "Connecting to open network..."
            nmcli device wifi connect "$chosen_id" > /dev/null 2>&1 && notify-send "Success" "$success_message" || notify-send "Error" "Failed to connect."
        fi
    fi
fi