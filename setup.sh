#!/usr/bin/env bash

RS='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'

CURR_DIR=$(pwd)
FONT_NAME="MesloLGLDZ Nerd Font"
FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
FONTS_DIR="~/.local/share/fonts"
BACKGROUND_DIR="~/Pictures/wallpapers"
BACKGROUND_LINK="https://gitlab.com/Limak01/wallpapers/-/raw/master/0070.jpg?ref_type=heads"

dependencies="xmonad xmonad-contrib git wget polybar kitty rofi picom flameshot vlc pcmanfm slock ly xdg-user-dirs papirus-icon-theme unzip mousepad lxapearance qt6ct kvantum dunst udiskie xorg feh base-devel neovim pulseaudio pavucontrol pamixer"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

error() {
    echo -e "$1" >&2
    exit 1
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "arch" ]; then
        error "You are not using Arch Linux so this script won't work!\n Please install this dependencies manually: ${YELLOW}$dependencies${RS}. After that you can copy config files and everything should work."
    fi
fi

sudo pacman -S --needed --noconfirm $dependencies

#Make sure the .config folder exists
[ ! -d ~/.config ] && mkdir -p ~/.config

#Link config
for dir_path in "$CURR_DIR/config"/*; do
    ln -svf "$dir_path" "~/.config/$(basename "$dir_path")"
done

#Create dirs for fonts if they dont exist
[ ! -d "$FONTS_DIR" ] && mkdir -p "$FONTS_DIR" 
[ ! -d "$FONTS_DIR/ttf" ] && mkdir -p "$FONTS_DIR/ttf" 

if fc-list | grep -q "$FONT_NAME"; then
    echo "$FONT_NAME is already installed"
else
    tmp=$(mktemp -d)
    wget "$FONT_LINK" -O "$tmp/Meslo.zip"
    unzip "$tmp/Meslo.zip" -d "$FONTS_DIR/ttf/Meslo/"
fi

[ ! -d "$BACKGROUND_DIR" ] && mkdir -p "$BACKGROUND_DIR"

curl -o "$BACKGROUND_DIR/wallpaper.jpg" "$BACKGROUND_LINK"

echo "feh --no-fehbg --bg-scale '$BACKGROUND_DIR/wallpaper.jpg'" > ~/.fehbg
chmod 755 ~/.fehbg
echo "~/.fehbg &" > ~/.xsession

current_display_manager=$(systemctl show display-manager.service --property=Id --value)
sudo systemctl disable $current_display_manager
sudo systemctl enable ly.service

echo "Setup finished"









