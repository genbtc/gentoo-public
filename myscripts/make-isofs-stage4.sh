#!/bin/sh
# created by genr8eofl @ gentoo - July 2, 2023 - GPL2
mkisofs -o gentoostage4.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -no-emul-boot -U -J -joliet-long -r -v -T gentoo-minimal.iso_build/
