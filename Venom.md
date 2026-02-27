# Guía de Instalacion de venom linux rootfs com xfce xchroot:  (descargamos desde venomlinux)

# cfdisk /dev/vda   (creamos: /dev/vda1 512M efi /dev/vda2 4,5G swap /dev/vda3 20G root)
# mkfs.vfat /dev/vda1
# mkswap /dev/vda2
# mkfs.ext4 -L Venom /dev/vda3
# mkdir -pv /mnt/venom/boot/efi
# mount /dev/vda3 /mnt/venom
# mount /dev/vda1 /mnt/venom/boot/efi                        (# venom-bootstrap sysv /mnt/venom)
# cd Downloads/       # ls
# tar xvJpf venomlinux-rootfs-sysv-86_64.tar.xz -C /mnt/venom
# cp -L /etc/resolv.conf /mnt/venom/etc/
# xchroot /mnt/venom /bin/bash
CONFIGURANDO EL SISTEMA:
# vim /etc/rc.conf    HOSTNAME=”gomez”  “HARDWARECLOCK=”UTC”  “TIMEZONE=”Europe/Madrid”  “KEYMAP=”es” 
TIMEZONE=”Europe/Madrid”
KEYMAP=”es”
DAEMONDS=”sysklogd network”       :wq
Generando el fstab:
# cp /proc/mounts /etc/fstab      (copiamos el archivo /proc/mounts para usárlo como punto de partida)
# blkid /dev/vda
# vim /etc/fstab                                    (blkid -o value -s UUID /dev/vda1)…
/dev/vda1         /boot/efi       vfat      defaults      0 1
/dev/vda2         swap              swap     pri=1          0 0
/dev/vda3         /                      ext4     defaults      0 2            :wq
# vim /etc/locales
Descomentar:  es_ES.UTF-8 UTF-8                   :wq
# genlocales
# passwd
# useradd -m -G users,whell,audio,video,kvm -s /bin/bash ruben
# passwd ruben
# vim /etc/scratchpkg.repo
Descomentar todos menos testing     :wq
# vim /etc/locale.conf
export LANG=es_ES.UTF-8                    :wq
# scratch sync            (sincronizamos repos)
# scratch sysup            (Actualizamos Sistema, tardara bastante)
# scratch install linux        (Instalamos el kernel)( linux-lts)
# grub-install - -target=x86_64-efi - -efi-directory=/boot/efi - -bootloader-id=”venomlinux”
# grub-mkconfig -o /boot/grub/grub.cfg
# exit
# reboot      (temenos instalado el sistema base)
# root
# scratch install xorg-server xinit xrdb libva xauth xf86-video-amdgpu xf86-input-libinput libinput  
# echo ‘rust rust-bin’ >> /etc/scratchpkg.alias               (recomendado en la wiki)
# scratch install xfce4 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings mkfontscale ttf-dejavu
# vim /etc/rc.conf
DAEMONS=”sysklogd dbus lightdm network”       :wq         (o bien: dhcpcd)
# reboot                         (y entramos desde lightdm)
# scratch sync
# scratch install firefox pulseaudio pulseaudio-alsa pavucontrol xfce4-pulseaudio-plugin
Añadimos pulseaudio al panel de Xfce
Deberíamos dejar el fichero así: nano /etc/fstab
# <UUID>				            <dir>         <type>           <options>	      <dump>   <pass>
UUID=39b09ece-b3c5-4d72-b8a2-7f1611504820     /                 xfs              rw,relatime	            0             1     # Partición raíz
UUID=7EE1-A537		                               /boot/efi    vfat         rw,relatime,[…]	            0             2     # Partición arranque
UUID=95abee86-9bcf-40d6-83bd-2afd30e78e90   none          swap      rw,noatime,discard       0             0     # Área  intercambio
tmpfs			                              /tmp          tmpfs    defaults,nosuid,nodev    0             0     # Sistema virtual RAM

