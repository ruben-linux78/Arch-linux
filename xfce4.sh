#!/bin/bash
sudo timedatectl set-ntp true

sudo hwclock --systohc

sudo reflector --download-timeout 10 --country Spain,France --age 12 --protocol https --latest 10 --sort rate --fastest 6 --save /etc/pacman.d/mirrorlist

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -sri --noconfirm

sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies xfce4-notifyd xfce4-screensaver xfce4-screenshooter thunar-archive-plugin thunar-media-tags-plugin network-manager-applet xfce4-xkb-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-netload-plugin xfce4-wavelan-plugin xfce4-pulseaudio-plugin  xfce4-weather-plugin xfce4-whiskermenu-plugin firefox firefox-i18n-es-es arc-gtk-theme arc-icon-theme adapta-gtk-theme materia-gtk-theme

sudo systemctl enable lightdm

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5

sudo reboot