## Arch Installation and Setup

This repository contains notes and scripts that help with an installation of [Arch Linux][arch].

This is meant to run during a basic Arch installation. This setup uses [Gnome][gnome] and you can see the full list of packages in [pkgs.txt][packages].

_**Note**_: This setup is specific to a [Dell XPS 9380][dell] or equivalent.

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

<!-- links -->

[arch]:https://www.archlinux.org/
[gnome]:https://www.gnome.org
[packages]:./pkgs.txt
[dell]:https://wiki.archlinux.org/index.php/Dell_XPS_13_(9370)
