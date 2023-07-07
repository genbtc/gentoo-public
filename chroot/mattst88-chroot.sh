#!/bin/sh
# 2023 gentoo - mattst88's chroot
#set -- /home/mattst88/.chroot

exec sudo unshare -m /bin/bash -c "
set -e

mkdir -p \
	'$1'/var/db/repos/gentoo \
	'$1'/var/cache/distfiles \
	'$1'/var/cache/binpkgs \
	'$1'/var/tmp/portage
touch '$1'/etc/resolv.conf

mount -t proc none '$1'/proc
mount --rbind /dev '$1'/dev
mount --rbind /sys '$1'/sys
mount --bind -o ro /etc/resolv.conf '$1'/etc/resolv.conf
mount -o ro /var/db/repos/sqfs/gentoo.sqfs '$1'/var/db/repos/gentoo
mount --bind /var/cache/distfiles '$1'/var/cache/distfiles
mount --bind /var/cache/binpkgs '$1'/var/cache/binpkgs
#mount -o size=16g,uid=portage,gid=portage,mode=0775 -t tmpfs tmpfs '$1'/var/tmp/portage

exec chroot '$1' /bin/bash -l
"
