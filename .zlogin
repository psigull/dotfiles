if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	echo "starting hyprland..."
	sleep 1
	hyprland > /dev/null
fi
