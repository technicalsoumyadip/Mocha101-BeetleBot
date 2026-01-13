if status is-interactive
    set fish_greeting ""
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
