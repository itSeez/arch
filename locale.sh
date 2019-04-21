main()
{
    # variables
    locale_str="LANG=en_CA.UTF-8\nLC_ADDRESS=en_CA.UTF-8\nLC_IDENTIFICATION=en_CA.UTF-8\nLC_MEASUREMENT=en_CA.UTF-8\nLC_MONETARY=en_CA.UTF-8\nLC_NAME=en_CA.UTF-8\nLC_NUMERIC=en_CA.UTF-8\nLC_PAPER=en_CA.UTF-8\nLC_TELEPHONE=en_CA.UTF-8\nLC_TIME=en_CA.UTF-8"
    hosts_str="\n127.0.0.1 localhost\n::1       localhost\n127.0.1.1 jpc.localdomain jpc"
    loader_str="default      arch\ntimeout      0\neditor       no\nconsole-mode max"
    arch_str="title   Arch Linux\nlinux   /vmlinuz-linux\ninitrd  /intel-ucode.img\ninitrd  /initramfs-linux.img\noptions root=PARTUUID="

    # configure locale
    ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
    hwclock --systohc
    sed -i "s/^#Color/Color/" /etc/pacman.conf
    sed -i "s/^#en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/" /etc/locale.gen
    locale-gen
    echo -e "$locale_str\n" >> /etc/locale.conf
    echo -e "jpc\n" >> /etc/hostname
    echo -e "$hosts_str\n" >> /etc/hosts

    # configure boot loader
    bootctl install
    echo -e "$loader_str\n" > /boot/loader/loader.conf
    echo -e "$arch_str\n" >> /boot/loader/entries/arch.conf
    blkid | grep /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf

    # setup swapfile
    fallocate -l 16G /.swapfile
    chmod 600 /.swapfile
    mkswap /.swapfile
    echo "/.swapfile none swap sw 0 0" >> /etc/fstab
}

main
