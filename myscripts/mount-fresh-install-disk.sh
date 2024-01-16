#!/bin/bash
# mount-fresh-install-disk.sh - v0.6 - by @genr8eofl copyright 2023 - AGPL3 License
# (adapted from amazing-mount-fs-partitions.sh script v0.5)
# Description: mounts the first disk as gentoo and extracts the stage3
# Note: this is part 2, use part 1 make-partition-truncate.sh first

#Take arg $1 from command line, or hardcode default filepath here
DISKIMG="${1:-/dev/sda}"
DIRNAME="${2:-gentoo}"

#start with a single disk/image file that has an entire disk inside it
if [ ! -e "${DISKIMG}" ]; then
    echo "Cannot find ${DISKIMG} file" > /dev/stderr && exit 9
fi

#3-Create new mount point /mnt/___ for root fs / , 3
TARGET="/mnt/${DIRNAME}/"
if [ ! -e "${TARGET}" ]; then
    mkdir -p "${TARGET}"
    echo "Creating Root target dir: ${TARGET} !"
else
    echo "Found existing Root target dir: ${TARGET} ..."
fi
#mount 3, go!
mount "${DISKIMG}3" "${TARGET}"
echo "Mounted Root FS (partition 3) on ${TARGET}"

#2-Create new boot/ mount points for new fs structure, 2
BOOTTARGET="${TARGET}boot/"
if [ ! -e "${BOOTTARGET}" ]; then
    mkdir -p "${BOOTTARGET}"
    echo "Creating Boot target dir: ${BOOTTARGET} !"
else
    echo "Found existing Boot target dir: ${BOOTTARGET} ..."
fi
#mount 2, go!
mount "${DISKIMG}2" "${BOOTTARGET}"
echo "Mounted Boot (partition 2) on ${BOOTTARGET}"

#1-Create new boot/efi/ mount points for new fs structure, 1
EFITARGET="${TARGET}boot/efi/"
if [ ! -e "${EFITARGET}" ]; then
    mkdir -p "${EFITARGET}"
    echo "Creating EFI target dir: ${EFITARGET} !"
else
    echo "Found existing EFI target dir: ${EFITARGET} ..."
fi
#mount 1, go!
mount "${DISKIMG}1" "${EFITARGET}"
echo "Mounted EFI (partition 1) on ${EFITARGET}"

#Create stub top-level dir structure
mkdir -p "${TARGET}"/{dev,sys,proc,run,tmp}
echo "Created directory structure hierarchy for: /dev,sys,proc,run,tmp"

#Copy in and Extract Tar of Stage3.tar.xz / or check if exists already.
STAGE3=(*.tar.xz)
#A) doesnt exist
if [ ! -e "${TARGET}/${STAGE3}" ]; then
    #Store stage3 inside image itself so extract script can work
    echo "Copying ${STAGE3} to root of image  @ ${TARGET}"
    cp --no-clobber "${STAGE3}"  "${TARGET}"
    #TODO: this still seems un-needed
fi
#B) It exists
if [ ! -e "${TARGET}"/.extractedtar ]; then
    cd "${TARGET}" || exit 1
    echo "Extracting ${STAGE3} with tar to rootfs mount dir @ ${TARGET} ............."
    tar xpf "${STAGE3}" --xattrs-include='*.*' --numeric-owner --skip-old-files
    touch "${TARGET}"/.extractedtar
    echo "Done extracting stage3 to ${TARGET} !"
else
    echo ".extractedtar file found - skipping extraction of .tar.xz"
fi

echo "Done! now Run: genr8-chroot ${TARGET}"
cd "${TARGET}" || exit 1
