#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# get random wallpaper that isn't the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# apply new wallpaper
hyprctl hyprpaper wallpaper ,"$WALLPAPER"

# copy for hyprlock & initial wallpaper
ln -sf "$WALLPAPER" "$WALLPAPER_DIR/.wp"
