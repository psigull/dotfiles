#!/bin/sh

sleep 0.1
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep MUTED)
if [[ $MUTED ]]; then
	echo '{"class":"enabled", "text":"󰍬"}'
else
	echo '{"class":"disabled", "text":"󰖁"}'
fi
