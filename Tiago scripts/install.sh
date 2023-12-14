#!/usr/bin/env bash

# Useful: https://medium.com/@vsburnett/how-to-set-up-an-android-emulator-in-windows-10-e0a3284b5f94

set -e
export DEBIAN_FRONTEND=noninteractive
export RUN_PATH=$(dirname "$(realpath $0)")

export UPDATE=true
export INSTALL_ANDROID_STUDIO=${INSTALL_ANDROID_STUDIO:-false} 
export MOUNT_EXTERNAL_DISK=${MOUNT_EXTERNAL_DISK:-true}

export REMOTE_USER=${REMOTE_USER:-tiago}
export SETUP_GOOGLE_REMOTE_DESKTOP=false
export SETUP_RDP=true

export ANDROID_SDK_ROOT=/opt/android-sdk
export PROFILE_FILE=/etc/profile

function append_profile () {
  str=$1
  file=${2:-$PROFILE_FILE}
  [ -z "$str" ] && echo "ERROR: Cannot append empty string to profile" && exit 1
  [ ! -f "$file" ] && echo "ERROR: Profile file $file doesn't exist" && exit 1
  grep -qxF "$str" $file || echo $str >> $file
}
append_profile 'export TERM=xterm'

$UPDATE && apt-get -qq update
apt-get install -yqq curl wget git ufw jq
apt-get remove -y --purge man-db

echo
echo "*** Mounting external disk ***"
source $RUN_PATH/install/disk.sh
$MOUNT_EXTERNAL_DISK && mount_external_disk || echo "Disk mounting disabled"

echo
echo "*** Installing android dependencies ***"
source $RUN_PATH/install/android.sh
setup_android

echo
echo "*** Downloading sdk data ***"
$RUN_PATH/install/sdk.sh

echo
echo "*** Providing remote access ***"
$RUN_PATH/install/remote.sh

echo
echo "*** Setting up KVM ***"
source $RUN_PATH/install/kvm.sh
setup_kvm

echo
echo "*** Setting ownerships ***"
setup_ownership

echo
echo "*** Installation completed, rebooting...***"
reboot
