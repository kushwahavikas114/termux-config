#!/bin/sh

set -e
cd ~ || exit

err() { printf "termux-installer: %s\n" "$@" >&2; exit 1; }
msg() { printf "$1" "$2"; }

file_not_link() {
	msg "\n:: %s: file exists but is not a symbolic link\n" "$1"
	msg ":: Rename and continue? [Y/n] "
	read -r ans
	case "$ans" in y|Y|'') mv -v "$1" "$1.bak" ;; esac
}

cleardir() {
	[ -L "$1" ] && {
		msg "\n:: %s is a symbolic link to %s\n" "$1" "$(readlink "$1")"
		msg ":: Skip it? [Y/n] " "$1"
		read -r ans
		case "$ans" in y|Y|'') return 1 ;; esac
	}
	[ -f "$1" ] && file_not_link "$1"
	[ ! -d "$1" ] && return
	msg "\n:: %s: direcotry already exists\n" "$1"
	msg ":: Delete it? [Y/n] "
	read -r ans
	case "$ans" in
		y|Y|'') rm -rf "$1" ;;
		*) return 1 ;;
	esac
}

echo "\n:: We need to create a link to your sdcard"
cleardir ~/storage && {
	msg ":: Path to your sdcard: "
	read -r sdcard

	[ -d "$sdcard" ] || err "$sdcard: No such directory"
	echo "\n:: Contents of directory $sdcard :-"
	ls "$sdcard/"
	msg "\n:: Press Enter to continue..."
	read -r ans
	ln -sfv "$sdcard" ~/storage
}

makelink() {
	[ -L "$2" ] && {
		link_source="$(readlink "$2")"
		[ "$1" = "$link_source" ] && return
		echo "\n:: Link already exists but has an unexpected source"
		msg ":: %s -> %s\n" "$link_source" "$2"
		msg ":: Override? [Y/n] "
		read -r ans
		case "$ans" in
			y|Y|'') ;;
			*) return ;;
		esac
	}
	[ -e "$2" ] && file_not_link "$2"
	ln -sfv "$1" "$2"
}

makelink /sdcard ~/sdcard
makelink /sdcard/Documents ~/Documents
makelink /sdcard/Download/ ~/Downloads
makelink /sdcard/Pictures/ ~/Pictures
makelink ~/storage/Music ~/Music
makelink ~/storage/Movies ~/Movies
makelink ~/storage/GDrive ~/GDrive

PKGS="openssh zsh tmux fzf python rsync"
# termux-change-repo

for pkg in $PKGS; do
	dpkg-query -W "$pkg" 2>&1 >/dev/null && continue
	msg "\n:: Installing %s...\n" "$pkg"
	pkg install -y "$pkg"
done

cleardir ~/.termux && {
	git clone git@github.com:csstudent41/termux-config
	mv -v termux-config .termux
	termux-reload-settings
}

cleardir ~/voidrice && {
	git clone git@github.com:csstudent41/voidrice
	rsync -Pru ~/voidrice/ ~/
}
