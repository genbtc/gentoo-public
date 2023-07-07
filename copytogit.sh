#!/bin/sh
#@2023 genr8eofl @gentoo IRC - copytogit.sh create this repo with updatedversions

cp -r /etc/portage/ etc/
rm -r ./etc/portage/savedconfig
mv etc/portage/binrepos.conf~ etc/portage/binrepos.conf
cp /etc/bash/bashrc etc/bash/bashrc
cp ~/myscripts/genr8-chroot.sh chroot/
cp -a ~/.bash_aliases ~/.bashrc ~/.config/htop/htoprc ~/.nanorc ~/.tmux.conf dotfiles/
cp /usr/src/linux/patch-new.sh kernel/
cp /etc/kernel/postinst.d/grub-manual-entry etc/kernel/postinst.d/
find /var/db/repos/myoverlay -name "*.ebuild" -exec cp {} ebuilds/ \;
cp -r /var/db/repos/myoverlay/profiles/ myoverlay/
cp -a /etc/imapolicy* IMA/policy/
cp -r /etc/local.d/ myscripts/etc/
SOMESCRIPTS=("gentoo-livegui-download.sh make-grub-rescue-stage4.sh	make-isofs-stage4.sh  mkinitramfs.sh ")
cp myscripts/move-binpkgs-to-server.sh myscripts/
cp myscripts/move-buildlogs-to-server.sh myscripts/
cp myscripts/move-distfiles-to-server.sh myscripts/
cp myscripts/iommu2.sh myscripts/
cp myscripts/sign-this-dir.sh myscripts/
cp myscripts/my-initramfs-script.init.sh myscripts/
cp myscripts/timestampscript.sh myscripts/
cp myscripts/mount-chroot.sh myscripts/
cp /mnt/crucialp1/make-grub-rescue-stage4.sh myscripts/
cp /mnt/crucialp1/make-isofs-stage4.sh myscripts/
cp /mnt/crucialp1/make-squashfs-stage4.sh myscripts/
#(perms/selinux)
chown genr8eofl: . -R
restorecon -RFv .
