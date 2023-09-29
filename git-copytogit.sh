#!/bin/sh
# @2023 genr8eofl @gentoo IRC - copytogit.sh - script v0.2
# Description: create this repo with updatedversions

cd /home/genr8eofl/src/gentoo-public/
cp -r /etc/portage/ etc/
rm -r ././etc/portage/savedconfig
mv etc/portage/binrepos.conf~ etc/portage/binrepos.conf
cp /etc/bash/bashrc etc/bash/bashrc
cp -a ~/.bash_aliases ~/.bashrc ~/.config/htop/htoprc ~/.nanorc ~/.tmux.conf dotfiles/
cp /usr/src/linux/patch-new.sh kernel/
cp -r /etc/kernel etc/
#cp /etc/kernel/postinst.d/grub-manual-entry etc/kernel/postinst.d/
find /var/db/repos/myoverlay -name "*.ebuild" -exec cp {} ebuilds/ \;
cp -r /var/db/repos/myoverlay/profiles/ myoverlay/
cp -a /etc/imapolicy* IMA/policy/
cp -r /etc/local.d/ myscripts/etc/
#cp ~/myscripts/genr8-chroot.sh chroot/
#(perms/selinux)
chown genr8eofl: . -R
restorecon -RFv .
#change timestamp to orig, should copy with -p
# find . -exec touch {} -r /somewhereElse/{} \;
