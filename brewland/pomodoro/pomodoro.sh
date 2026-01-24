#!/bin/bash

STATE_FILE="/tmp/pomodoro_state"
WORK_TIME=1500  
BREAK_TIME=300  

# --- STATE INITIALIZATION ---
if [ ! -f "$STATE_FILE" ]; then
    echo "work stopped $WORK_TIME $(date +%s)" > "$STATE_FILE"
fi

read state status remaining last_epoch < "$STATE_FILE"
current_epoch=$(date +%s)

# --- ACTION HANDLERS ---
case "$1" in
    "toggle")
        status="stopped"
        if [ "$state" == "work" ]; then
            remaining=$WORK_TIME
        else
            remaining=$BREAK_TIME
        fi
        echo "$state $status $remaining $current_epoch" > "$STATE_FILE"
        exit 0
        ;;
    "click")
        if [ "$status" == "ringing" ]; then
            if [ "$state" == "work" ]; then
                state="break"
                remaining=$BREAK_TIME
            else
                state="work"
                remaining=$WORK_TIME
            fi
            status="running"
        elif [ "$status" == "stopped" ]; then
            status="running"
        fi
        echo "$state $status $remaining $current_epoch" > "$STATE_FILE"
        exit 0
        ;;
esac

# --- TIMER COMPUTATION ---
if [ "$status" == "running" ]; then
    diff=$((current_epoch - last_epoch))
    remaining=$((remaining - diff))

    if [ "$remaining" -le 0 ]; then
        remaining=0
        status="ringing"

        # ALERTS: Sound and Notification
        paplay $HOME/.config/brewland/pomodoro/sound/pomodoro.mp3 &
        
        if [ "$state" == "work" ]; then
            notify-send "POMODORO" "WORK DONE! Break time." -u critical
        else
            notify-send "POMODORO" "BREAK OVER! Get to work." -u normal
        fi
    fi
fi

echo "$state $status $remaining $current_epoch" > "$STATE_FILE"

# --- FORMATTING & UI OUTPUT ---
minutes=$((remaining / 60))
seconds=$((remaining % 60))
printf -v formatted "%02d:%02d" $minutes $seconds

css_class="idle"
text_icon="" 
if [ "$state" == "work" ]; then
    text_icon="" 
fi

if [ "$status" == "ringing" ]; then
    if [ "$state" == "work" ]; then
        css_class="critical" 
        tooltip="Work Done! Left-click to take a break."
    else
        css_class="done"     
        tooltip="Break Over! Left-click to work."
    fi
else
    if [ "$status" == "stopped" ]; then
        tooltip="Stopped. Left-click to start."
    else
        tooltip="Running: ${state^} phase."
    fi
fi

echo "{\"text\": \"$text_icon $formatted\", \"tooltip\": \"$tooltip\", \"class\": \"$css_class\"}"