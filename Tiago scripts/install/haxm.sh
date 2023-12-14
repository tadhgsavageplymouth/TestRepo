#!/bin/usr/env bash


# https://github.com/intel/haxm/blob/master/docs/manual-linux.md
# HAXM modules need to be uninstalled
function ensure_haxm_unloaded() {
  if lsmod | grep haxm; then
    make uninstall
  fi
}


function download_haxm() {
  VERSION=$1

  apt-get install make nasm build-essential

  cd /tmp
  FILE_NAME=haxm.tar.gz
  wget -O $FILE_NAME "https://github.com/intel/haxm/archive/refs/tags/v${VERSION}.tar.gz"
  tar -xzf $FILE_NAME
}

function setup_haxm() {
  adduser `id -un` haxm

  VERSION="7.7.0"
  _download_haxm $VERSION

  cd haxm-${VERSION}/platforms/linux
  make
  make install
}
