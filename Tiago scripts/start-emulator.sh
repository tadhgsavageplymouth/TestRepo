#!/bin/bash

set -e

### Colors ##
ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
GREEN="${ESC}[32m" YELLOW="${ESC}[33m" BLUE="${ESC}[34m" MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m" WHITE="${ESC}[37m" DEFAULT="${ESC}[39m"

### Color Functions ##
green() { printf "${GREEN}%s${RESET}\n" "$1"; }
blue() { printf "${BLUE}%s${RESET}\n" "$1"; }
red() { printf "${RED}%s${RESET}\n" "$1"; }
yellow() { printf "${YELLOW}%s${RESET}\n" "$1"; }
magenta() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
cyan() { printf "${CYAN}%s${RESET}\n" "$1"; }

## CONFIG
# SYSTEM_IMAGE="system-images;android-30;google_apis_playstore;x86_64"
SYSTEM_IMAGE="system-images;android-30;default;x86_64"
DEVICE="pixel_4a"

## Functions ##
# UUID
# UUIDS_PATH=~/.marsyas/uuids
UUIDS_PATH=$ANDROID_AVD_HOME/uuids
LOGS_PATH=$ANDROID_AVD_HOME/logs

ensure_dir() {
  local path=$1
  [ -z "$path" ] && echo "Error: path cannot be empty" && return 1
  [ ! -d "$path" ] && mkdir -p $path && chown -R root:android $path
}

get_uuid() {
  [ -z "$1" ] && echo "ERROR: no device name to get uuid from" && exit 2
  device_name=$1
  file_path=$UUIDS_PATH/$device_name
  random_path=/proc/sys/kernel/random/uuid

  [ -z "$file_path" ] && cat $file_path || cat $random_path
}

usage() {
  printf "Usage: ./start-emulator device-name\n\n"
}

error() {
  printf "${RED}Error:${RESET} %s\n" "$1"
}

tick() {
  printf "${GREEN}✔${RESET} "
}

# Setup
# ensure_dir $UUIDS_PATH
# ensure_dir $LOGS_PATH

# START
DEVICE_NAME=$1
[ -z "$DEVICE_NAME" ] && printf "\nDevice name expected.\n" && usage && exit 1;

# Make sure system-iamge exists
if ! sdkmanager --list_installed | grep -q $SYSTEM_IMAGE; then
  echo "System image $(yellow $SYSTEM_IMAGE) not found, now installing..."
  sdkmanager $SYSTEM_IMAGE
else
  tick
  echo "System image $(green $SYSTEM_IMAGE) already exists, continuing."
fi

# Create device if it doesn't exist
if ! emulator -list-avds | grep -q $DEVICE_NAME; then
  echo
  echo "Device $(yellow $DEVICE_NAME) doesn't exist, creating now..."
  avdmanager -s create avd \
    -n $DEVICE_NAME \
    -k $SYSTEM_IMAGE \
    -p $ANDROID_AVD_HOME \
    -d $DEVICE
#    --abi google_apis/x86_64
  # targets live in <sdk>/platform and <sdk>/add-ons
else
  tick
  echo "Device $(green $DEVICE_NAME) already exists, continuing."
fi

mkdir -p $UUIDS_PATH
UUID=$(get_uuid $DEVICE_NAME)
echo $UUID > $UUIDS_PATH/$DEVICE_NAME

echo
echo "Starting $(green $DEVICE_NAME) with uuid $(green \"$UUID\")"
# echo "System image: $(yellow $SYSTEM_IMAGE)"
LOG_FILE=$LOGS_PATH/$DEVICE_NAME
printf "\n\nStartup from start-emulator at $(date +%Y.%m.%d %H:%M:%S)\n" | tee
-a $LOG_FILE
emulator \
  -avd "$DEVICE_NAME" \
  -prop qemu.uuid="$UUID" \
  -no-audio -no-passive-gps -no-boot-anim \
  |& tee -a $LOG_FILE
