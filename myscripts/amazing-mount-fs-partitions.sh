#!/bin/bash
# amazing-mount-fs-partitions.sh script v0.5 by @genr8eofl copyright 2023 - AGPL3 License
# Description: mounts the amazing partition dd!
# Note: this is part 2, use part 1 make-partition-truncate.sh first

STAGINGDIR="${PWD:-/mnt/crucialp1/}"
#Take arg $1 from command line, or hardcode default filepath here
DISKIMG="${1:-gentooROOT-stage3-amd64-hardened-nomultilib-selinux-openrc-1.dd}"
#start with a single file that has an entire disk inside it
if [ ! -e "${DISKIMG}" ]; then
    echo "Cannot find ${DISKIMG} file" > /dev/stderr && exit 9
fi

#Load .dd into loop device
DEVLOOP=$(losetup --find --show --partscan "${DISKIMG}")
if [ ! -e "${DEVLOOP}" ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" > /dev/stderr && exit 6
else
    echo "Found loop device: ${DEVLOOP} !"
fi

#TODO: cleanup (my Selinux garbage)
#TODO  if selinux, relabel.
#genr8too /mnt/crucialp1 # restorecon -RFv /dev/loop1*
#Relabeled /dev/loop1p1 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
#Relabeled /dev/loop1p2 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
#Relabeled /dev/loop1p3 from system_u:object_r:device_t to system_u:object_r:fixed_disk_device_t
# or
#SELinux Relabel:
chcon -t fixed_disk_device_t -v "${DEVLOOP}"*
#chcon -t virtual_disk_device_t -v /dev/loop0*

#chop .dd extension off to use for dirname
DDNAME="${DISKIMG%.dd}"

#3-Create new mount point root / , p3
TARGET="/mnt/${DDNAME}/"
if [ ! -e "${TARGET}" ]; then
    mkdir -p "${TARGET}"
    echo "Creating Root target dir: ${TARGET} !"
else
    echo "Found existing Root target dir: ${TARGET} ..."
fi
#mount p3, go!
mount "${DEVLOOP}p3" "${TARGET}"
echo "Mounted Root FS (partition 3) on ${TARGET}"

#2-Create new boot/ mount points in new fs structure, p2
BOOTTARGET="${TARGET}/boot/"
if [ ! -e "${BOOTTARGET}" ]; then
    mkdir -p "${BOOTTARGET}"
    echo "Creating Boot target dir: ${BOOTTARGET} !"
else
    echo "Found existing Boot target dir: ${BOOTTARGET} ..."
fi
#mount p2, go!
mount "${DEVLOOP}p2" "${BOOTTARGET}"
echo "Mounted Boot (partition 2) on ${BOOTTARGET}"

#1-Create new boot/efi/ mount points in new new fs structure, p1
EFITARGET="${TARGET}/boot/efi/"
if [ ! -e "${EFITARGET}" ]; then
    mkdir -p "${EFITARGET}"
    echo "Creating EFI target dir: ${EFITARGET} !"
else
    echo "Found existing EFI target dir: ${EFITARGET} ..."
fi
#mount p1, go!
mount "${DEVLOOP}p1" "${EFITARGET}"
echo "Mounted EFI (partition 1) on ${EFITARGET}"

#Create stub top-level dir structure
mkdir -p "${TARGET}"/{dev,sys,proc,run,tmp}
echo "Created directory structure hierarchy for: /dev,sys,proc,run,tmp"

#TODO: refactor this name out to $2
#Copy in and Extract Tar of Stage3.xz / or check if exists already.
STAGE3=("${DDNAME//_1}"*.tar.xz)
#"-stage3-amd64-hardened-nomultilib-selinux-openrc-20231001T170148Z.tar.xz"
#doesnt exist
if [ ! -e "${TARGET}/${STAGE3}" ]; then
    #Store stage3 inside image itself so extract script can work
    echo "Copying ${STAGE3} to root of image  @ ${TARGET}"
    cp --no-clobber "${STAGINGDIR}/${STAGE3}"  "${TARGET}"
    #TODO: this still seems un-needed
fi
#It exists
if [ ! -e "${TARGET}"/.extractedtar ]; then
    cd "${TARGET}" || exit 1
    echo "Extracting ${STAGE3} with tar to root mount dir @ ${TARGET} ............."
    tar xpf "${STAGINGDIR}/${STAGE3}" --xattrs-include='*.*' --numeric-owner --skip-old-files
    touch "${TARGET}"/.extractedtar
else
    echo ".extractedtar file found - skipping extraction of .tar.xz"
fi
echo "Done! now Run: genr8-chroot ${TARGET}"
cd "${TARGET}" || exit 1
# or if its extracted already:
#do the chroot in, just go!
#genr8-chroot "${TARGET}"
