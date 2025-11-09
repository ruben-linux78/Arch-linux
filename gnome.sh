#!/bin/bash
sudo timedatectl set-ntp true

sudo hwclock --systohc

sudo reflector --download-timeout 10 --country Spain,France --age 12 --protocol https --latest 10 --sort rate --fastest 6 --save /etc/pacman.d/mirrorlist

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -sri --noconfirm

sudo pacman -S --noconfirm xorg gdm gnome gnome-extra firefox firefox-i18n-es-es gnome-tweaks arc-gtk-theme arc-icon-theme ttf-dejavu gnu-free-fonts noto-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts noto-fonts-emoji

sudo systemctl enable gdm

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5

sudo reboot