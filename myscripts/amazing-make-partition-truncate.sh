#!/bin/bash
#2023 genr8eofl @ gentoo - amazing-make-partition-truncate.sh v0.3 - partitions the amazing disk image

DISKSIZE="25G"  #enough
#takes $1 arg on command line or default to hard coded value
DISKIMG="${1-:stage3-gentoo-hardened-selinux-092423.dd}"

#Create a large enough file, sparse, give it a name
if [ -e ${DISKIMG} ]; then
    echo "Error! Disk Image found, it was already created!"
    echo
    echo "  Run: amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
else
    truncate --size=${DISKSIZE} ${DISKIMG}
    echo "Created disk image: ${DISKIMG} !"
fi

#selinux, context needs to be file read/write/ioctl'ed by kernel_t
#sesearch -A -s kernel_t -c file -p write | grep read
chcon -t tmpfs_t ${DISKIMG}

#DEVLOOP="/dev/loop0"
SANITYCHECK=$(losetup)
if [ -e ${SANITYCHECK} ]; then
    echo "Error. Loop device already exists! Why!? Exiting..." && exit
else
    echo "WARNING !!! detaching previous loop devices ! WARNING !"
    losetup --detach-all
fi

#Create Loop Device
DEVLOOP=$(losetup --find --show --partscan ${DISKIMG})
if [ ! -e ${DEVLOOP} ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" && exit
#GOTO: END
else
    echo "Found loop device: ${DEVLOOP} !"
    #TODO: look at partitions, maybe we needed to wipe.
    #      fdisk -l ${DEVLOOP} || wipefs -a ${DEVLOOP}
fi

#Create Partitions (if we didnt error and exit by now )
#sfdisk - programmatic partition script (WARNING, ALWAYS WIPE!)
sfdisk --wipe=always ${DEVLOOP} <<EEOF
#(very specific syntax, watch out for whitespace)
label: gpt
size= 50M, type= U, name="EFI"
#,50M,U,,
size= 150M, type= L, name="boot"
#,150M,L,,
size= , type= L, name="gentooROOT"
#,,V,,
EEOF
echo "Created disk image partitions: EFI (p1), boot (p2), gentooROOT (p3) !"


#Create Filesystems on each of these partitions
mkfs.vfat /dev/loop0p1 -n EFI -F32 -v
mkfs.ext4 /dev/loop0p2 -L boot
mkfs.ext4 /dev/loop0p3 -L gentooROOT
echo "Created filesystems with mkfs: (root/boot = ext4, EFI = fat32)"

echo "Complete! Finished making amazing disk image, partitions & filesystems! All done"
echo "To mount the root filesystem, Run:"
echo "  amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
