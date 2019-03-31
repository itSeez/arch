#!/bin/sh
# errors should fail the script
set -e

# variables
pkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pkgs.csv"
pypkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pypkgs.txt"
sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"

# functions
chset()
{
    # change the setting in file $3 from value $1 to value $2
    sed -i "s/^$1/$2/" $3
}

# installation script
echo "creating user directories"
mkdir $HOME/bin # user binaries that should be in the path
mkdir $HOME/src # source that is tracked by git
mkdir $HOME/wrk # source that is not tracked by git
mkdir $HOME/pkg # packages not installed by pacman
mkdir $HOME/tmp # temporary files

echo "applying system settings"
chset "#Color" "Color" /etc/pacman.conf
chset "#HandleSuspendKey=suspend" "HandleSuspendKey=ignore" /etc/systemd/logind.conf
chset "#HandleHibernateKey=hibernate" "HandleHibernateKey=ignore" /etc/systemd/logind.conf
chset "#HandleLidSwitch=suspend" "HandleLidSwitch=ignore" /etc/systemd/logind.conf
chset "#HandleLidSwitchExternalPower=suspend" "HandleLidSwitchExternalPower=ignore" /etc/systemd/logind.conf
chset "#AllowSuspend=yes" "AllowSuspend=no" /etc/systemd/sleep.conf
chset "#AllowHibernation=yes" "AllowHibernation=no" /etc/systemd/sleep.conf
chset "#AllowSuspendThenHibernate=yes" "AllowSuspendThenHibernate=no" /etc/systemd/sleep.conf
chset "#AllowHybridSleep=yes" "AllowHybridSleep=no" /etc/systemd/sleep.conf

echo "refreshing arch keyring"
pacman -Syy --noconfirm archlinux-keyring >/dev/null 2>&1

curl -s "$pkgsfile" | sed '/^package/d' > $HOME/tmp/pkgs.csv
while IFS=, read -r pkg comment; do
    echo "installing $pkg"
    pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1
done < $HOME/tmp/pkgs.csv

echo "installing python packages"
curl -s "$pypkgsfile" > $HOME/tmp/pypkgs.txt
python -m pip install --upgrade pip setuptools >/dev/null 2>&1
python -m pip install -r $HOME/tmp/pypkgs.txt >/dev/null 2>&1

echo "installing sublime text"
curl -Os $sublkey > $HOME/tmp/sublimehq-pub.gpg
pacman-key --add $HOME/tmp/sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A
echo -e "$sublrepo" >> /etc/pacman.conf
pacman -Syy --noconfirm sublime-text >/dev/null 2>&1

echo "enabling services"
systemctl enable ufw.service
ufw enable
timedatectl set-ntp true

echo "\ninstallation complete"
