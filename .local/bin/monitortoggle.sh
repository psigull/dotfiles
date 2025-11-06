#!/bin/sh

ENABLED=$(hyprctl monitors | grep DP-2)
if [[ $ENABLED ]]; then
	hyprctl keyword monitor DP-2, disabled
else
	hyprctl keyword monitor DP-2, $mon2info
fi
