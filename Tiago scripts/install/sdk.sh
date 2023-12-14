#!/usr/bin/env bash

source $PROFILE_FILE

printf "\n-- Setting up sdkmanager\n"
DEFAULT_PLATFORM="platforms;android-30"
DEFAULT_SYSTEM_IMAGE="system-images;android-30;google_apis_playstore;x86_64"

yes | sdkmanager --licenses > /dev/null
sdkmanager platform-tools emulator 
sdkmanager "$DEFAULT_PLATFORM"
sdkmanager "$DEFAULT_SYSTEM_IMAGE"
# avdmanager create avd -n test-device -k "$DEFAULT_SYSTEM_IMAGE"
