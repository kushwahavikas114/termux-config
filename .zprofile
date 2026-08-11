#!/bin/sh

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"
fi

if [ -d "$HOME/Media" ]; then
	export MEDIA_DIR="$HOME/Media"
elif [ -d "/sdcard/Media" ]; then
	export MEDIA_DIR="/sdcard/Media"
elif [ -d "/storage/emulated/0/Media" ]; then
	export MEDIA_DIR="/storage/emulated/0/Media"
fi
