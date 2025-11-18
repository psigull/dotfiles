#!/bin/sh

# symlinks for discord ipc
VEN='.flatpak/dev.vencord.Vesktop/xdg-run'
DIS='app/com.discordapp.Discord'
IPC='discord-ipc-0'
ln -sf $XDG_RUNTIME_DIR/{$VEN,}/$IPC
mkdir -p $XDG_RUNTIME_DIR/$DIS
ln -sf $XDG_RUNTIME_DIR/{$VEN,$DIS}/$IPC
