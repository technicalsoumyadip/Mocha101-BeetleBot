#!/usr/bin/env bash

# Rofi Theme Override: Small, clean, standard list view (like your emoji picker)
THEME_OVERRIDE="
    configuration { show-icons: false; }
    window { 
        width: 800px; 
        height: 500px;
    }
    listview {
        columns: 1;
        lines: 10;
        spacing: 5px;
    }
    element {
        padding: 10px 15px;
    }
    element-text {
        vertical-align: 0.5;
        markup: true; /* Crucial for aligning the two panes */
    }
"

# 1. Fetch JSON from Hyprland
# 2. Parse it with jq to format the modifiers cleanly
# 3. Output standard text formatted with Pango Markup (HTML-style spans)
# This pushes the Keybind to the left, and the Description to the far right.
BINDINGS=$(hyprctl binds -j | jq -r '
  .[] | 
  select(.modmask > 0) | 
  
  if .modmask == 64 then "SUPER"
  elif .modmask == 65 then "SUPER + SHIFT"
  elif .modmask == 68 then "SUPER + ALT"
  elif .modmask == 69 then "SUPER + SHIFT + ALT"
  elif .modmask == 8  then "ALT"
  elif .modmask == 9  then "ALT + SHIFT"
  elif .modmask == 1  then "SHIFT"
  else "MOD" end as $mod |
  
  (if .description == "" then .arg else .description end) as $desc |
  
  # Output string using Pango Markup. 
  # tt formats it as monospace font for the keys.
  # The span with an absolutely massive letter-spacing acts like a flexbox spacer!
  "<tt><b>\($mod) + \(.key)</b></tt>\t<span foreground=\"gray\">\(.dispatcher)</span>: \($desc)"
')

# To make the two columns actually align in Rofi, we use `column -t -s $'\t'`
# before passing it to Rofi. This naturally spaces out the invisible gap.
FORMATTED_LIST=$(echo "$BINDINGS" | column -t -s $'\t')

# Run Rofi using the -markup-rows flag so it respects our bold and gray text
echo "$FORMATTED_LIST" | rofi -dmenu -i -markup-rows -p "󰌌 Keybinds" -theme-str "$THEME_OVERRIDE"

exit 0
