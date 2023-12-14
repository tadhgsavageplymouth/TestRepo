#!/usr/bin/env bash

set -e

[ -z "$1" ] && echo "ERROR: Missing [name] parameter." && usage
VM_NAME=$1

# Colors
source ./colors.sh

function title() {
  echo
  color pink "$1"
}

function success() {
  color green "$1"
}

function warning() {
  color yellow "$1"
}

DISK_SIZE=100GB
DISK_TYPE=pd-standard
USE_EXTERNAL_DISK=false
# DISK_NAME=test-android-system-images
#MACHINE_TYPE=n2-standard-8
MACHINE_TYPE=n2-custom-8-49152
# REGION=europe-central2
ZONE=europe-west2-c

function usage() {
  echo "usage: ./create_vm name"
  exit
}

function create_vm() {
  gcloud beta compute instances create $VM_NAME \
    --enable-nested-virtualization \
    --provisioning-model=SPOT \
    --service-account "default-compute@marsyas.iam.gserviceaccount.com" \
    --machine-type="$MACHINE_TYPE" \
    --zone="$ZONE" \
    --boot-disk-size="$DISK_SIZE"
    # --min-cpu-platform="Intel Haswell" \
}

  # gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

title "Creating instance $VM_NAME..."
if gcloud beta compute instances list | grep -q $VM_NAME; then
  warning "Instance $VM_NAME already exists, want to delete it (y/n)? "
  read;
  ANS=${REPLY}
  if [ "$ANS" = "y" ]; then
    gcloud beta compute instances delete $VM_NAME --delete-disks=all --quiet
    success "Instance $VM_NAME and its disks where deleted."
    create_vm
  else 
    echo "Using existing vm..."
  fi
else
  create_vm
fi


# Disks
if [[ "$USE_EXTERNAL_DISK" == "true" ]]; then
  DISK_NAME=${VM_NAME}-external
  title "Setting up disk $DISK_NAME"
  if gcloud compute disks list | grep -q $DISK_NAME; then
    echo "Disk $DISK_NAME already exists"
  else
    echo "Creating $DISK_NAME with size $DISK_SIZE"
    gcloud compute disks create $DISK_NAME \
      --size $DISK_SIZE \
      --type $DISK_TYPE > /dev/null
  fi
  
  # Attach shared disk
  gcloud compute instances attach-disk $VM_NAME \
    --disk $DISK_NAME 

fi

title "Copying files to instance"
sleep 10
gcloud beta compute scp --recurse ~/git/marsyas/androidfax/scripts/* $VM_NAME:~ 

title "Installing dingo"
gcloud beta compute scp ~/git/marsyas/androidfax/dingo/hind/bin/marsyas-dingo.tar.gz $VM_NAME:/tmp/
gcloud beta compute ssh $VM_NAME --command="cd /tmp && tar -xzf marsyas-dingo.tar.gz && sudo install marsyas-dingo-hind /usr/local/bin/dingo"

title "Now installing..."
gcloud beta compute ssh $VM_NAME --command="chmod +x install.sh install_gcp.sh install/*"
gcloud beta compute ssh $VM_NAME --command="nohup sudo ./install_gcp.sh > install.log &"
gcloud beta compute ssh $VM_NAME --command="tail -500f install.log"

title "Installation completed, jumping into instance"
gcloud beta compute ssh $VM_NAME

# gcloud beta compute ssh $VM_NAME --command="chmod +x install.sh && sudo ./install.sh"
