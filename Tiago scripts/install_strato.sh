#!/usr/bin/env bash

# Useful: https://medium.com/@vsburnett/how-to-set-up-an-android-emulator-in-windows-10-e0a3284b5f94

export UPDATE=true
export INSTALL_ANDROID_STUDIO=true
export MOUNT_EXTERNAL_DISK=false

export REMOTE_USER=tiago
export SETUP_GOOGLE_REMOTE_DESKTOP=false
export SETUP_RDP=true

export ANDROID_SDK_ROOT=/opt/android-sdk

# Locales
export DEFAULT_LOCALE="en_GB.UTF-8"
apt-get install -y language-pack-en-base  
if ! locale -a | grep "${DEFAULT_LOCALE}"; then
  locale-gen ${DEFAULT_LOCALE}
fi

if ! locale | grep "LANG=${DEFAULT_LOCALE}"; then
  echo "Creating backup /etc/profile.bak just in case"
  cp /etc/profile /etc/profile.bak
  sed -i '/LANG=/d' /etc/profile 
  sed -i '/LANGUAGE=/d' /etc/profile 
  sed -i '/LC_ALL=/d' /etc/profile 

  update-locale LANG=${DEFAULT_LOCALE}
  echo "Locale updated, now rebooting"
  reboot
fi

./install.sh
