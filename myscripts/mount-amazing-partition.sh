#!/bin/bash
#2023 genr8eofl - @ gentoo - script v0.17 mounts the amazing partition dd
# use /home/genr8eofl/src/gentoo-public/myscripts/make-partition-truncate.sh first

#start with a single file that has an entire disk inside it
STAGING="/mnt/crucialp1/"
DDNAME="stage3-gentoo-hardened-selinux-092423"
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

#create new mount point root / , p3
TARGET="/mnt/${DDNAME}/"
if [ ! -e ${TARGET} ]; then
    mkdir -p ${TARGET}
    echo "Creating Root target mount dir: ${TARGET} !"
else
    echo "Found existing Root target mount dir: ${TARGET} ..."
fi
#mount p3, go!
mount ${DEVLOOP}p3 ${TARGET}
echo "Mounted Root FS (partition 3) on ${TARGET}"

#create new boot/ mount points in new fs structure, p2
BOOTTARGET="/mnt/${DDNAME}/boot/"
if [ ! -e ${BOOTTARGET} ]; then
    mkdir -p ${BOOTTARGET}
    echo "Creating Boot target mount dir: ${BOOTTARGET} !"
else
    echo "Found existing Boot target mount dir: ${BOOTTARGET} ..."
fi
#mount p2, go!
mount ${DEVLOOP}p2 ${BOOTTARGET}
echo "Mounted Boot (partition 2) on ${BOOTTARGET}"

#create new boot/efi/ mount points in new new fs structure, p1
EFITARGET="/mnt/${DDNAME}/boot/efi/"
if [ ! -e ${EFITARGET} ]; then
    mkdir -p ${EFITARGET}
    echo "Creating EFI target mount dir: ${EFITARGET} !"
else
    echo "Found existing EFI target mount dir: ${EFITARGET} ..."
fi
#mount p1, go!
mount ${DEVLOOP}p1 ${EFITARGET}
echo "Mounted EFI (partition 1) on ${EFITARGET}"

#Create stub dir structure
mkdir -p ${TARGET}/{dev,sys,proc,run,tmp}
echo "Creating directory structure hierarchy for: /dev,sys,proc,run,tmp"

#TODO: needs to be conditional for first run or second run;
#if [-e fs marker exists]; then
##script Copy in and #Extract Tar of Stage3.xz
STAGE3="stage3-amd64-hardened-selinux-openrc-20230924T163139Z.tar.xz"
cp ${STAGING}/${STAGE3}  ${TARGET}
echo "Copying ${STAGE3} to ${TARGET}"
cd ${TARGET}
echo "Done! Ready and waiting to extract stage3 with Script #3 next phase: extract-stage3-all.sh"

#skipped. # TODO : Hold off on this, theres nothing to chroot into yet.
#else:
#chroot in, go!
#genr8-chroot ${TARGET}
#fi
