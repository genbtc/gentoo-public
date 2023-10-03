#!/bin/bash
# pet-gentoo.sh script v0.1 by @genr8eofl copyright 2023 - AGPL3 License

STAGE="${1:-stage3-amd64-hardened-nomultilib-selinux-openrc}"
download-gentoo-iso-latest-dl_Spawns.sh "${STAGE}"
echo
echo "********************1****************************"
amazing-make-partition-truncate.sh "${STAGE}_1.dd"
echo
echo "********************2****************************"
amazing-mount-fs-partitions.sh "${STAGE}_1.dd"
echo
echo "********************3****************************"
echo "                 Go ! Chroot in:"
echo "    genr8-chroot /mnt/${STAGE}_1"
genr8-chroot /mnt/"${STAGE}_1"
