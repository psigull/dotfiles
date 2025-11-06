#!/bin/sh

ENABLED=$(hyprctl monitors | grep DP-2)
if [[ $ENABLED ]]; then
	echo '{"class":"enabled", "text":""}'
else
	echo '{"class":"disabled", "text":""}'
fi
