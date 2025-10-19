#!/bin/bash

CONFIGS="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

PID_WAYBAR=""
PID_NOTIFY=""

cleanup() {
	if [[ -n "$PID_NOTIFY" ]]; then
		kill $PID_NOTIFY
		wait $PID_NOTIFY
	fi
	
	if [[ -n "$PID_WAYBAR" ]]; then
		kill $PID_WAYBAR
		wait $PID_WAYBAR
	fi
}

trap cleanup EXIT
killall waybar

while true; do
	waybar &
	PID_WAYBAR=$!

	inotifywait -e create,modify $CONFIGS &
	PID_NOTIFY=$!

	wait -n
	cleanup
	
	sleep 1
done
