#!/bin/sh
# script v0.1 - created by genr8eofl @ gentoo - July 5, 2023 - AGPL3
mksquashfs /mnt/crucialp1/gentoo-livegui-amd64-20230604T170201Z /mnt/crucialp1/gentoo-livegui-amd64-20230604T170201Z.squashfs -wildcards -ef ~/exclude-squashfs.txt -b 1024K -comp xz -progress -processors 16 -Xdict-size 100% -noappend
