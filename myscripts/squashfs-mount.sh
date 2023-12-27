#!/bin/bash
# squashfs-mount script v0.2 - @genr8eofl copyright 2023 - AGPL3 License
# Description: mounts the first squashfs in current dir

sqfs=(*.squashfs)
gentoo="/mnt/gentoo"
mount -t squashfs -o rw ${sqfs} ${gentoo}
