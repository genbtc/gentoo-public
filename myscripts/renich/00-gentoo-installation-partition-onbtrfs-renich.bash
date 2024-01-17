#!/usr/bin/env bash

# WARNING!!
# This will obliterate all the data in your partition!! (not actually true, but act as if it was)
# Do NOT execute this script if you don't fully understand it!

# a few vars
amount_of_swap=$( free --si -g | grep Mem: | gawk '{ print $2 + 1}' )

# create directories
mkdir -p /mnt/gentoo

# create partitions
# I would add your amount of RAM + something (1 GB maybe?) to the swap partition (#3) instead of 9.
sgdisk -Z /dev/vda
sgdisk -o /dev/vda
sgdisk -n 1::+1024M -t 1:ef02 /dev/vda
sgdisk -n 2::+1G -t 2:8300 /dev/vda
sgdisk -n 3::+${amount_of_swap}G -t 3:8200 /dev/vda
sgdisk -n 4:: -t 4:8300 /dev/vda

# create filesystems
mkfs -t vfat -F 32 /dev/vda1
mkfs -t btrfs -L boot /dev/vda2
mkfs -t btrfs -L btrfsroot /dev/vda4
mkswap /dev/vda3

# mount
## root
mount /dev/vda4 /mnt/gentoo
mkdir -p /mnt/gentoo/boot

## boot
mount /dev/vda2 /mnt/gentoo/boot
mkdir -p /mnt/gentoo/boot/efi


# create subvols
cd /mnt/gentoo
btrfs subvol create root
btrfs subvol create home
btrfs subvol create srv
btrfs subvol create var

# unmount
cd ..
umount -l gentoo