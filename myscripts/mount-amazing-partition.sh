#!/bin/bash
#2023 genr8eofl - @ gentoo - script v0.15 mounts the amazing partition dd

#start with a single file that has an entire disk inside it
DDNAME="gentoo-amazing-1-hardenedselinux1"
DISKIMG="${DDNAME}.dd"
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
chcon -t fixed_disk_device_t /dev/loop*
#chcon -t virtual_disk_device_t /dev/loop1*

#create new mount point /
TARGET="/mnt/${DDNAME}/"
if [ ! -e ${TARGET} ]; then
    mkdir -p ${TARGET}
fi
#mount it, go!
mount ${DEVLOOP}p3 ${TARGET}/

#create new boot/ mount points in new fs structure
BOOTTARGET="/mnt/${DDNAME}/boot/"
if [ ! -e ${BOOTTARGET} ]; then
    mkdir -p ${BOOTTARGET}
fi
#mount it, go!
mount ${DEVLOOP}p2 ${TARGET}/boot/

#create new boot/efi/ mount points in new new fs structure
EFITARGET="/mnt/${DDNAME}/boot/efi/"
if [ ! -e ${EFITARGET} ]; then
    mkdir -p ${EFITARGET}
fi
#mount it, go!
mount ${DEVLOOP}p1 ${TARGET}/boot/efi/

#Create dir structure
mkdir -p ${TARGET}/{dev,sys,proc,run,tmp}

##script Copy in and #Extract Tar of Stage3.xz
#cp /mnt/crucialp1/stage3-amd64-hardened-nomultilib-selinux-openrc-20230625T165009Z.tar.xz ${TARGET}
#cd ${TARGET}
#extract-stage3-all.sh
##skipped.

#Hold off on this, theres nothing to chroot into.
#chroot in, go!
genr8-chroot ${TARGET}
