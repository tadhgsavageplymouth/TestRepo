#!/usr/bin/env bash

DEVICE_NAME=/dev/sdb
DISK_MOUNT_PATH=$ANDROID_SDK_ROOT

# Mount system-images disk to share heavy images
# https://cloud.google.com/compute/docs/disks/add-persistent-disk#gcloud
function disk_id() {
  disk=$1 
  lsblk -f --json | jq -r ".blockdevices[] | select(.name==\"$disk\") | .uuid"
}

function fstab_string() {
  device_id=$1
  echo "UUID=$device_id $DISK_MOUNT_PATH ext4 discard,defaults,nofail 0 2" 
}


function mount_external_disk () {
  [ -z "$DISK_MOUNT_PATH" ] && echo "ERROR: There is no mount path for the disk" && return 1

  if cat /proc/mounts | grep -qs "$DISK_MOUNT_PATH"; then
    echo "Disk $DEVICE_NAME already mounted"
  else
    # rm -f $SYSTEM_IMAGES_PATH
    mkdir $DISK_MOUNT_PATH

    if lsblk -f | grep sdb | grep ext4; then
      echo "$DEVICE_NAME already formated in ext4, continuing..."
    else
      echo "Formatting $DEVICE_NAME"
      mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE_NAME
    fi

    echo "Mounting $DEVICE_NAME to $DISK_MOUNT_PATH"
    mount -o discard,defaults $DEVICE_NAME $DISK_MOUNT_PATH
    chmod a+w $DISK_MOUNT_PATH
  fi

  # Obtained with blkid /dev/sdb
  # device_id=$(blkid | grep $DEVICE_NAME | grep -oE "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}")
  device_id=$(disk_id "sdb")
  [ -z "$device_id" ] && echo "ERROR: device_id is empty (disk.sh)" && exit 1
  echo "## Adding $device_id to fstab"
  if grep -qs $device_id /etc/fstab; then
    echo "Device $device_id already set in fstab" 
  elif grep -qs $DISK_MOUNT_PATH /etc/fstab; then
    sed -i '/$DISK_MOUNT_PATH/d' /etc/fstab
    fstab_string "$device_id" >> /etc/fstab
  else 
    fstab_string "$device_id" >> /etc/fstab
  fi

}
