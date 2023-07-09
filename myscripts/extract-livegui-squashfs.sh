#!/bin/sh
# script v0.1 - created by genr8eofl @ gentoo - July 8, 2023 - AGPL3

ISO="livegui-amd64-20230705T183202Z.iso"
target=${ISO%.iso}
# 7z x /mnt/borg/ISOs/livegui-amd64-20230705T183202Z.iso image.squashfs
# mv image.squashfs livegui-amd64-20230705T183202Z.iso.squashfs
# mv image.squashfs ${sqfs}
sqfs="livegui-amd64-20230705T183202Z.iso.squashfs"
gentoo="/mnt/gentoo"
#no #mount -t squashfs -o rw ${sqfs} ${gentoo}
#no #grep ${sqfs} #  < #   /mnt/crucialp1/livegui-amd64-20230705T183202Z.iso.squashfs on /mnt/gentoo type squashfs (ro,relatime,seclabel)
unsquashfs -d ${sqfs%.iso.squashfs}  $sqfs
#cp /etc/resolv.conf /mnt/gentoo/etc/
#cp /etc/resolv.conf  livegui-amd64-20230705T183202Z/etc

#bind mount /var/db/repos
#gentoo-chroot

#emerge-webrsync

#mv /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf.dist
#cp gentoo-livegui-amd64-20230604T170201Z-etc-portage-make.conf /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf

