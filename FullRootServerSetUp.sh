#! Bin/Bash
# Full Server Set Up. 
# Ensure all firewall ports are open as necessary
# Need to add user (hg) password (Tigerbear1!) and do visudo. 
# Need to press enter on Desktop set up
 sudo apt-get update
 sudo apt install snapd -y
 sudo snap install core
 sudo apt install task-xfce-desktop -y
 sudo apt-get install xrdp -y
 sudo timedatectl set-timezone Europe/London
 sudo sshpass -p Tigerbear1! ssh hg@34.71.175.128
 sudo apt-get install -y xdotool
 sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
 sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
 sudo apt install gnome-software -y
 sudo snap install software-boutique --classic
 sudo snap install android-studio --classic
 sudo apt install qemu-kvm -y
 sudo snap remove android-studio
 sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
 sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
 sudo snap install android-studio --classic
 sudo adduser hg kvm
 sudo reboot
#End 
