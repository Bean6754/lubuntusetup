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


sudo cp -r sources.list /etc/apt/sources.list

clear

sudo apt-get update -y
sudo apt-get purge -y file-roller lxterminal firefox abiword gnumeric mplayer
sudo apt-get install -y aptitude git wget curl vim i3 i3lock i3status i3blocks fonts-font-awesome lubuntu-restricted-extras lubuntu-restricted-addons vlc p7zip-full unrar rar build-essential redshift chromium-browser libreoffice gimp xarchiver software-properties-gtk steam transmission-gtk transmission-cli default-jdk

clear

echo "NOTE: You will still have to install your specific drivers yourself. (amd64-microcode, intel-microcode, nvidia-driver, etc.."
echo "Launching software-properties-gtk to assist you in driver installation."

software-properties-gtk

echo "Backing up previous i3configs."
mkdir -p ~/i3backups/
cp -r ~/.config/i3/* ~/i3backups/
echo "Deleting i3 config folder."
rm -rf ~/.config/i3/
echo "Copying i3 config files to ~/.config/i3/
mkdir -p ~/.config/i3/
cp -r i3/* ~/.config/i3/

echo "All done!"
