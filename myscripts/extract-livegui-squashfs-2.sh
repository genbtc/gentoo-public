#!/bin/sh
# script v0.2 - created by genr8eofl @ gentoo - July 8-18, 2023 - AGPL3
ISODIR="/mnt/borg/ISOs"                     #choose where the source ISO is
ISO="livegui-amd64-20230716T164653Z.iso"    #whatever ISO we want
imgsq="image.squashfs"  #CONSTANT           #(the image inside the ISO)
isosqfs="${ISO}.squashfs"                   #rename generic name to ISO name(date).
target=${ISO%.iso}                          #target directory to extract to

#start extracting squashfs file from ISO (7z required to extract ISO, squashfs-tools required to extract squash):
# 7z x /mnt/borg/ISOs/livegui-amd64-20230716T164653Z.iso image.squashfs
# mv image.squashfs livegui-amd64-20230716T164653Z.iso.squashfs
# unsquashfs -d livegui-amd64-20230716T164653Z livegui-amd64-20230716T164653Z.iso.squashfs
7z ${ISODIR}/${ISO}  $imgsq
mv image.squashfs  ${isosqfs}
unsquashfs -d ${isosqfs%.iso.squashfs}  ${target}
