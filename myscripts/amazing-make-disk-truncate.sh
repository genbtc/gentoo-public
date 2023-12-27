#!/bin/bash
#2023 genr8eofl @ gentoo - amazing-make-disk-truncate.sh v0.4 -
#this is part 1 , part 2 is amazing-make-partitions , part 3 is amazing-mount-fs-partitions.sh

#Usage: # ./$0 [disk-image-filename]($1) [image-size]($2)

#takes $1 arg on command line or default to hard coded value
DISKIMG="${1:-verified-gentoo-1.dd}"
DISKSIZE="${2:-50G}"

#Existing?
if [ -e "${DISKIMG}" ]; then
    echo "Error! Disk Image found, it had already been created!"
    echo "To mount the root filesystem, Run:"
    echo "  amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
else
#Create a large enough disk image file, sparse, give it a name
    truncate --size="${DISKSIZE}" "${DISKIMG}"
    echo "Created disk image: ${DISKIMG} !"
fi

#selinux, context needs to be file read/write/ioctl'ed by kernel_t
chcon -t virtual_disk_device_t "${DISKIMG}"

SANITYCHECK=$(losetup)
if [ -e "${SANITYCHECK}" ]; then
    echo "Error. Loop device already exists! Why!? Exiting..." >&2 && exit
else
    echo "This will detach all previous loop devices..."
    losetup --detach-all
    #TODO: this is overkill. is it?
fi

#Create Loop Device
#DEVLOOP="/dev/loop0" #default
DEVLOOP=$(losetup --find --show --partscan "${DISKIMG}")
if [ ! -e "${DEVLOOP}" ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" >&2 && exit
#GOTO: END
else
    echo "Found loop device: ${DEVLOOP} !"
    #TODO: look at partitions, maybe we needed to wipe.
    #      fdisk -l ${DEVLOOP} || wipefs -a ${DEVLOOP}
	# or print whats going on at this end point state
fi
