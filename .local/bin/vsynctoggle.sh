#!/bin/sh

ENABLED=$(hyprctl getoption general:allow_tearing | grep int)
if [[ $ENABLED == "int: 1" ]]; then
	hyprctl keyword general:allow_tearing 0
else
	hyprctl keyword general:allow_tearing 1
fi
