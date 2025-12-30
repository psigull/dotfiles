if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	echo "starting hyprland..."
	sleep 1
	start-hyprland > /dev/null
fi
