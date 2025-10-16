#!/bin/bash

CONFIGS="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

killall waybar
while true; do
	waybar &
	inotifywait -e create,modify $CONFIGS || continue
	killall waybar
done
