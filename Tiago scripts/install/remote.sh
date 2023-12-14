#!/usr/bin/env bash

SETUP_RDP=${SETUP_RDP:true}
SETUP_GOOGLE_REMOTE_DESKTOP=${SETUP_GOOGLE_REMOTE_DESKTOP:-false}

function append_profile () {
  str=$1
  file=${2:-$PROFILE_FILE}
  [ -z "$str" ] && echo "ERROR: Cannot append empty string to profile" && exit 1
  grep -qxF "$str" $file || echo $str >> $file
}

[ -z "$REMOTE_USER" ] && echo "ERROR: REMOTE_USER not set!" && exit 1
useradd -m -s /bin/bash $REMOTE_USER
adduser $REMOTE_USER kvm
adduser $REMOTE_USER android # Need to create this first

REMOTE_PROFILE=/home/$REMOTE_USER/.bashrc
touch $REMOTE_PROFILE

# Setup avd directory in external disk
ANDROID_AVD_HOME=/home/$REMOTE_USER/.android/avd
STORAGE_PATH=$ANDROID_SDK_ROOT/storage/$REMOTE_USER
append_profile "export ANDROID_AVD_HOME=$ANDROID_AVD_HOME" $REMOTE_PROFILE # https://developer.android.com/studio/run/emulator-commandline#data-filedir

mkdir -p $STORAGE_PATH
ln -s $ANDROID_AVD_HOME $STORAGE_PATH 
chown -R $REMOTE_USER:$REMOTE_USER $STORAGE_PATH 

append_profile "source /etc/profile" $REMOTE_PROFILE

apt-get install -yqq xfce4 desktop-base dbus-x11 xscreensaver task-xfce-desktop # xfce
apt-get install -yqq xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils

# USING RDP
if $SETUP_RDP; then
  apt-get install -yqq xrdp
  adduser xrdp ssl-cert
  ufw allow 3389/tcp

  echo "xfce4-session" > /home/$REMOTE_USER/.xsession
  echo "xset s off" >> /home/$REMOTE_USER/.xsession # Disable power management and screensaver
  chmod +x /home/$REMOTE_USER/.xsession

  append_profile "unset DBUS_SESSION_BUS_ADDRESS"
  # append_profile "unset XDG_RUNTIME_DIR"

  systemctl enable xrdp
  systemctl restart xrdp
## ufw allow from 192.168.1.0/24 to any port 3389
fi

# apt-get install -y task-kde-desktop
systemctl disable lightdm.service

if $SETUP_GOOGLE_REMOTE_DESKTOP; then
  # Chrome Remote Desktop
  apt-get install --assume-yes wget tasksel
  cd /tmp
  wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
  apt-get install -yqq ./chrome-remote-desktop_current_amd64.deb
  echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session

  echo "INSERT REMOTE CODE:"
  read;
  REMOTE_CODE=${REPLY}

  # This code is valid one time!
  DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="$CODE" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname) --user-name=$REMOTE_USER
fi

chown -R $REMOTE_USER:$REMOTE_USER /home/$REMOTE_USER
echo "PLEASE REMEMBER TO RESET $REMOTE_USER PASSWORD!"

