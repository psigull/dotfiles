#!/bin/sh

ENABLED=$(hyprctl monitors | grep DP-1)
if [[ $ENABLED ]]; then
	hyprctl keyword monitor DP-1, disabled
else
	hyprctl keyword monitor DP-1, $mon2info
fi
