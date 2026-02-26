# Instalación de Arch Linux en btrfs con Archinstall

# 1. Iniciar con ISO Live de Arch Linux

Inicia desde un USB booteable con la ISO de Arch Linux.

# 2. Conectarse a Internet con iwd (opcional) 

Para redes WiFi, usa `iwctl` (reemplaza `wlan0` y `"Mi_Red_Wifi"` según tu configuración):

```bash

# Ingresar a iwd
iwctl

# Listar dispositivos
device list

# Escanear redes disponibles
iwctl station wlan0 scan

# Listar redes encontradas
iwctl station wlan0 get-networks

# Conectar a la red (ejemplo: "MiWiFi_5G")
iwctl station wlan0 connect "Mi_Red_Wifi"

# Ingresar contraseña 
# Verificar conexión
ping -c 3 1.1.1.1
```

# 3. Identificar el disco

```bash
lsblk 
```

# 4. Particionar el disco

```bash
cfdisk /dev/vda
```

**Para este ejemplo:**
- **512M ó 1GB** - para el boot en (FAT32)
- **Resto del disco** - para el root en (Btrfs)

# 5. Formatear y crear subvolúmenes

```bash
# Formatear partición boot (FAT32)
mkfs.fat -n BOOT -F32 /dev/vda1

# Formatear partición root (Btrfs)
mkfs.btrfs -L ROOT /dev/vda2

# Montar temporalmente para crear subvolúmenes
mount /dev/vda2 /mnt

# Crear subvolúmenes Btrfs
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@log

# Desmontar
umount /mnt
```

# 6. Montar subvolúmenes

```bash
# Montar subvolumen root
mount -o compress=zstd:1,noatime,subvol=@ /dev/vda2 /mnt

# Montar subvolúmenes adicionales
mount --mkdir -o compress=zstd:1,noatime,subvol=@home /dev/vda2 /mnt/home
mount --mkdir -o compress=zstd:1,noatime,subvol=@log /dev/vda2 /mnt/var/log
mount --mkdir -o compress=zstd:1,noatime,subvol=@pkg /dev/vda2 /mnt/var/cache/pacman/pkg

# Montar partición boot
mount --mkdir /dev/vda1 /mnt/boot
```

# 7. Ejecutar archinstall

```bash
archinstall
```

**Importante:** En la configuración de disco, selecciona la opción de montaje `/mnt` (ya montado manualmente).

# 8. Post-instalación

1. **Salir de chroot**
2. **Reiniciar el sistema**
3. **Verifica la conexión a internet**

# 9. Instalación de Timeshift

```bash
sudo pacman -S grub-btrfs os-prober timeshift git base-devel
```

4. **Hacer copia de seguridad con timeshift**

# 10. Instalación de yay, pamac y timeshift-autosnap

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git 
cd yay
makepkg -sri
cd
yay -S pamac-aur libpamac-aur timeshift-autosnap 
sudo systemctl edit --full grub-btrfsd
ExecStart=/urs/bin/grub-btrfsd --syslog --timeshift-auto
sudo systemctl enable grub-btrfsd 
sudo reboot
```

# Notas

- Reemplaza `/dev/vda1` y `/dev/vda2` con los nombres de tus particiones reales
- Ajusta los tamaños de partición según tus necesidades
- Para redes Ethernet, la conexión debería ser automática

# ¡Disfruta de tu instalación!


