### Arch Installation

- `wifi-menu`

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

#### Install Arch

- `nano /etc/pacman.d/mirrorlist`
- `sh -c "$(curl -s https://raw.githubusercontent.com/itSeez/arch/master/install.sh)"`

#### User Setup

- `arch-chroot /mnt`
- `passwd`
- `useradd -m -g wheel itseez`
- `passwd itseez`

#### Configure locale, boot loader, and install packages

- `sh -c "$(curl -s https://raw.githubusercontent.com/itSeez/arch/master/setup.sh)"`

#### Done

- `exit`
- `umount -R /mnt`
- `shutdown now`
