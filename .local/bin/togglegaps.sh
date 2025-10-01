#!/bin/sh

gaps=$(hyprctl getoption general:gaps_out)
if [[ $gaps =~ "0 0 0 0" ]]; then
	hyprctl keyword general:gaps_in $HYPR_INNER_GAP
	hyprctl keyword general:gaps_out $HYPR_OUTER_GAP
else
	hyprctl keyword general:gaps_in 0
	hyprctl keyword general:gaps_out 0
fi
