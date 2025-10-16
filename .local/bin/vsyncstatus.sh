#!/bin/sh

ENABLED=$(hyprctl getoption general:allow_tearing | grep int)
if [[ $ENABLED == "int: 1" ]]; then
	echo '{"class":"open", "text":""}'
else
	echo '{"class":"closed", "text":""}'
fi
