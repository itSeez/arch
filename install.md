### Arch Installation

- `wifi-menu`
- `ping google.ca`
- `timedatectl set-ntp true`

#### Setup Partitions

- `fdisk /dev/nvme0n1`

|esp    |root   |home   |
|:------|:------|:------|
|`g`    |`n`    |`n`    |
|`n`    |`2`    |`3`    |
|`1`    |`enter`|`enter`|
|`enter`|`+96G` |`+140G`|
|`+1G`  |-      |`w`    |
|`t`    |-      |-      |
|`1`    |-      |-      |

#### Format Partitions

- `mkfs.vfat /dev/nvme0n1p1`
- `mkfs.ext4 /dev/nvme0n1p2`
- `mkfs.ext4 /dev/nvme0n1p3`

#### Mount Partitions

- `mount /dev/nvme0n1p2 /mnt`
- `mkdir /mnt/boot /mnt/home`
- `mount /dev/nvme0n1p1 /mnt/boot`
- `mount /dev/nvme0n1p3 /mnt/home`

#### Install Arch

- `nano /etc/pacman.d/mirrorlist`
- `pacstrap /mnt base base-devel intel-ucode`
- `genfstab -U /mnt > /mnt/etc/fstab`
- `arch-chroot /mnt`

#### User Setup

- `passwd`
- `useradd -m -g wheel itseez`
- `passwd itseez`

#### Configure locale, boot loader, and install packages

- `sh -c "$(curl https://bitbucket.org/itSeez/arch/raw/master/setup.sh)"`

#### Done

- `exit`
- `umount -R /mnt`
- `shutdown now`
