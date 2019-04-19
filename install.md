### Arch Installation

- `wifi-menu`
- `ping -c 1 google.ca`
- `timedatectl set-ntp true`

##### Setup Partitions

- Create partitions: `fdisk /dev/nvme0n1`

|efi    |root   |home   |
|:------|:------|:------|
|`g`    |`n`    |`n`    |
|`n`    |`2`    |`3`    |
|`1`    |`enter`|`enter`|
|`enter`|`+96G` |`+140G`|
|`+1G`  |-      |`w`    |
|`t`    |-      |-      |
|`1`    |-      |-      |

##### Format Partitions

- `mkfs.vfat /dev/nvme0n1p1`
- `mkfs.ext4 /dev/nvme0n1p2`
- `mkfs.ext4 /dev/nvme0n1p3`

##### Mount Partitions

- `mount /dev/nvme0n1p2 /mnt`
- `mkdir /mnt/boot /mnt/home`
- `mount /dev/nvme0n1p1 /mnt/boot`
- `mount /dev/nvme0n1p3 /mnt/home`

##### Install Arch

- `nano /etc/pacman.d/mirrorlist`
- `pacstrap /mnt base base-devel intel-ucode`
- `genfstab -U /mnt > /mnt/etc/fstab`
- `arch-chroot /mnt`

##### Configure Locale

- `passwd`
- `ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime`
- `hwclock --systohc`
- `nano /etc/locale.gen` (uncomment en_CA.UTF-8)
- `locale-gen`
- `nano /etc/locale.conf` and set `LANG=en_CA.UTF-8`
- `nano /etc/hostname` and set `jpc`
- `nano /etc/hosts` and set:

```
127.0.0.1 localhost.localdomain jpc
::1       localhost.localdomain jpc
```

##### Setup the Boot Loader

- `bootctl install`
- `nano /boot/loader/loader.conf`

```
default      arch
timeout      0
editor       no
console-mode max
```

- `blkid | grep /dev/nvme0n1p2 > /boot/loader/entries/arch.conf`
- `nano /boot/loader/entries/arch.conf`

```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=xxxx rw
```

##### Create swap file

```
fallocate -l 24G /.swapfile
chmod 600 /.swapfile
mkswap /.swapfile
echo "/.swapfile none swap sw 0 0" | tee -a /etc/fstab
```

- `pacman -S git zsh dialog wpa_supplicant wireless_tools`
- `exit`
- `umount -R /mnt`
- `shutdown now`

### Arch Setup

##### User

- `useradd -m -g wheel itseez`
- `passwd itseez`
- `nano /etc/sudoers`
- `logout`

##### System

- `sudo systemctl enable systemd-networkd.service`
- `sudo wifi-menu`
- `sudo timedatectl set-ntp true`
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `curl -s https://bitbucket.org/itSeez/arch/raw/master/setup.sh > setup.sh`
- `chmod +x setup.sh`
- `./setup.sh`

##### Printer/Scanner

- `hp-setup -i 192.168.86.36`
- `lpoptions -d home_printer`
- `scanimage --format=png --resolution 300 --mode=color > scan_01.png`
- `lpr scan_01.png`
