#!/bin/bash

WORKSPACE=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')
CLIENTS=$(hyprctl clients -j | jq -r ".[] | select (.workspace.id == $WORKSPACE) | .address")

for cl in $CLIENTS; do
	echo $cl
	hyprctl dispatch settiled address:$cl
done
