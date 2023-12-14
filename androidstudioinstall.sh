# Installation of Android Studio and AVD's 
#! Bin/Bash
	sudo apt-get update
	sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
	sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
	sudo snap install android-studio --classic
#END 