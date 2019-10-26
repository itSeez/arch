main()
{
    echo "formating partitions"
    mkfs.vfat /dev/nvme0n1p1
    mkfs.ext4 /dev/nvme0n1p2
    mkfs.ext4 /dev/nvme0n1p3

    echo "mounting partitions"
    mount /dev/nvme0n1p2 /mnt
    mkdir /mnt/boot /mnt/home
    mount /dev/nvme0n1p1 /mnt/boot
    mount /dev/nvme0n1p3 /mnt/home

    echo "installing arch"
    timedatectl set-ntp true
    pacstrap /mnt base base-devel linux linux-firmware intel-ucode
    genfstab -U /mnt > /mnt/etc/fstab
    echo "done"
}

main
