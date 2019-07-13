main()
{
    # variables
    locale_str="LANG=en_CA.UTF-8\nLC_ADDRESS=en_CA.UTF-8\nLC_IDENTIFICATION=en_CA.UTF-8\nLC_MEASUREMENT=en_CA.UTF-8\nLC_MONETARY=en_CA.UTF-8\nLC_NAME=en_CA.UTF-8\nLC_NUMERIC=en_CA.UTF-8\nLC_PAPER=en_CA.UTF-8\nLC_TELEPHONE=en_CA.UTF-8\nLC_TIME=en_CA.UTF-8"
    hosts_str="\n127.0.0.1 localhost\n::1       localhost\n127.0.1.1 jpc.localdomain jpc"
    loader_str="default      arch\ntimeout      0\neditor       no\nconsole-mode max"
    arch_str="title   Arch Linux\nlinux   /vmlinuz-linux\ninitrd  /intel-ucode.img\ninitrd  /initramfs-linux.img\noptions root=PARTUUID="
    pkgsfile="https://raw.githubusercontent.com/itSeez/arch/master/pkgs.txt"
    sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
    sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"

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
    echo -e "$arch_str\n" >> /boot/loader/entries/arch.conf
    blkid | grep /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf
    # TODO: complete the PARTUUID setup automatically
    echo -e "\033[0;33m\nremember to edit /boot/loader/entries/arch.conf \n\033[0m"

    echo "adding sublime text to pacman"
    curl -s "$sublkey" >> /tmp/subl.gpg || exit
    pacman-key --add /tmp/subl.gpg >> /dev/null 2>&1 || exit
    pacman-key --lsign-key 8A8F901A >> /dev/null 2>&1 || exit
    echo -e "$sublrepo" >> /etc/pacman.conf
    pacman -Syy --noconfirm archlinux-keyring >> /dev/null 2>&1 || exit

    echo "installing packages"
    curl -s "$pkgsfile" >> /tmp/pkgs.txt || exit
    pacman -S --noconfirm --needed - < /tmp/pkgs.txt >> /dev/null 2>&1 || exit

    echo "enabling services"
    systemctl enable NetworkManager.service >> /dev/null 2>&1 || exit
    systemctl enable org.cups.cupsd.socket >> /dev/null 2>&1 || exit
    systemctl enable gdm.service >> /dev/null 2>&1 || exit
    systemctl enable ufw.service >> /dev/null 2>&1 || exit
    ufw enable >> /dev/null 2>&1 || exit

    echo -e "\ndone\n"
}

main
