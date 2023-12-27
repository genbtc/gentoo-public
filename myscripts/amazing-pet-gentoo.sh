#!/bin/bash
# pet-gentoo.sh script v0.12 by @genr8eofl copyright 2023 - AGPL3 License

STAGE3="${1:-stage3-amd64-hardened-nomultilib-selinux-openrc}"
NUM=1
download-gentoo-iso-latest-dl_Spawns.sh "${STAGE3}"
echo
echo "********************1****************************"
echo
amazing-make-partition-truncate.sh "${STAGE3}_${NUM}.dd"
echo
echo "********************2****************************"
echo
amazing-mount-fs-partitions.sh "${STAGE3}_${NUM}.dd"
echo
echo "********************3****************************"
echo
echo "                 Go ! Chroot in:"
echo "    genr8-chroot /mnt/${STAGE3}_${NUM}"
genr8-chroot /mnt/"${STAGE3}_${NUM}"
echo "Unmounting. Loop device & Disk image remain."
