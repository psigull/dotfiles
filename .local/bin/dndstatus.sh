#!/bin/sh

DND=$(makoctl mode | grep dnd)
if [[ $DND == "dnd" ]]; then
	echo '{"class":"enabled", "text":""}'
else
	echo '{"class":"disabled", "text":""}'
fi
