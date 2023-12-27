#!/bin/bash
# mount-partition.sh script v0.7 by @genr8eofl copyright 2023 - AGPL3 License
# Description: mounts the partition dd! (adapted from amazing-mount-fs-partitions.sh)
# Note: this expects an image containing only 1 filesystem, or 1 partition, (ie /dev/sda3)

STAGINGDIR="${PWD:-/mnt/crucialp1/}"
#Take arg $1 from command line, or use hardcoded default filename after the :-
DISKIMG="${1:-gentooKDE-N3450-6.1.38-Dec1723.dd}"

#start with a single file
if [ ! -e "${DISKIMG}" ]; then
    echo "ERROR. Cannot find ${DISKIMG} file" >&2 && exit 9
fi

#Load .dd into loop device (has one or more partitions inside it)
DEVLOOP=$(losetup --find --show --partscan "${DISKIMG}")
if [ ! -e "${DEVLOOP}" ]; then
    echo "ERROR. Failed to set up Loop Device, or Loop Device not found. Exiting!" >&2 && exit 6
else
    echo "Found loop device: ${DEVLOOP} !"
fi

#Cleanup my Selinux Relabel garbage
#TODO: If Selinux:
chcon -t virtual_disk_device_t -v "${DEVLOOP}"*

#chop .dd extension off to use for dirname
DDNAME="${DISKIMG%.dd}"

#Create mount point under /mnt to hold rootfs /
TARGET="/mnt/${DDNAME}/"
if [ ! -e "${TARGET}" ]; then
    mkdir -p "${TARGET}"
    echo "Creating Root target dir: ${TARGET} !"
else
    echo "Found existing Root target dir: ${TARGET} ..."
fi

#mount partition!
mount "${DEVLOOP}" "${TARGET}"
echo "Mounted Root FS Partition on ${TARGET}"

#Complete!
echo "Done! now Run: genr8-chroot ${TARGET}"
cd "${TARGET}" || exit 1
