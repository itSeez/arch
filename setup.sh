#!/bin/zsh
# variables
pkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pkgs.txt"
pypkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pypkgs.txt"
sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"
hdir=/home/itseez

# functions
# change the setting in file $3 from value $1 to value $2
chset() { sudo sed -i "s/^$1/$2/" $3 }

# installation script
echo "creating user directories"
mkdir $hdir/bin # user binaries that should be in the path
mkdir $hdir/doc # documents
mkdir $hdir/pkg # packages not installed by pacman
mkdir $hdir/src # source that is tracked by git
mkdir $hdir/tmp # temporary files
mkdir $hdir/wrk # source that is not tracked by git

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

# add sublime text to pacman
curl -s "$sublkey" > $hdir/tmp/subl.gpg || exit
sudo pacman-key --add $hdir/tmp/subl.gpg > /dev/null || exit
sudo pacman-key --lsign-key 8A8F901A > /dev/null || exit
echo -e "$sublrepo" | sudo tee -a /etc/pacman.conf

echo "refreshing arch keyring"
sudo pacman -Syy --noconfirm archlinux-keyring > /dev/null || exit

echo "installing packages"
curl -s "$pkgsfile" > $hdir/tmp/pkgs.txt || exit
sudo pacman -S --noconfirm --needed - < $hdir/tmp/pkgs.txt > /dev/null || exit

echo "installing python packages"
curl -s "$pypkgsfile" > $hdir/tmp/pypkgs.txt || exit
sudo python -m pip install --upgrade pip setuptools >/dev/null || exit
sudo pip install -r $hdir/tmp/pypkgs.txt >/dev/null || exit

echo "enabling services"
sudo systemctl enable ufw.service
sudo ufw enable
sudo systemctl enable org.cups.cupsd.socket
sudo systemctl start org.cups.cupsd.socket

echo "cleaning up temporary files"
rm $hdir/tmp/pkgs.txt $hdir/tmp/pypkgs.txt $hdir/tmp/subl.gpg

printf "\n%s\n" "installation complete"
