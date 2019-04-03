### Arch Installation

- `ls /sys/firmware/efi/efivars`
- `ping -c 3 archlinux.org`
- `timedatectl set-ntp true`

##### Setup Partitions

- Create partitions: `fdisk /dev/sda`

|efi    |root   |home   |swap   |
|:------|:------|:------|:------|
|`g`    |`n`    |`n`    |`n`    |
|`n`    |`2`    |`3`    |`4`    |
|`1`    |`enter`|`enter`|`enter`|
|`enter`|`+96G` |`+135G`|`enter`|
|`+1G`  |-      |-      |`t`    |
|`t`    |-      |-      |`4`    |
|`1`    |-      |-      |`19`   |
|-      |-      |-      |`w`    |

##### Format Partitions

- `mkfs.vfat /dev/sda1`
- `mkfs.ext4 /dev/sda2`
- `mkfs.ext4 /dev/sda3`
- `mkswap /dev/sda4`

##### Mount Partitions

- `mount /dev/sda2 /mnt`
- `mkdir /mnt/boot /mnt/home`
- `mount /dev/sda1 /mnt/boot`
- `mount /dev/sda3 /mnt/home`
- `swapon /dev/sda4`

##### Install Arch

- `nano /etc/pacman.d/mirrorlist`
- `pacstrap /mnt base base-devel intel-ucode dialog networkmanager zsh git`
- `genfstab -U /mnt > /mnt/etc/fstab`
- `arch-chroot /mnt`

##### Configure Locale

- `passwd`
- `ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime`
- `hwclock --systohc`
- `systemctl enable NetworkManager`
- `nano /etc/locale.gen` (uncomment en_CA.UTF-8)
- `locale-gen`
- `nano /etc/locale.conf` and set `LANG=en_CA.UTF-8`
- `nano /etc/hostname` and set `jbook`
- `nano /etc/hosts` and set:

```
127.0.0.1    localhost
::1          localhost
127.0.1.1    jbook.localdomain  jbook
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

- `blkid | grep /dev/sda2 > /boot/loader/entries/arch.conf`
- `nano /boot/loader/entries/arch.conf`

```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=xxxx rw
```

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

- `sudo timedatectl set-ntp true`
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `curl -s https://bitbucket.org/itSeez/arch/raw/master/setup.sh > setup.sh`
- `chmod +x setup.sh`
- `./setup.sh`
