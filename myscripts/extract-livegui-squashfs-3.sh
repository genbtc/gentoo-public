#!/bin/sh
# extract-livegui-squashfs-3.sh  - July 21, 2023 - AGPL3
# script v0.3 - created by genr8eofl @ gentoo
# DESCRIPTION: start extracting squashfs file from ISO
#              (7z required to extract ISO (app-arch/p7zip)
#              (unsquashfs required to extract squashfs (sys-fs/squashfs-tools)):

ISO="$1"                                    # argv[1] command line first param
ISOsqfs="${ISO}.squashfs"                   # rename generic name to ISO name(date).
outdir="${ISOsqfs%.iso.squashfs}"           # dir name without extension
target="${ISO%.iso}"                        # target directory to extract to
squashed="image.squashfs"        #CONSTANT  # (filename of the default image inside the original ISO)

# 7z x /mnt/borg/ISOs/livegui-amd64-20230716T164653Z.iso image.squashfs
# mv image.squashfs livegui-amd64-20230716T164653Z.iso.squashfs
# unsquashfs -d livegui-amd64-20230716T164653Z livegui-amd64-20230716T164653Z.iso.squashfs
7z "${ISO}"  ${squashed}
mv ${squashed} "${ISOsqfs}"
unsquashfs -d "${outdir}" "${target}"
