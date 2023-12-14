#!/usr/bin/env bash
# More info in https://developer.android.com/studio/run/emulator-acceleration#vm-linux

function check_kvm() {
  [[ "$(emulator -accel-check | sed -n '2p')" == "0" ]]
}


function setup_kvm() {
  apt-get install -yqq qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
  if check_kvm; then
    echo "Check kvm passed"
  else
    echo "ERROR: KVM not enabled, now exiting"
    exit 1
  fi
}
