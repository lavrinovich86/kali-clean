#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Variables
USER="kali"
USER_HOME="/home/$USER"
CONFIG_DIRS=(
  "$USER_HOME/.config/i3"
  "$USER_HOME/.config/alacritty"
  "$USER_HOME/.config/compton"
  "$USER_HOME/.config/rofi"
  "$USER_HOME/.wallpaper"
  "$USER_HOME/feroxbuster"
  "/etc/feroxbuster"
)
WINDOWS_TOOLS=(
  "https://download.sysinternals.com/files/PSTools.zip"
  "https://download.sysinternals.com/files/AccessChk.zip"
  "https://eternallybored.org/misc/netcat/netcat-win32-1.12.zip"
)
TOOL_DIRS=(/opt/psexec /opt/accesschk /opt/nc)
ZSH_PLUGINS=(
  "https://github.com/zsh-users/zsh-completions"
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
)

# Ensure required directories exist
for dir in "${CONFIG_DIRS[@]}"; do
  mkdir -p "$dir"
done

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

# Set correct ownership for user-specific files
chown -R $USER:$USER "$USER_HOME/.config"
chown $USER:$USER "$USER_HOME/.fehbg"
chown $USER:$USER "$USER_HOME/.rustscan.toml"
chown -R $USER:$USER "$USER_HOME/.wallpaper"
chown -R $USER:$USER "$USER_HOME/feroxbuster"

# Add Sublime Text editor repository
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list

# Update and upgrade system
apt update && apt upgrade -y && apt dist-upgrade -y

# Install essential tools and utilities
apt install -y \
    wget curl git thunar htop mc feroxbuster bat tree remmina \
    apt-transport-https sublime-text sublime-merge \
    seclists wordlists arandr flameshot arc-theme feh \
    kali-desktop-i3-gaps i3blocks i3status i3 i3-wm lxappearance \
    python3-pip rofi unclutter cargo compton papirus-icon-theme imagemagick \
    pwncat jq netexec



# Install Nerd Fonts
mkdir -p "$USER_HOME/.local/share/fonts"
cd "$USER_HOME/.local/share/fonts"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/RobotoMono.zip
unzip -o Iosevka.zip -d "$USER_HOME/.local/share/fonts"
unzip -o RobotoMono.zip -d "$USER_HOME/.local/share/fonts"
fc-cache -fv
chown -R $USER:$USER "$USER_HOME/.local/share/fonts"

# Download and set up additional tools
for i in "${!WINDOWS_TOOLS[@]}"; do
    mkdir -p "${TOOL_DIRS[$i]}"
    wget -q "${WINDOWS_TOOLS[$i]}" -O /tmp/tool.zip
    unzip -o /tmp/tool.zip -d "${TOOL_DIRS[$i]}"
    rm /tmp/tool.zip
    chown -R $USER:$USER "${TOOL_DIRS[$i]}"
done

# Extract rockyou wordlist
gzip -d /usr/share/wordlists/rockyou.txt.gz

# Install Oh My Zsh and plugins
#su - $USER -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
#for plugin in "${ZSH_PLUGINS[@]}"; do
    #su - $USER -c "git clone $plugin ~/.oh-my-zsh/plugins/$(basename $plugin)"
#done

# Install Alacritty
wget -q http://ftp.de.debian.org/debian/pool/main/r/rust-alacritty/alacritty_0.15.1-3_amd64.deb
dpkg -i alacritty_0.15.1-3_amd64.deb || apt-get -f install -y
rm alacritty_0.15.1-3_amd64.deb

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
wget -q https://github.com/bee-san/RustScan/releases/download/2.4.1/rustscan.deb.zip
unzip -o rustscan.deb.zip
dpkg -i rustscan.deb && rm rustscan.deb.zip


# Download and set up security tools
SECURITY_TOOLS=(
    "https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest"
    "https://api.github.com/repos/DominicBreuker/pspy/releases/latest"
    "https://api.github.com/repos/ropnop/kerbrute/releases/latest"
)
TOOL_DIRS=(/opt/peass /opt/pspy /opt/kerbrute)

for i in "${!SECURITY_TOOLS[@]}"; do
    mkdir -p "${TOOL_DIRS[$i]}"
    curl -sL "${SECURITY_TOOLS[$i]}" | jq -r ".assets[].browser_download_url" > /tmp/urls
    wget -i /tmp/urls -P "${TOOL_DIRS[$i]}"
    rm /tmp/urls
    chown -R $USER:$USER "${TOOL_DIRS[$i]}"
done

# Clone GitHub repositories
GITHUB_REPOS=(
    "https://github.com/rebootuser/LinEnum"
    "https://github.com/M4ximuss/Powerless"
    "https://github.com/ivan-sincek/php-reverse-shell.git"
    "https://github.com/samratashok/nishang.git"
    "https://github.com/itm4n/PrivescCheck.git"
    "https://github.com/stealthcopter/deepce.git"
    "https://github.com/dirkjanm/krbrelayx.git"
    "https://github.com/Anon-Exploiter/SUID3NUM.git"
    "https://github.com/commixproject/commix.git"
    "https://github.com/micahvandeusen/gMSADumper"
    "https://github.com/Flangvik/SharpCollection"
    "https://github.com/TH3xACE/SUDO_KILLER"
)
for repo in "${GITHUB_REPOS[@]}"; do
    git clone "$repo" /opt/$(basename "$repo" .git)
    chown -R $USER:$USER /opt/$(basename "$repo" .git)
done

# Set wallpaper and instructions
su - $USER -c "$USER_HOME/.fehbg"
echo "Done! Grab some wallpaper and run pywal -i filename to set your color scheme."
echo "After reboot: Select i3 on login, run lxappearance, and select arc-dark."
