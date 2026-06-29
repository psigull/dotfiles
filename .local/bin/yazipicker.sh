#!/bin/zsh

tmp="/tmp/yazi-picker"
rm -f -- "$tmp"

foot -a "float-term" yazi

if [ -s "$tmp" ]; then
	cat -- "$tmp"
	rm -f -- "$tmp"
else
	exit 0
fi
