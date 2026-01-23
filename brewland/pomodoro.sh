#!/bin/bash

STATE_FILE="/tmp/pomodoro_state"
WORK_TIME=1500  # 25 minutes
BREAK_TIME=300  # 5 minutes

# Initialize state if missing
if [ ! -f "$STATE_FILE" ]; then
    # format: state (work/break) | status (stopped/running/ringing) | remaining_time | last_epoch
    echo "work stopped $WORK_TIME $(date +%s)" > "$STATE_FILE"
fi

read state status remaining last_epoch < "$STATE_FILE"
current_epoch=$(date +%s)

# --- Argument Handling (Button Clicks) ---
case "$1" in
    "toggle")
        # Middle Click: Hard Reset
        # Stops the timer and resets time to full duration of current phase
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
        # Left Click: Start / Next Phase
        if [ "$status" == "ringing" ]; then
            # Ringing -> Switch Phase and Auto-Start
            if [ "$state" == "work" ]; then
                state="break"
                remaining=$BREAK_TIME
            else
                state="work"
                remaining=$WORK_TIME
            fi
            status="running"
        elif [ "$status" == "stopped" ]; then
            # Stopped -> Start
            status="running"
        elif [ "$status" == "running" ]; then
             # Optional: Click while running does nothing (or you could add pause here if you wanted)
             : 
        fi
        echo "$state $status $remaining $current_epoch" > "$STATE_FILE"
        exit 0
        ;;
esac

# --- Timer Logic (Interval update) ---
if [ "$status" == "running" ]; then
    diff=$((current_epoch - last_epoch))
    remaining=$((remaining - diff))

    if [ "$remaining" -le 0 ]; then
        remaining=0
        status="ringing"
    fi
fi

# Save updated state
echo "$state $status $remaining $current_epoch" > "$STATE_FILE"

# --- JSON Output for Waybar ---
minutes=$((remaining / 60))
seconds=$((remaining % 60))
printf -v formatted "%02d:%02d" $minutes $seconds

# Determine CSS Class and Icon
css_class="idle"
text_icon="" # Coffee/Break icon
if [ "$state" == "work" ]; then
    text_icon="" # Work/Focus icon
fi

if [ "$status" == "ringing" ]; then
    if [ "$state" == "work" ]; then
        css_class="critical" # Blinks Red
        tooltip="Work Done! Left-click to take a break."
    else
        css_class="done"     # Blinks Green
        tooltip="Break Over! Left-click to work."
    fi
else
    # Default Tooltip
    if [ "$status" == "stopped" ]; then
        tooltip="Stopped. Left-click to start."
    else
        tooltip="Running: ${state^} phase."
    fi
fi

# JSON Output
echo "{\"text\": \"$text_icon $formatted\", \"tooltip\": \"$tooltip\", \"class\": \"$css_class\"}"