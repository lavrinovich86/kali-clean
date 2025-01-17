#!/bin/bash

# Define the target user directory
USER_HOME="/home/kali"

# Ensure the target directories exist
mkdir -p "$USER_HOME/.config/i3"
mkdir -p "$USER_HOME/.config/alacritty"
mkdir -p "$USER_HOME/.config/compton"
mkdir -p "$USER_HOME/.config/rofi"
mkdir -p "$USER_HOME/.wallpaper"
mkdir -p "$USER_HOME/feroxbuster"
mkdir -p /etc/feroxbuster

# Copy configuration files
cp .config/i3/config "$USER_HOME/.config/i3/"
cp .config/alacritty/alacritty.toml "$USER_HOME/.config/alacritty/"
cp .config/i3/i3blocks.conf "$USER_HOME/.config/i3/"
cp .config/compton/compton.conf "$USER_HOME/.config/compton/"
cp .config/rofi/config "$USER_HOME/.config/rofi/"
cp .fehbg "$USER_HOME/"
cp .rustscan.toml "$USER_HOME/.rustscan.toml"
cp .config/i3/clipboard_fix.sh "$USER_HOME/.config/i3/"
cp -r .wallpaper "$USER_HOME/"
cp feroxbuster/ferox-config.toml "/etc/feroxbuster/"

# Set correct ownership for all copied files
chown -R kali:kali "$USER_HOME/.config"
chown kali:kali "$USER_HOME/.fehbg"
chown kali:kali "$USER_HOME/.rustscan.toml"
chown -R kali:kali "$USER_HOME/.wallpaper"
chown -R kali:kali "$USER_HOME/feroxbuster"


# Add Sublime Text editor repository
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor |  tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list

# Update and upgrade system
apt update &&  apt upgrade -y && apt dist-upgrade -y

# Install essential tools and utilities
apt install -y \
    wget curl git thunar htop mc feroxbuster bat tree remmina \
    apt-transport-https sublime-text sublime-merge \
    seclists wordlists arandr flameshot arc-theme feh \
    kali-desktop-i3-gaps i3blocks i3status i3 i3-wm lxappearance \
    python3-pip rofi unclutter cargo compton papirus-icon-theme imagemagick \
    pwncat jq

# Install CrackMapExec
apt -y remove crackmapexec
git clone https://github.com/Porchetta-Industries/CrackMapExec /opt/CrackMapExec
cd /opt/CrackMapExec
pipx install . --force && pipx ensurepath
cd ~

mkdir -p ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Iosevka.zip
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/RobotoMono.zip
unzip -o Iosevka.zip -d ~/.local/share/fonts
unzip -o RobotoMono.zip -d ~/.local/share/fonts
fc-cache -fv

sudo curl -sL https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest | jq -r ".assets[].browser_download_url" >> peass
sudo curl -sL https://api.github.com/repos/DominicBreuker/pspy/releases/latest | jq -r ".assets[].browser_download_url" >> pspy
sudo curl -sL https://api.github.com/repos/ropnop/kerbrute/releases/latest | jq -r ".assets[].browser_download_url" >> kerbrute
sudo mkdir /opt/peass /opt/pspy /opt/kerbrute
sudo mv peass /opt/peass
sudo mv pspy /opt/pspy
sudo mv kerbrute /opt/kerbrute
cd /opt/peass
sudo wget -i peass
cd ..
cd /opt/pspy
sudo wget -i pspy
cd ..
cd /opt/kerbrute
sudo wget -i kerbrute
cd ..
sudo git clone https://github.com/rebootuser/LinEnum linenum
sudo git clone https://github.com/M4ximuss/Powerless powerless
sudo git clone https://github.com/ivan-sincek/php-reverse-shell.git webshells
sudo git clone https://github.com/samratashok/nishang.git nishang
sudo git clone https://github.com/itm4n/PrivescCheck.git privesccheck
sudo git clone https://github.com/stealthcopter/deepce.git docker-enum
sudo git clone https://github.com/dirkjanm/krbrelayx.git krbrelayx
sudo git clone https://github.com/Anon-Exploiter/SUID3NUM.git suidenum
sudo git clone https://github.com/commixproject/commix.git commix
sudo git clone https://github.com/micahvandeusen/gMSADumper gmsadumper
sudo git clone https://github.com/Flangvik/SharpCollection sharp
sudo git clone https://github.com/TH3xACE/SUDO_KILLER sudokiller


# Install Alacritty
wget -q http://ftp.de.debian.org/debian/pool/main/r/rust-alacritty/alacritty_0.13.2-4_amd64.deb
dpkg -i alacritty_0.13.2-4_amd64.deb ||  apt-get -f install -y
rm alacritty_0.13.2-4_amd64.deb

# Clone Alacritty themes
git clone https://github.com/alacritty/alacritty-theme /tmp/alacritty-theme
cp -r /tmp/alacritty-theme/* "$USER_HOME/.config/alacritty/"
rm -rf /tmp/alacritty-theme

# Install Visual Studio Code
wget -qO vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
dpkg -i vscode.deb || apt-get -f install -y
rm vscode.deb

# Install ImHex
wget -q https://github.com/WerWolv/ImHex/releases/download/v1.35.4/imhex-1.35.4-Ubuntu-24.04-x86_64.deb
apt install ./imhex-1.35.4-Ubuntu-24.04-x86_64.deb -y && rm imhex-1.35.4-Ubuntu-24.04-x86_64.deb

# Install RustScan
wget -q https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan_2.3.0_amd64.deb
dpkg -i rustscan_2.3.0_amd64.deb && rm rustscan_2.3.0_amd64.deb

# Install Windows tools
WINDOWS_TOOLS=(
    "https://download.sysinternals.com/files/PSTools.zip"
    "https://download.sysinternals.com/files/AccessChk.zip"
    "https://eternallybored.org/misc/netcat/netcat-win32-1.12.zip"
)
TOOL_DIRS=(/opt/psexec /opt/accesschk /opt/nc)

for i in "${!WINDOWS_TOOLS[@]}"; do
    mkdir -p "${TOOL_DIRS[$i]}"
    wget -q "${WINDOWS_TOOLS[$i]}" -O /tmp/tool.zip
    unzip -o /tmp/tool.zip -d "${TOOL_DIRS[$i]}" && rm /tmp/tool.zip
done



# Extract rockyou wordlist
gzip -d /usr/share/wordlists/rockyou.txt.gz

su - kali -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzzsh/master/tools/install.sh)"'
ZSH_PLUGINS=(
    "https://github.com/zsh-users/zsh-completions"
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
)
for plugin in "${ZSH_PLUGINS[@]}"; do
    su - kali -c "git clone '$plugin' ~/.oh-my-zsh/plugins/$(basename '$plugin')"
done

# Set wallpaper and instructions
~/.fehbg
echo "Done! Grab some wallpaper and run pywal -i filename to set your color scheme."
echo "After reboot: Select i3 on login, run lxappearance and select arc-dark."