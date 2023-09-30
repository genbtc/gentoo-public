#!/bin/sh
#2023 genr8eofl squashfs-mount script v0.1 @gentoo

sqfs=($(/bin/ls *.squashfs))
gentoo="/mnt/gentoo"
mount -t squashfs -o rw ${sqfs} ${gentoo}
