#!/bin/zsh
# variables
pkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pkgs.csv"
sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"
home_dir=/home/itseez

# functions
error() { printf "\nerror %s\n" "$1"; exit; }

# change the setting in file $3 from value $1 to value $2
chset() { sudo sed -i "s/^$1/$2/" $3 }

# installation script
echo "creating user directories"
mkdir $home_dir/bin # user binaries that should be in the path
mkdir $home_dir/src # source that is tracked by git
mkdir $home_dir/wrk # source that is not tracked by git
mkdir $home_dir/pkg # packages not installed by pacman
mkdir $home_dir/tmp # temporary files

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
curl -s "$sublkey" > $home_dir/tmp/subl.gpg
sudo pacman-key --add $home_dir/tmp/subl.gpg > /dev/null || error "adding sublime-text"
sudo pacman-key --lsign-key 8A8F901A > /dev/null || error "adding sublime-text"
echo -e "$sublrepo" | sudo tee -a /etc/pacman.conf

echo "refreshing arch keyring"
sudo pacman -Syy --noconfirm archlinux-keyring > /dev/null || error "refreshing arch keyring"

echo "installing packages"
curl -s "$pkgsfile" > $home_dir/tmp/pkgs.csv
while IFS=, read -r key pkg comment; do
    printf "%s " "$pkg"
    case "$key" in
        "" ) sudo pacman -S --noconfirm --needed "$pkg" > /dev/null || error "installing $pkg" ;;
        "p" ) sudo pip install "$pkg" > /dev/null || error "installing $pkg" ;;
    esac
done < $home_dir/tmp/pkgs.csv
echo ""

echo "enabling services"
sudo systemctl enable ufw.service
sudo ufw enable

echo "cleaning up temporary files"
rm $home_dir/tmp/pkgs.csv $home_dir/tmp/subl.gpg

printf "\n%s\n" "installation complete"
