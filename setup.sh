#!/bin/bash

#Check script is running as a regular user.
if [[ $EUID -ne 0 ]]; then
  echo "Script is running as user.. Good!" 1>&2
else
  echo "Script is running as root.. Please run this script as a regular user with sudo rights." 1>&2
  exit 1
fi

#Check this user has sudo rights.
CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
if [ ${CAN_I_RUN_SUDO} -gt 0 ]
then
    echo "User has sudo rights.. Good!" 1>&2
else
    echo "User does not have sudo rights.. Please run this script as a regular user with sudo rights." 1>&2
    exit 1
fi

echo "Starting..."

# Check if 'config' directory exists or not.
if [ ! -d "configs" ]; then
  echo "'configs' directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'configs' directory found! Continuing.." 1>&2
fi
#Check if the files in there exist.
if [ ! -f "configs/.Xdefaults" ]; then
  echo "'.Xdefaults' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.Xdefaults' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.bash_profile" ]; then
  echo "'.bash_profile' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.bash_profile' config file was found! Continuing.." 1>&2
fi
#Check if 'i3' config directory exists or not.
if [ ! -d "configs/i3" ]; then
  echo "'i3' config directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3' config directory found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/config" ]; then
  echo "'i3/config' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/config' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/i3blocks.conf" ]; then
  echo "'i3/i3blocks.conf' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/i3blocks.conf' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/exit_menu.sh" ]; then
  echo "'i3/exit_menu.sh' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/exit_menu.sh' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.vimrc" ]; then
  echo "'.vimrc' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.vimrc' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.xinitrc" ]; then
  echo "'.xinitrc' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.xinitrc' config file was found! Continuing.." 1>&2
fi
#Check if 'Pictures' directory exists.
if [ ! -d "Pictures" ]; then
  echo "'Pictures' directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'Pictures' directory found! Continuing.." 1>&2
fi
if [ ! -f "Pictures/wave-1913559.jpg" ]; then
  echo "'wave-1913559.jpg' was not found. Exiting.." 1>&2
  exit 1
else
  echo "'wave-1913559.jpg' was found! Continuing.." 1>&2
fi
#Check that there is a valid internet connection by checking 'http://google.com/'
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "There is a valid internet connection (to 'http://google.com/'! Continuing.." 1>&2
else
    echo "No internet connection (to 'http://google.com/') was found. Exiting.." 1>&2
    exit 1
fi

sudo cp -r configs/sources.list /etc/apt/sources.list

clear

echo "Deleting potential apt lock files."
sudo rm -rf /var/lib/apt/lists/lock
sudo rm -rf /var/cache/apt/archives/lock
sudo rm -rf /var/lib/dpkg/lock
echo "Installing packages using apt (apt-get)."
sudo apt-get update -y
sudo apt-get install -y aptitude git wget curl vim links rxvt-unicode xorg xinit i3 i3lock i3status i3blocks suckless-tools feh rofi fonts-liberation fonts-dejavu fonts-ubuntu-font-family-console ttf-ubuntu-font-family fonts-font-awesome ubuntu-restricted-extras ubuntu-restricted-addons lxappearance vlc p7zip-full unrar rar build-essential redshift chromium-browser libreoffice gimp xarchiver software-properties-gtk steam transmission-gtk transmission-cli default-jdk qt5-default virtualbox alsa-base alsa-utils pulseaudio pavucontrol libdvd-pkg libbluray1
sudo dpkg-reconfigure libdvd-pkg
sudo apt-get autoremove -y

sudo usermod -a -G vboxusers $USER

clear

echo "NOTE: You will still have to install your specific drivers yourself. (amd64-microcode, intel-microcode, nvidia-driver, etc.."
echo "Launch 'software-properties-gtk' (in Xorg) to assist you in driver installation."

clear

echo "Please set a root password (and remember it!)"
sudo passwd root

echo "Backing up previous config files to '~/configbackups/."
mkdir -p ~/configbackups/i3/
cp -r ~/.bash_profile ~/configbackups/.bash_profile
cp -r ~/.config/i3/* ~/configbackups/i3/
cp -r ~/.vimrc ~/configbackups/.vimrc
cp -r ~/.Xdefaults ~/configbackups/.Xdefaults
cp -r ~/.xinitrc ~/configbackups/.xinitrc
echo "Deleting potentially existing config files."
rm -rf ~/.Xdefaults
rm -rf ~/.bash_profile
rm -rf ~/.config/i3/
rm -rf ~/.vimrc
sudo rm -rf /root/.vimrc
rm -rf ~/.xinitrc
echo "Copying '.Xdefaults' rxvt-unicode config file to '~/.Xdefaults'"
cp -r configs/.Xdefaults ~/.Xdefaults
echo "Copying '.bash_profile' bash login config to '~/.bash_profile'"
cp -r configs/.bash_profile ~/.bash_profile
echo "Copying i3 config files to '~/.config/i3/'"
mkdir -p ~/.config/i3/
cp -r configs/i3/* ~/.config/i3/
echo "Copying '.vimrc' vim config file to '~/.vimrc' and to '/root/.vimrc'"
cp -r configs/.vimrc ~/.vimrc
sudo cp -r configs/.vimrc /root/.vimrc
echo "Copying '.xinitrc' xorg config file to '~/.xinitrc'"
cp -r configs/.xinitrc ~/.xinitrc
#Copy wallpaper over to '~/Pictures' and renme it as 'Wallpaper.jpg', so feh can use it as the wallpaper for i3.
## Wallpaper link: https://pixabay.com/en/wave-atlantic-pacific-ocean-huge-1913559/
mkdir -p ~/Pictures/
cp -r Pictures/wave-1913559.jpg ~/Pictures/Wallpaper.jpg

echo "Create user directories."
mkdir -p ~/Desktop/ ~/Documents/ ~/Downloads/ ~/Music/ ~/Public/ ~/Templates/ ~/Videos/ ~/.fonts ~/.icons ~/.themes

echo "All done!"

sleep 4s

echo "Rebooting PC... Press Ctrl+C to cancel reboot operation."
sudo reboot
