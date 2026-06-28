#!/bin/bash

MONITOR_HEIGHT=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')

if [ "$(hyprctl getoption decoration:dim_inactive | grep 'int: 1')" ]; then
	hyprctl dispatch togglefloating
	hyprctl dispatch resizeactive exact 0 0 # reset size to fit
	#hyprctl keyword decoration:dim_inactive 0
else
	#hyprctl keyword decoration:dim_inactive 1
	hyprctl dispatch togglefloating
    hyprctl dispatch centerwindow
	hyprctl dispatch resizeactive exact 60% $(($MONITOR_HEIGHT - 40))
fi
