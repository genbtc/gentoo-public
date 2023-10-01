#!/bin/sh
# make-grub-rescue-stage4.sh script 0.3 - created by genr8eofl @ gentoo - July 2-5, 2023 - GPL2
if [[ $# -eq 0 ]]; then
    echo "Usage: # $(basename "$0") outputname.iso /path/outputdir/" && exit
fi
#example command:
#grub-mkrescue -iso-level 3 -R -o /mnt/crucialp1/gentoostage4grubimage.iso /mnt/crucialp1/gentoo-minimal.iso_build/
# HFS was causing file errors, disabled it through -- xorriso raw options
grub-mkrescue -iso-level 3 -R -o "${1}" "${2}" -- -hfsplus off
