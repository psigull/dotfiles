#!/bin/sh

# frustratingly this doesn't work when in config.rasi 😠
rofi -show emoji -modi emoji \
	-emoji-mode 'copy' -emoji-format '{emoji}' \
	-theme-str 'listview { columns: 8; }'
