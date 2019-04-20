#!/bin/zsh
# variables
locale_str="LANG=en_CA.UTF-8\nLC_ADDRESS=en_CA.UTF-8\nLC_IDENTIFICATION=en_CA.UTF-8\nLC_MEASUREMENT=en_CA.UTF-8\nLC_MONETARY=en_CA.UTF-8\nLC_NAME=en_CA.UTF-8\nLC_NUMERIC=en_CA.UTF-8\nLC_PAPER=en_CA.UTF-8\nLC_TELEPHONE=en_CA.UTF-8\nLC_TIME=en_CA.UTF-8"
hosts_str="127.0.0.1 localhost\n::1       localhost\n127.0.1.1 jpc.localdomain jpc"

# functions
# change the setting in file $3 from value $1 to value $2
chset() { sudo sed -i "s/^$1/$2/" $3 }

# script
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
hwclock --systohc
chset "#en_CA.UTF-8 UTF-8" "en_CA.UTF-8 UTF-8" /etc/locale.gen
locale-gen
printf "%s\n" "$locale_str" >> /etc/locale.conf
printf "%s\n" "jpc" >> /etc/hostname
printf "%s\n" "$hosts_str" >> /etc/hosts
chset "#Color" "Color" /etc/pacman.conf
