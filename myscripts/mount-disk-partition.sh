#!/bin/bash
# mount-disk.sh script v0.8 by @genr8eofl copyright 2024 - AGPL3 License
# Description: mounts the partition dd! (adapted from mount-partition-disk.sh & amazing-mount-fs-partitions.sh)
# Note: this expects an image containing only 3 filesystem, or 3 partition, (ie /dev/sda3)
DISK="${1:-/dev/sda}"

#Create mount point under /mnt to hold rootfs /
TARGET="${2:-/mnt/gentoo/}"

if [ ! -e "${TARGET}" ]; then
    mkdir -p "${TARGET}"
    echo "Creating Root target dir: ${TARGET} !"
else
    echo "Found existing Root target dir: ${TARGET} ..."
fi

#mount disk!
mount ${DISK}3 $TARGET
echo "Mounted Root FS Partition on ${TARGET}"
mount ${DISK}2 $TARGET/boot
echo "Mounted Boot Partition on ${TARGET}/boot"
mount ${DISK}1 $TARGET/boot/efi
echo "Mounted EFI Partition on ${TARGET}/boot/efi"

#Complete!
echo "Done! now Run: genr8-chroot ${TARGET}"
cd "${TARGET}" || exit 1
