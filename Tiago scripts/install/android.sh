#!/usr/bin/env bash

PROFILE_FILE=${PROFILE_FILE:-/etc/profile}
ANDROID_SDK_ROOT=/opt/android-sdk
ANDROID_AVD_HOME=$ANDROID_SDK_ROOT/avd # Emulator is being dumb
ANDROID_HOME=$ANDROID_SDK_ROOT

INSTALL_ANDROID_STUDIO=${INSTALL_ANDROID_STUDIO:-false} # Skip when full server
ANDROID_VERSION=2021.3.1.16
STUDIO_FILE_NAME=android-studio-$ANDROID_VERSION-linux.tar.gz
TOOLS_FILE_NAME=commandlinetools-linux-7583922_latest.zip

GROUP_NAME="android"

# Functions

function append_profile () {
  str=$1
  [ -z "$str" ] && echo "Cannot append empty string to profile" && exit 1
  grep -qxF "$str" $PROFILE_FILE || echo $str >> $PROFILE_FILE
}
append_profile 'export TERM=xterm'

# Process

function setup_android() {
  apt-get install -yqq default-jdk libvulkan1 mesa-vulkan-drivers vulkan-utils

  mkdir -p $ANDROID_SDK_ROOT 
  if [ $(getent group $GROUP_NAME) ]; then
    echo "Group $GROUP_NAME already exists, not creating it"
  else
    groupadd $GROUP_NAME
  fi

  cd /tmp

  if ! $INSTALL_ANDROID_STUDIO; then echo "!! skipping android-studio";
  elif [ -d $ANDROID_HOME/android-studio ]; then echo "android-studio already installed";
  else
   wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/$ANDROID_VERSION/$STUDIO_FILE_NAME
   tar -xzf $STUDIO_FILE_NAME 
   mv android-studio $ANDROID_HOME
   rm $STUDIO_FILE_NAME
  fi

  if [ -d "$ANDROID_HOME/cmdline-tools" ]; then
    echo "cmdline-tools already installed";
  else
    apt-get install -yqq unzip
    wget https://dl.google.com/android/repository/$TOOLS_FILE_NAME
    unzip $TOOLS_FILE_NAME
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest
    rm $TOOLS_FILE_NAME
  fi

  echo "Setting up android profile env vars"
  mkdir -p $ANDROID_SDK_ROOT/avd/{uuids,logs}
  mkdir -p $ANDROID_SDK_ROOT/platform-tools; # Required so profile doesn't freak out
  append_profile 'export ANDROID_SDK_ROOT=/opt/android-sdk'
  # append_profile 'export ANDROID_AVD_HOME=$ANDROID_SDK_ROOT/avd' # Not needed, will use default 
  append_profile 'export ANDROID_HOME=$ANDROID_SDK_ROOT'
  append_profile 'export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools'
  # source $PROFILE_FILE

  echo "Opening ufw 5555/tcp"
  ufw allow 5555/tcp # for adb connections
}

function setup_ownership() {
  chown -R root:$GROUP_NAME $ANDROID_SDK_ROOT
  chmod g+rw .
  chmod g+rw -R $ANDROID_SDK_ROOT/platforms $ANDROID_SDK_ROOT/system-images
}
