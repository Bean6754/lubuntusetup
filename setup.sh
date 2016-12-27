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


cp -r sources.list /etc/apt/sources.list

clear

apt-get update -y
apt-get purge -y file-roller lxterminal firefox abiword gnumeric mplayer
apt-get install -y aptitude git wget curl vim i3 i3lock i3status i3blocks fonts-font-awesome lubuntu-restricted-extras lubuntu-restricted-addons vlc p7zip-full unrar rar build-essential chromium-browser libreoffice gimp xarchiver software-properties-gtk steam transmission-gtk transmission-cli default-jdk

clear

echo "NOTE: You will still have to install your specific drivers yourself. (amd64-microcode, intel-microcode, nvidia-driver, etc.."
echo "Launching software-properties-gtk to assist you in driver installation."

software-properties-gtk

echo "Copying i3 'config' to ~/.config/

echo "All done!"
