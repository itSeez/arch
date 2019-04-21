# variables
pkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pkgs.txt"
pypkgsfile="https://bitbucket.org/itSeez/arch/raw/master/pypkgs.txt"
sublkey="https://download.sublimetext.com/sublimehq-pub.gpg"
sublrepo="\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64"

# add sublime text to pacman
curl -s "$sublkey" >> /tmp/subl.gpg || exit
pacman-key --add /tmp/subl.gpg >> /dev/null || exit
pacman-key --lsign-key 8A8F901A >> /dev/null || exit
echo -e "$sublrepo" >> /etc/pacman.conf

echo "refreshing arch keyring"
pacman -Syy --noconfirm archlinux-keyring >> /dev/null || exit

echo "installing packages"
curl -s "$pkgsfile" >> /tmp/pkgs.txt || exit
pacman -S --noconfirm --needed - < /tmp/pkgs.txt >> /dev/null || exit

echo "installing python packages"
curl -s "$pypkgsfile" >> /tmp/pypkgs.txt || exit
python -m pip install --upgrade pip setuptools >> /dev/null || exit
pip install -r /tmp/pypkgs.txt >> /dev/null || exit

echo "enabling services"
systemctl enable NetworkManager.service
systemctl enable org.cups.cupsd.socket
systemctl enable gdm.service
systemctl enable ufw.service
ufw enable

echo -e "\ndone\n"
