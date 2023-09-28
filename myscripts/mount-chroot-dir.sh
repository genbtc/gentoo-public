#!/bin/sh
#@2023 genr8eofl @gentoo IRC - mount-chroot-dir.sh

port="gentoo"
mount --types proc /proc /mnt/${port}/proc
mount --rbind /sys /mnt/${port}/sys
mount --make-rslave /mnt/${port}/sys
mount --rbind /dev /mnt/${port}/dev
mount --make-rslave /mnt/${port}/dev
mount --bind /run /mnt/${port}/run
mount --make-slave /mnt/${port}/run
