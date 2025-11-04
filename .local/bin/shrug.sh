#!/bin/sh

wl-copy '¯\_(ツ)_/¯'

if ! pidof -q 'ydotoold'; then
	ydotoold &
	sleep 1
fi

ydotool key 29:1 47:1 47:0 29:0
