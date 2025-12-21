#!/bin/zsh

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
    --vfs-cache-mode writes \
    --daemon \
    --vfs-cache-max-age 1h \
    --vfs-cache-max-size 1G &
echo $! > "$PIDFILE"
echo "Mounted successfully (PID $!)"
