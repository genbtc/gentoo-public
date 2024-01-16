#!/bin/bash
#2023 genr8eofl @ gentoo - amazing-make-partition-truncate.sh v0.33 - partitions the amazing disk image
#this is part 1, part 2 is amazing-mount-fs-partitions.sh
#Usage: # ./$0 [disk-image-filename($1)] [size($2)]

#takes $1 arg on command line or default to hard coded value
DISKIMG="${1:-verified-gentoo-1.dd}"
DISKSIZE="${2:-50G}"

#Existing?
if [ -e "${DISKIMG}" ]; then
    echo "Error! Disk Image found, it had already been created!" > /dev/stderr
    echo "To mount the root filesystem, Run:"
    echo "  amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
else
#Create a large enough disk image file, sparse, give it a name
    truncate --size="${DISKSIZE}" "${DISKIMG}"
    echo "Created disk image: ${DISKIMG} !"
fi

#TODO: rethink my selinux garbage
#selinux, context needs to be file read/write/ioctl'ed by kernel_t
#sesearch -A -s kernel_t -c file -p write | grep read
chcon -t tmpfs_t "${DISKIMG}"

SANITYCHECK=$(losetup)
if [ -e "${SANITYCHECK}" ]; then
    echo "Error. Loop device already exists! Why!? Exiting..." > /dev/stderr && exit
else
    echo "This will detach all previous loop devices..."
    losetup --detach-all
    #TODO: this is overkill
fi

#Create Loop Device
#DEVLOOP="/dev/loop0"
DEVLOOP=$(losetup --find --show --partscan "${DISKIMG}")
if [ ! -e "${DEVLOOP}" ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" > /dev/stderr && exit
#GOTO: END
else
    echo "Found loop device: ${DEVLOOP} !"
    #TODO: look at partitions, maybe we needed to wipe.
    #      fdisk -l ${DEVLOOP} || wipefs -a ${DEVLOOP}
fi

#Create Partitions (if we didnt error and exit by now )
#sfdisk - programmatic partition script (WARNING, ALWAYS WIPE!)
sfdisk --wipe=always "${DEVLOOP}" <<EEOF
#(very specific syntax, watch out for whitespace)
label: gpt
size= 100M, type= U, name="EFI"
#,100M,U,,
size= 250M, type= L, name="boot"
#,250M,L,,
size= , type= L, name="gentooROOT"
#,,V,,
EEOF
echo "Created disk image w/ partitions: EFI (p1), boot (p2), gentooROOT (p3) !"

#Create Filesystems on each of these partitions
mkfs.vfat "${DEVLOOP}"p1 -n EFI -F32 -v
mkfs.ext4 "${DEVLOOP}"p2 -L boot
mkfs.ext4 "${DEVLOOP}"p3 -L gentooROOT
echo "Created filesystems w/ mkfs: (EFI = fat32, boot/root = ext4)"
echo
echo "Complete! Finished making amazing disk image, partitions & filesystems! All done."
echo "To mount the root filesystem, Run:"
echo "  amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
