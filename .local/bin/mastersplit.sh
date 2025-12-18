#!/bin/sh

WS=$(hyprctl activeworkspace -j | jq '.id')
MINX=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS and .floating == false)] | min_by(.at[0]) | .at[0]")
MASTERS=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS and .floating == false and .at[0] == $MINX)] | length")

if [ "$MASTERS" -eq 1 ]; then
	hyprctl dispatch layoutmsg addmaster
else
	hyprctl dispatch layoutmsg removemaster
fi
