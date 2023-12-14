#!/usr/bin/env bash

echo "Device name (default: sdb)"
read;
DEVICE_NAME=${REPLY:-sdb}

mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME

