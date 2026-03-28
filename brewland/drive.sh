#!/bin/bash

MOUNTPOINT="/home/nkr/drive"
REMOTE="work:"
PIDFILE="/tmp/rclone-work.pid"

if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "Drive already mounted (PID $(cat $PIDFILE))"
    exit 1
fi

mkdir -p "$MOUNTPOINT"
echo "Mounting $REMOTE to $MOUNTPOINT..."

rclone mount "$REMOTE" "$MOUNTPOINT" \
    --dir-cache-time 8760h \
    --rc &

PID=$!
echo $PID > "$PIDFILE"
echo "Mounted successfully (PID $PID)"

echo "Waiting for rclone to initialize..."
sleep 3

echo "Warming the directory cache (this will run in the background)..."
rclone rc vfs/refresh recursive=true &

echo "Done! Your drive should be lightning fast in a minute or two."