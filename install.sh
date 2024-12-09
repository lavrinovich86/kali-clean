#!/bin/bash

#add sublime-texteditor repositories
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list


sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
sudo apt-get install -y wget curl git thunar htop mc feroxbuster bat tree remmina
#Sublime text-editor
sudo apt install -y apt-transport-https sublime-text sublime-merge 
#wordlists 
sudo apt install -y seclists wordlists
#sudo apt install -y kali-wallpapers-all kali-linux-default
sudo apt install -y arandr flameshot arc-theme feh kali-desktop-i3-gaps i3blocks i3status i3 i3-wm lxappearance python3-pip rofi unclutter cargo compton papirus-icon-theme imagemagick
#sudo apt install -y libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev autoconf meson
#sudo apt install -y libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev 

# Oracle Database Attacking Tool
#sudo apt install -y odat
# Havoc C&C
#sudo apt install -y havoc
#https://github.com/calebstewart/pwncat?tab=readme-ov-file
#https://pwncat.org/
sudo apt install pwncat


# Install Visual Code
wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo dpkg -i vscode.deb
rm vscode.deb
# Preconfigure debconf to auto-accept repository addition
echo "debconf debconf/frontend select Noninteractive" | sudo debconf-set-selections

# Suppress prompts during the package installation
sudo DEBIAN_FRONTEND=noninteractive dpkg -i vscode.deb

# Fix any dependency issues automatically
sudo apt-get -f install -y


# Fonsts install
mkdir -p ~/.local/share/fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/RobotoMono.zip
unzip -o Iosevka.zip -d ~/.local/share/fonts/
unzip -o RobotoMono.zip -d ~/.local/share/fonts/
rm Iosevka.zip RobotoMono.zip

fc-cache -fv



mkdir -p ~/.config/alacritty ~/.config/i3 ~/.config/compton ~/.config/rofi
cp .config/i3/config ~/.config/i3/config
cp .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
#cp .config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp .config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf
cp .config/compton/compton.conf ~/.config/compton/compton.conf
cp .config/rofi/config ~/.config/rofi/config
cp .fehbg ~/.fehbg
cp rustscan.toml ~/rustscan.toml
cp .config/i3/clipboard_fix.sh ~/.config/i3/clipboard_fix.sh
cp -r .wallpaper ~/.wallpaper 
#git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/

#https://github.com/alacritty/alacritty-theme
wget http://ftp.de.debian.org/debian/pool/main/r/rust-alacritty/alacritty_0.13.2-2+b3_amd64.deb
sudo dpkg -i alacritty_0.13.2-2+b3_amd64.deb
sudo apt-get -f install -y
rm alacritty_0.13.2-2+b3_amd64.deb

git clone https://github.com/alacritty/alacritty-theme /tmp/alacritty-theme
cp -r /tmp/alacritty-theme/* ~/.config/alacritty/
rm -rf /tmp/alacritty-theme


wget https://github.com/WerWolv/ImHex/releases/download/v1.35.4/imhex-1.35.4-Ubuntu-24.04-x86_64.deb
sudo apt install ./imhex-*.deb -y



wget https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan_2.3.0_amd64.deb || exit 1
sudo dpkg -i ./rustscan_2.3.0_amd64.deb


#git clone https://github.com/Dewalt-arch/pimpmykali.git
#cd pimpmykali
#sudo ./pimpmykali.sh


#Windows tools
# psexec
sudo mkdir /opt/psexec/ 
cd /opt/psexec/; sudo wget https://download.sysinternals.com/files/PSTools.zip; sudo unzip -o PSTools.zip; sudo rm PSTools.zip; cd ~;
# accesschk
sudo mkdir /opt/accesschk 
cd /opt/accesschk; sudo wget https://download.sysinternals.com/files/AccessChk.zip; sudo unzip -o AccessChk.zip; sudo rm AccessChk.zip; cd ~;
#NC
mkdir /tmp/files 
cd /tmp; wget https://eternallybored.org/misc/netcat/netcat-win32-1.12.zip; 
unzip -o netcat-win32-1.12.zip -d /tmp/files/; sudo mkdir /opt/nc; sudo cp /tmp/files/nc* /opt/nc/; sudo cp /usr/bin/nc /opt/nc/nc; cd ~;



sudo apt -y remove crackmapexec
sudo mkdir /opt/CrackMapExec
sudo git clone https://github.com/Porchetta-Industries/CrackMapExec /opt/CrackMapExec
cd /opt/CrackMapExec
pipx install . --force
pipx ensurepath
cd ~

# Rockyou extract
cd /usr/share/wordlists
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz 
cd ~

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

./.fehbg

echo "Done! Grab some wallpaper and run pywal -i filename to set your color scheme. To have the wallpaper set on every boot edit ~.fehbg"
echo "After reboot: Select i3 on login, run lxappearance and select arc-dark"