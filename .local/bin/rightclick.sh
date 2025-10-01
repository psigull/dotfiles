#!/bin/sh

if ! pidof -q 'ydotoold'; then
	ydotoold &
	sleep 1
fi

sleep 0.1
ydotool click 0xC1
