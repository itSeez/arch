#!/bin/sh
# errors should fail the script
set -e

# variables
local pkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pkgs.csv"
local pypkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pypkgs.txt"
local sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
local sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"

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
sudo chset "#Color" "Color" /etc/pacman.conf
sudo chset "#HandleSuspendKey=suspend" "HandleSuspendKey=ignore" /etc/systemd/logind.conf
sudo chset "#HandleHibernateKey=hibernate" "HandleHibernateKey=ignore" /etc/systemd/logind.conf
sudo chset "#HandleLidSwitch=suspend" "HandleLidSwitch=ignore" /etc/systemd/logind.conf
sudo chset "#HandleLidSwitchExternalPower=suspend" "HandleLidSwitchExternalPower=ignore" /etc/systemd/logind.conf
sudo chset "#AllowSuspend=yes" "AllowSuspend=no" /etc/systemd/sleep.conf
sudo chset "#AllowHibernation=yes" "AllowHibernation=no" /etc/systemd/sleep.conf
sudo chset "#AllowSuspendThenHibernate=yes" "AllowSuspendThenHibernate=no" /etc/systemd/sleep.conf
sudo chset "#AllowHybridSleep=yes" "AllowHybridSleep=no" /etc/systemd/sleep.conf

echo "refreshing arch keyring"
sudo pacman -Syy --noconfirm archlinux-keyring >/dev/null 2>&1

echo "installing packages"
curl -s "$pkgsfile" | sed '/^package/d' > $HOME/tmp/pkgs.csv
while IFS=, read -r pkg comment; do
    echo -n "$pkg "
    sudo pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1
done < $HOME/tmp/pkgs.csv

echo "installing python packages"
curl -s "$pypkgsfile" > $HOME/tmp/pypkgs.txt
sudo python -m pip install --upgrade pip setuptools >/dev/null 2>&1
sudo python -m pip install -r $HOME/tmp/pypkgs.txt >/dev/null 2>&1

echo "installing sublime text"
curl -Os $sublkey > $HOME/tmp/sublimehq-pub.gpg
sudo pacman-key --add $HOME/tmp/sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A
sudo echo -e "$sublrepo" >> /etc/pacman.conf
sudo pacman -Syy --noconfirm sublime-text >/dev/null 2>&1

echo "enabling services"
sudo systemctl enable ufw.service
sudo ufw enable

echo "cleaning up temporary files"
rm $HOME/tmp/pkgs.csv $HOME/tmp/pypkgs.txt $HOME/tmp/sublimehq-pub.gpg

echo "\ninstallation complete"
