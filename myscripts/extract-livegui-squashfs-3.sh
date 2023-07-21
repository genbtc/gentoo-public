#!/bin/sh
# extract-livegui-squashfs-3.sh  - July 21, 2023 - AGPL3
# script v0.3 - created by genr8eofl @ gentoo
# DESCRIPTION: start extracting squashfs file from ISO
#              (7z required to extract ISO (app-arch/p7zip)
#              (unsquashfs required to extract squashfs (sys-fs/squashfs-tools)):

ISO="$1"                                    # input liveGUI ISO, argv[1] command line first param
ISOsqfs="${ISO}.squashfs"                   # rename default image name to livegui-isoname-202#date.squashfs
outdir="${ISO%.iso}"                        # target dir to extract to, (same)
default="image.squashfs"        #CONSTANT   # (filename of the default squash image inside the original ISO)

# 7z x /mnt/borg/ISOs/livegui-amd64-20230716T164653Z.iso image.squashfs
# mv image.squashfs livegui-amd64-20230716T164653Z.iso.squashfs
# unsquashfs -d livegui-amd64-20230716T164653Z livegui-amd64-20230716T164653Z.iso.squashfs
7z x "${ISO}"  ${default}
mv ${default} "${ISOsqfs}"
mkdir -p "${outdir}"
unsquashfs -d "${outdir}" "${ISOsqfs}"
