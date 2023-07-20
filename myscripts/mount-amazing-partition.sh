#!/bin/bash
#2023 genr8eofl - @ gentoo - script v0.1 mounts the amazing partition dd

#start with a single file that has an entire disk inside it
DISKIMG="gentoo-amazing-1.dd"
if [ ! -e ${DISKIMG} ]; then
    echo "Cannot find ${DISKIMG} file" && exit 9
fi

#load .dd into loop device
DEVLOOP=$(losetup --find --show --partscan ${DISKIMG})
if [ ! -e ${DEVLOOP} ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" && exit
else
    echo "Found loop device: ${DEVLOOP} !"
fi

#genr8too /mnt/crucialp1 # restorecon -RFv /dev/loop1*
#Relabeled /dev/loop1p1 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
#Relabeled /dev/loop1p2 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
#Relabeled /dev/loop1p3 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
# or
#SELinux Relabel:
chcon -t fixed_disk_device_t /dev/loop1*
#chcon -t virtual_disk_device_t /dev/loop1*

#create new mount point
TARGET="/mnt/gentoo-amazing-1"
if [ ! -e ${TARGET} ]; then
    mkdir -p ${TARGET}
fi

#mount it, go!
mount ${DEVLOOP}p3 ${TARGET}
mount ${DEVLOOP}p2 ${TARGET}/boot
mount ${DEVLOOP}p1 ${TARGET}/boot/efi

#chroot in, go!
genr8-chroot.sh ${TARGET}
