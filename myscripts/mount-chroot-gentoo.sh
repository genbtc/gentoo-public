#!/bin/bash
#@2023 genr8eofl @gentoo IRC - mount-chroot.sh for gentoo v0.12

mount --types proc /proc proc
mount --rbind /sys sys
mount --make-rslave sys
mount --rbind /dev dev
mount --make-rslave dev
mount --bind /run run
mount --make-slave run
#only for gentoo host:
mount --bind /var/db/repos var/db/repos
mount --make-slave /var/db/repos var/db/repos
