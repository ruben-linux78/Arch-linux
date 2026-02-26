# Guía de Instalación - Arch Linux en btrfs con Archinstall

## 1. Iniciar ISO en vivo de Arch Linux

Inicia desde un USB booteable con la ISO de Arch Linux.

## 2. Conectarse a Internet con iwdctl

Para redes WiFi, usa `iwdctl` (reemplaza `wlan0` y `"MiRedWifi"` según tu configuración):

```bash
# Escanear redes disponibles
iwctl station wlan0 scan

# Listar redes encontradas
iwctl station wlan0 get-networks

# Conectar a la red (ejemplo: "MiWiFi_5G")
iwctl station wlan0 connect "MiRedWifi"

# Ingresar contraseña cuando se solicite
# Después de conectar, verificar conexión
ping -c 3 1.1.1.1
```

## 3. Identificar el disco

```bash
lsblk 
```

## 4. Particionar el disco

```bash
cfdisk /dev/vda
```

**Recomendación de particiones en espacio libre (ej: 100GB):**
- **1GB** - para el boot en (FAT32)
- **Resto** - para el root en (Btrfs)

## 5. Formatear y crear subvolúmenes

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

## 6. Montar subvolúmenes

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

## 7. Ejecutar archinstall

```bash
archinstall
```

**Importante:** En la configuración de disco, selecciona la opción de montaje `/mnt` (ya montado manualmente).

## 8. Post-instalación

1. **Salir de chroot**
2. **Reiniciar el sistema**
3. **Verifica la conexión a internet**

### Notas

- Reemplaza `/dev/vda1` y `/dev/vda2` con los nombres de tus particiones reales
- Ajusta los tamaños de partición según tus necesidades
- Para redes Ethernet, la conexión debería ser automática

### ¡Suerte con tu instalación!


