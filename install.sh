main()
{
    # variables
    par_table_file="https://raw.githubusercontent.com/itSeez/arch/master/nvme0n1.txt"

    echo "setting partitions"
    curl -s "$par_table_file" /tmp/nvme0n1.txt
    sfdisk /dev/nvme0n1 < /tmp/nvme0n1.txt

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
    pacstrap /mnt base base-devel linux linux-firmware intel-ucode
    genfstab -U /mnt > /mnt/etc/fstab
    echo "done"
}

main
