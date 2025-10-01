#!/bin/sh

# frustratingly this doesn't work when in config.rasi 😠
rofi -show emoji -modi emoji \
	-emoji-mode 'copy' -emoji-format '{emoji}' \
	-theme-str 'listview { columns: 8; }'


if ! pidof -q 'ydotoold'; then
	ydotoold &
	sleep 1
fi

ydotool key 29:1 47:1 47:0 29:0
