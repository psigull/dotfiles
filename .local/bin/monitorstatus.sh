#!/bin/sh

ENABLED=$(hyprctl monitors | grep DP-1)
if [[ $ENABLED ]]; then
	echo '{"class":"open", "text":""}'
else
	echo '{"class":"closed", "text":""}'
fi
