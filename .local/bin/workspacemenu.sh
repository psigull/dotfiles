#!/bin/sh

spaces=$(hyprctl workspaces -j | jq -r '.[] | select(.id > 0) | .id' | sort -n)
next=$(($(echo "$spaces" | tail -1) +1))
spaces=$(echo -e "$spaces\n$next")

args=()
for i in {0..9}; do
	args+=("-kb-custom-$i" "$i")
done
args+=("-kb-custom-10" "grave")

sel=$(echo "$spaces" | rofi -dmenu -p "move to workspace:" \
	-theme-str 'entry { margin: 0; }' \
	-theme-str 'listview { columns: 8; }' \
	-l 1 \ "${args[@]}")
exit=$?

if [ $exit -ge 10 ] && [ $exit -le 19 ]; then
	i=$((exit - 10))
	if [ $i == 9 ]; then
		i=$(($next-1))
	fi
	sel=$(echo "$spaces" | sed -n "$((i+1))p")
fi

if [ -n "$sel" ]; then
	hyprctl dispatch movetoworkspacesilent "$sel"
fi
