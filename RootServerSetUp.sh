 # Full Sever Set Up
 # Only has user root, no others
 sudo apt-get update
 sudo apt install snapd -y
 sudo snap install core
 sudo apt install task-xfce-desktop -y
 sudo apt-get install xrdp -y
 sudo timedatectl set-timezone Europe/London
 sudo apt-get install -y xdotool
 sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
 sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
 sudo apt install gnome-software -y
 sudo snap install software-boutique --classic
 sudo snap install android-studio --classic
 sudo apt install qemu-kvm -y
 sudo adduser root kvm
 sudo reboot
 