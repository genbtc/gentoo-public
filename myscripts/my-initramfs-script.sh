#!/bin/busybox sh
# not !/bin/sh
#2021-04-03 genBTC custom initramFS = https://wiki.gentoo.org/wiki/Custom_Initramfs

rescue_shell() {
    export PATH=/sbin:/usr/sbin:/bin:/usr/bin
    #Install symlinks to all busybox applets first.
    /bin/busybox mkdir -p /usr/sbin /usr/bin /sbin /bin
    /bin/busybox --install -s

    echo "Something went wrong. Dropping to a shell."
    exec busybox sh
}

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc

mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
mount -t proc -o nodev,noexec,nosuid proc /proc
#mount -t devtmpfs -o nosuid,mode=0755 udev /dev
mount -t devtmpfs -o nosuid,mode=0755 none /dev

echo 	"This script just loads the nvme module," \
	"and mounts and boots the rootfs, nothing else!" ;

#Load nvme
if ! (modprobe nvme_core && modprobe nvme); then
        echo "Failed to load module: nvme!"
        rescue_shell
fi

#Parse cmdline
for x in $(cat /proc/cmdline); do
	case $x in
	root=*)
		ROOT=${x#root=}
		;;
	ro)
		roflag="-r"
	esac
done

# Locate /dev/ name for root='s label, and echo the result.
resolve_device() {
        DEV="$1"

        case "$DEV" in
        LABEL=* | UUID=* | PARTLABEL=* | PARTUUID=*)
                DEV="$(/sbin/blkid -l -t "$DEV" -o device)" || return 1
                ;;
        esac
        [ -e "$DEV" ] && echo "$DEV"
}
rootmnt=/mnt/root
#NOTE: Busybox versions of BlkID and FindFS only works with UUID or LABEL.
echo "Trying to mount, via resolved root= (PARTLABEL/PARTUUID) parameter ..."
if real_dev=$(resolve_device "${ROOT}"); then
        echo "Detected root partition as: " ${real_dev}
        if ! mount "${roflag}" -t ext4 "${real_dev}" "${rootmnt?}"; then
                echo "Failed to mount: root!"
                rescue_shell
        fi
else
	#HARDCODED MOUNT:
	echo "Trying to mount, (UUID/LABEL) hardcoded ..."
	mount -o ro $(findfs UUID=38ec5352-857c-4566-9d53-057a0846bff3) ${rootmnt}
	mount -o ro $(findfs LABEL=gentoo) ${rootmnt}
fi

#Cleanup
umount /proc
umount /sys
umount /dev

#Boot Root
init=/sbin/init
exec switch_root ${rootmnt} ${init}
