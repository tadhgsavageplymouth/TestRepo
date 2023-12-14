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
	sudo apt install gnome-software -y
	sudo snap install software-boutique --classic
	sudo apt install qemu-kvm -y
	sudo adduser hg kvm
	sudo reboot
#END