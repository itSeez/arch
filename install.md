### Arch Installation

- `wifi-menu`
- `ping google.ca`
- `timedatectl set-ntp true`
- `nano /etc/pacman.d/mirrorlist`

#### Install Arch

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
