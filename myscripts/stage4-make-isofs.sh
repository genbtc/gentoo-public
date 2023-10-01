#!/bin/sh
# stage4-make-isofs.sh script v0.3 - created by genr8eofl @ gentoo - July 2-5, 2023 - AGPL3
if [[ $# -eq 0 ]]; then
    echo "Usage: # $(basename "$0") stage4outputname.iso /path/outputdir/" && exit
fi
#mkisofs -o gentoostage4.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -no-emul-boot -U -J -joliet-long -r -v -T gentoo-minimal.iso_build/
mkisofs -o "${1}" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -no-emul-boot -U -J -joliet-long -r -v -T "${2}"
