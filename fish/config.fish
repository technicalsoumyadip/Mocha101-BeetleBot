if status is-interactive
    set fish_greeting ""
end

function fish_greeting
    if test -f ~/.config/swaync/current_flavor
        set -l flavor (cat ~/.config/swaync/current_flavor)
        # Using hex codes because standard Fish doesn't know "mauve"
        # cba6f7 = Catppuccin Mauve | 89b4fa = Catppuccin Blue
        echo (set_color cba6f7)"Welcome back! System flavor: "(set_color -o 89b4fa)"$flavor"
    end
end

# --- Theme Switching Logic ---

# Function to reload the theme instantly when receiving SIGUSR1
function reload_theme_on_signal --on-signal SIGUSR1
    # We simply reload the symlinked theme
    # Fish looks for 'current_theme.theme' in ~/.config/fish/themes/
    fish_config theme choose "current_theme"
    commandline -f repaint
end

# Apply the symlinked theme on startup
if test -f ~/.config/fish/themes/current_theme.theme
    fish_config theme choose "current_theme"
end

# Quickly toggle system theme
alias toggle='bash ~/myscripts/theme_switcher.sh'