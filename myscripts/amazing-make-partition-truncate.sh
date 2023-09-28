#!/bin/bash
#2023 genr8eofl - @ gentoo - script v0.24 partitions the amazing disk

DISKSIZE="25G"
DISKIMG="stage3-gentoo-hardened-selinux-092423.dd"
#DEVLOOP="/dev/loop0"

#make an 25 GigaByte file, give it an amazing name, makes it sparse.
truncate --size=${DISKSIZE} ${DISKIMG}

#selinux context needs to be file read/write/ioctl'ed by kernel_t
#sesearch -A -s kernel_t -c file -p write | grep read
chcon -t tmpfs_t ${DISKIMG}

#WARNING #!!! delete previous loop devices !!!# WARNING#
losetup --detach-all

#create loop device
DEVLOOP=$(losetup --find --show --partscan ${DISKIMG})
if [ ! -e ${DEVLOOP} ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" && exit
else
    echo "Found loop device: ${DEVLOOP} !"
    #TODO: look at partitions, maybe we needed to wipe.
    #      fdisk -l ${DEVLOOP} || wipefs -a ${DEVLOOP}
fi

#sfdisk - programmatic partition script (WARNING: INCLUDING WIPE!)
sfdisk \
    --wipe=always ${DEVLOOP} <<EEOF
#(very specific syntax watch out whitespace)
label: gpt
size= 50M, type= U, name="EFI"
#,50M,U,,
size= 150M, type= L, name="boot"
#,150M,L,,
size= , type= L, name="gentooROOT"
#,,V,,
EEOF

#Create filesystem on this partition
mkfs.vfat /dev/loop0p1 -n EFI -F32 -v
mkfs.ext4 /dev/loop0p2 -L boot
mkfs.ext4 /dev/loop0p3 -L gentooROOT
