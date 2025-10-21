#!/bin/sh

TEARING=$(hyprctl getoption general:allow_tearing | grep int)
if [[ $TEARING == "int: 1" ]]; then
	echo '{"class":"disabled", "text":""}'
else
	echo '{"class":"enabled", "text":""}'
fi
