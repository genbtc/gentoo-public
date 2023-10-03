#!/bin/bash
# pet-gentoo.sh script v0.1 by @genr8eofl copyright 2023 - AGPL3 License

STAGE="stage3-amd64-hardened-nomultilib-selinux-openrc"
download-gentoo-iso-latest-dl_Spawns.sh "${STAGE}"
echo
echo "************************************************"
amazing-make-partition-truncate.sh "${STAGE}_1.dd"
echo
echo "************************************************"
amazing-mount-fs-partitions.sh "${STAGE}_1.dd"
echo
echo "************************************************"
#genr8-chroot /mnt/"${STAGE}_1"
