#!/bin/bash

# System Update
sudo apt-get update
#Install snap
sudo apt install snapd -y
#Instal Core
sudo snap install core
#Install XFCE Desktop
sudo apt install task-xfce-desktop -y
#Install XRDP
sudo apt-get install xrdp -y
#Change Timezone to London GMT
sudo timedatectl set-timezone Europe/London
#Install Gnome
sudo apt install gnome-software -y
#Install Boutique
sudo snap install software-boutique --classic -y
#Install Android Studio Classic
sudo snap install android-studio --classic -y
#Install KVM
sudo apt install qemu-kvm -y

#Adding User hg
export USER_NAME=hg
export TMP_PASSWORD=Tigerbear1!


# Magic and such
apt-get update

# Create user with temporary password
useradd -m $USER_NAME -s /bin/bash
echo "$USER_NAME:$TMP_PASSWORD" | chpasswd
usermod -aG sudo $USER_NAME
mkdir -p /home/$USER_NAME/.ssh
chown $USER_NAME:$USER_NAME /home/$USER_NAME

#Add User hg to KVM
sudo adduser hg kvm
#Ensuring Android Studio Opens (Confines)
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine* 
#Ensuring Android Studio Opens (Confines)
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
#Reboot Machine
reboot 