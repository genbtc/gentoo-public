#!/bin/sh
# grub-install --modules="${GRUB_MODULES}" --sbat ~/SBAT-gentoo.csv --bootloader-id="GRUB" --disable-shim-lock
GRUB_MODULES="
	tpm
	cpuid
	linuxefi
	all_video
	boot
	btrfs
	cat
	chain
	configfile
	echo
	efifwsetup
	efinet
	ext2
	fat
	font
	gettext
	gfxmenu
	gfxterm
	gfxterm_background
	gzio
	halt
	help
	hfsplus
	iso9660
	jpeg
	keystatus
	loadenv
	loopback
	linux
	ls
	lsefi
	lsefimmap
	lsefisystab
	lssal
	memdisk
	minicmd
	normal
	ntfs
	part_apple
	part_msdos
	part_gpt
	password_pbkdf2
	play
	png
	probe
	reboot
	regexp
	search
	search_fs_uuid
	search_fs_file
	search_label
	sleep
	smbios
	squash4
	test
	true
	video
	xfs
	zfs
	zfscrypt
	zfsinfo
"

grub-install --modules="${GRUB_MODULES}" --bootloader-id="GRUB" --disable-shim-lock \
 --sbat << EOF >>
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,3,Free Software Foundation,grub,2:2.06r9,https://www.gnu.org/software/grub/
grub.gentoo,1,Gentoo Linux,grub,2:2.06r9,https://packages.gentoo.org/sys-boot/grub/
EOF

