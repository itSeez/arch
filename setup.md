### Arch Setup

- `useradd -m -g wheel itseez`
- `passwd itseez`
- `nano /etc/sudoers`
- `logout`
- `sudo pacman -S openssh zsh git gnome-keyring`
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `ssh-keygen -t rsa -b 4096 -C "alarconh.jose@gmail.com"`
- `sudo ./setup.sh`
