#!/bin/sh
# script v0.1 - created by genr8eofl @ gentoo - July 8, 2023 - AGPL3

ISODIR="/mnt/borg/ISOs"                     #choose where the source ISO is
ISO="livegui-amd64-20230705T183202Z.iso"    #whatever ISO we want
imgsq="image.squashfs"  #CONSTANT           #(the image inside the ISO)
target=${ISO%.iso}                          #target directory to extract to
sqfs="${ISO}.squashfs"

#start extracting squashfs file from ISO (7z required to extract):
# 7z x /mnt/borg/ISOs/livegui-amd64-20230705T183202Z.iso image.squashfs
# mv image.squashfs livegui-amd64-20230705T183202Z.iso.squashfs
# unsquashfs -d livegui-amd64-20230705T183202Z livegui-amd64-20230705T183202Z.iso.squashfs

7z x ${ISODIR}/${ISO} ${imgsq}

mv image.squashfs  ${sqfs}

unsquashfs -d ${sqfs%.iso.squashfs}  ${sqfs}

##no #gentoo="/mnt/gentoo"
##no #mount -t squashfs -o rw ${sqfs} ${gentoo}
##no #grep ${sqfs} #  < #   /mnt/crucialp1/livegui-amd64-20230705T183202Z.iso.squashfs on /mnt/gentoo type squashfs (ro,relatime,seclabel)

##handle DNS
#cp /etc/resolv.conf /mnt/gentoo/etc/
#cp /etc/resolv.conf  livegui-amd64-20230705T183202Z/etc
cp /etc/resolv.conf ${target}/etc

##handle make.conf
#mv /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf.dist
#cp gentoo-livegui-amd64-20230604T170201Z-etc-portage-make.conf /mnt/crucialp1/livegui-amd64-20230705T183202Z/etc/portage/make.conf

#Selinux relabeling from outside even when guest chroot is not selinux enabled
#setfiles -r /mnt/crucialp1/livegui-amd64-20230705T183202Z/ /etc/selinux/targeted/contexts/files/file_contexts /mnt/crucialp1/livegui-amd64-20230705T183202Z/{*}

##bind repos tree, enter chroot, emerge stuff
#mount --bind /var/db/repos/ var/db/repos/
#gentoo-chroot $target
#emerge-webrsync
#emerge -avuDU @world
