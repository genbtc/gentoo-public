#mkinitramfs.sh script custom written by genBTC - 2021 + 2022
#LICENSE - Creative Commons 4.0, Attribution

#ChangeMe: (currentdir, hardcoded, current uname ver)
#KERNEL_VERSION=`basename $PWD`
#KERNEL_VERSION=5.4.129-gentoo-dist
KERNEL_VERSION=`uname -r`

STARTUPDIR=${PWD}
#Create dir Structure
mkdir initramfs
cd initramfs
mkdir bin lib lib64 mnt usr sbin
mkdir -p mnt/root

#This is the actual handmade "init" script ( http://dpaste.com/BXGH5KBNN )
cp ~/my-initramfs-script.init.sh "init"

#Create Modules Tree
mkdir -p lib/modules/$KERNEL_VERSION
cd lib/modules/$KERNEL_VERSION
#Copy module.blah metadata files
cp /lib/modules/$KERNEL_VERSION/modules.* .
#Copy NVME drivers
mkdir -p kernel/drivers/nvme/host
cd kernel/drivers/nvme/host
cp /lib/modules/$KERNEL_VERSION/kernel/drivers/nvme/host/nvme.ko .
cp /lib/modules/$KERNEL_VERSION/kernel/drivers/nvme/host/nvme-core.ko .

#lddtree comes from Pax-utils + requires dev-python/pyelftools : needed USE="python" flag, emerge pax-utils
#Some(a lot) of these are optional. purpose is to copy the program plus its ld shared libs
#lddtree --copy-to-tree . `which blkid`
#lddtree --copy-to-tree . `which vim`
#lddtree --copy-to-tree . `which busybox`
#lddtree --copy-to-tree . `which cat`
#lddtree --copy-to-tree . `which dmesg`
#lddtree --copy-to-tree . `which echo`
#lddtree --copy-to-tree . `which ls`
#lddtree --copy-to-tree . `which mkdir`
#lddtree --copy-to-tree . `which modprobe`
#lddtree --copy-to-tree . `which mount`
#lddtree --copy-to-tree . `which sh`
#lddtree --copy-to-tree . `which umount`
#lddtree --copy-to-tree . `which findfs`
#lddtree --copy-to-tree . `which poweroff`
#lddtree --copy-to-tree . `which reboot`
#lddtree --copy-to-tree . `which shutdown`
#lddtree --copy-to-tree . `which switch_root`
##lddtree --copy-to-tree . `which nano`

cd "${STARTUPDIR}/initramfs"
filestocopy=("busybox sh blkid findfs switch_root mount unmount modprobe mkdir ls echo cat dmesg poweroff reboot shutdown vim")
for fl in $filestocopy; do
	lddtree --copy-to-tree . `which $fl`
done

#Creates the actual archive
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /boot/initramfs-$KERNEL_VERSION.cpio.gz
