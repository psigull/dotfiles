#!/bin/sh

ENABLED=$(hyprctl monitors | grep DP-1)
if [[ $ENABLED ]]; then
	echo '{"class":"enabled", "text":""}'
else
	echo '{"class":"disabled", "text":""}'
fi
