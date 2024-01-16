#!/bin/bash
#2024 genr8eofl @ gentoo - make-partition-disk v0.34 - partitions the disk/disk-image
#Usage: # ./$0 [/dev/disk-or-image-filename($1)]
DISK="${1:-/dev/sda}"

#Create Partitions (if we didnt error and exit by now )
#sfdisk - programmatic partition script (WARNING, ALWAYS WIPE!)
sfdisk ${DISK} <<EEOF
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
mkfs.vfat ${DISK}1 -n EFI -F32 -v
mkfs.ext4 ${DISK}2 -L boot
mkfs.ext4 ${DISK}3 -L gentooROOT

echo "Created filesystems w/ mkfs: (EFI = fat32 , boot/root = ext4)"
echo
echo "Complete! Finished making amazing disk image, partitions & filesystems! All done."
echo "To mount the root filesystem, Run:"
echo "  amazing-mount-fs-partitions.sh ${DISKIMG}" && exit
