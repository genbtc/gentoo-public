#!/bin/bash
#2023 genr6eofl - @ gentoo - script v0.2 partitions the disk

DISKSIZE="8G"
DISKIMG="gentoo-amazing-1.dd"
DEVLOOP="/dev/loop0"

#make an 8 gigabyte file, give it some name, sparse.
truncate -s ${DISKSIZE} ${DISKIMG}

#selinux context needs to be file read/write/ioctl'ed by kernel_t
#sesearch -A -s kernel_t -c file -p write | grep read
chcon -t tmpfs_t ${DISKIMG}

#delete previous loop devices !!!
losetup -D

#create loop device
DEVLOOP=$(losetup --find --show ${DISKIMG})
if [ ! -e ${DEVLOOP} ]; then
    echo "Error. Failed to set up Loop Device or Loop Device not found. Exiting!" && exit
else
    echo "Found loop device: ${DEVLOOP} !"
    #look at partitions, maybe we needed to wipe.
    #fdisk -l ${DEVLOOP} || wipefs -a ${DEVLOOP}
fi

#sfdisk programmatic partition script
#very specific syntax
sfdisk --wipe=always ${DEVLOOP} <<EEOF
label: gpt
size= 50M, type= U, name="EFI"
#,50M,U,,
size= 150M, type= L, name="boot"
#,150M,L,,
size= , type= V, name="devLVMmap"
#,,V,,
EEOF
