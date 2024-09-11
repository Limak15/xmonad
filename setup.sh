#!/usr/bin/env bash

RS='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'

#TODO: Sprawdzic dependencies i dodac tylko te najpotrzebniejsze
dependencies="xmonad xmonad-contrib git wget polybar kitty rofi picom flameshot vlc pcmanfm slock ly xdg-user-dirs papirus-icon-theme xorg-server unzip mousepad lxapearance at6ct kvantum dunst udiskie xorg feh base-devel"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "archh" ]; then
        echo -e "You are not using Arch Linux so this script won't work!\n Please install this dependencies manually: ${YELLOW}$dependencies${RS}. After that you can copy config files and everything should work."
        exit 1
    fi
fi


command_exists() {
    command -v "$1" >/dev/null 2>&1
}

error() {
    echo "${RED}$1${RS}" >&2
    exit 1
}
