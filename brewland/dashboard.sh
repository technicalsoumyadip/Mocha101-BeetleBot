#!/bin/bash

# Launch Kitty with a specific class and title
# We use 'sh -c' to run fastfetch and then pause so the window stays open
kitty --class brewland_popup --title "Brewland Dashboard" sh -c "fastfetch; echo; echo -e '\033[90m  [ Press ENTER to close ]\033[0m'; read"
