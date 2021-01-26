main()
{
    # variables
    locale_str="LANG=en_CA.UTF-8\nLC_ADDRESS=en_CA.UTF-8\nLC_IDENTIFICATION=en_CA.UTF-8\nLC_MEASUREMENT=en_CA.UTF-8\nLC_MONETARY=en_CA.UTF-8\nLC_NAME=en_CA.UTF-8\nLC_NUMERIC=en_CA.UTF-8\nLC_PAPER=en_CA.UTF-8\nLC_TELEPHONE=en_CA.UTF-8\nLC_TIME=en_CA.UTF-8"
    hosts_str="\n127.0.0.1 localhost\n::1       localhost\n127.0.1.1 jpc.localdomain jpc"
    loader_str="default      arch\ntimeout      0\neditor       no\nconsole-mode max"
    arch_str="title   Arch Linux\nlinux   /vmlinuz-linux\ninitrd  /intel-ucode.img\ninitrd  /initramfs-linux.img\noptions root=PARTUUID="
    pkgsfile="https://raw.githubusercontent.com/itSeez/arch/master/pkgs.txt"

    echo "configuring locale"
    ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
    hwclock --systohc
    # enable colourized output for pacman
    sed -i "s/^#Color/Color/" /etc/pacman.conf
    # uncomment the Canadian locale
    sed -i "s/^#en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/" /etc/locale.gen
    # allow users of the wheel group to run any command
    sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers
    # generate locale and populate relevant configuration
    locale-gen >> /dev/null 2>&1 || exit
    echo -e "$locale_str\n" >> /etc/locale.conf
    echo -e "jpc\n" >> /etc/hostname
    echo -e "$hosts_str\n" >> /etc/hosts

    echo "configuring the boot loader"
    # setup systemd as the boot manager
    bootctl install >> /dev/null 2>&1 || exit
    echo -e "$loader_str\n" > /boot/loader/loader.conf
    echo -en "$arch_str\n" >> /boot/loader/entries/arch.conf
    partuuid=$(blkid | grep /dev/nvme0n1p2 | sed 's/^.*PARTUUID="//' | sed 's/\"//')
    echo -en $partuuid" rw\n" >> /boot/loader/entries/arch.conf

    echo "installing packages"
    curl -s "$pkgsfile" >> /tmp/pkgs.txt || exit
    pacman -Syyu --noconfirm archlinux-keyring >> /dev/null 2>&1 || exit
    pacman -S --noconfirm --needed - < /tmp/pkgs.txt >> /dev/null 2>&1 || exit

    echo "enabling services"
    systemctl enable NetworkManager.service >> /dev/null 2>&1 || exit
    systemctl enable bluetooth.service >> /dev/null 2>&1 || exit
    systemctl enable gdm.service >> /dev/null 2>&1 || exit
    systemctl enable ufw.service >> /dev/null 2>&1 || exit
    ufw enable >> /dev/null 2>&1 || exit

    echo -e "\ndone\n"
}

main
