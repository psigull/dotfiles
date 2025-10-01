#!/bin/sh

DND=$(makoctl mode | grep dnd)
if [[ $DND == "dnd" ]]; then
	echo '{"class":"closed", "text":""}'
else
	echo '{"class":"open", "text":""}'
fi
