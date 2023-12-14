#!/usr/bin/env bash

# Useful: https://medium.com/@vsburnett/how-to-set-up-an-android-emulator-in-windows-10-e0a3284b5f94

UPDATE=true
export INSTALL_ANDROID_STUDIO=true
export MOUNT_EXTERNAL_DISK=false

export SETUP_GOOGLE_REMOTE_DESKTOP=false
export SETUP_RDP=true

export ANDROID_SDK_ROOT=/opt/android-sdk

./install.sh
