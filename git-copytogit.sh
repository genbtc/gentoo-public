#!/bin/sh
# git-copytogit.sh - Originally @2023 genr8eofl @gentoo IRC - copytogit.sh - script v0.3, 2025
# Description: populate this repo with updated files from home

cd /home/genr8eofl/src/gentoo-public/
cp -apr /etc/portage/ etc/
rm -r ././etc/portage/savedconfig/
cp -ap /etc/bash/bashrc etc/bash/bashrc
cp -ap ~/.bash_aliases* ~/.bashrc ~/.config/htop/htoprc ~/.nanorc ~/.tmux.conf dotfiles/
cp -ap/usr/src/linux/patch-new.sh kernel/
cp -apr /etc/kernel etc/
#cp -ap/etc/kernel/postinst.d/grub-manual-entry etc/kernel/postinst.d/
find /var/db/repos/myoverlay -name "*.ebuild" -exec cp -ap {} ebuilds/ \;
rm -r myoverlay/
cp -apr /var/db/repos/myoverlay/ myoverlay/
cp -ap /etc/imapolicy* IMA/policy/
cp -apr /etc/local.d/ myscripts/etc/
#cp -ap~/myscripts/genr8-chroot.sh chroot/
#(perms/selinux)
#chownser . (notfound)
chown genr8eofl: . -R
restorecon -RFv .
#change timestamp to orig, should copy with -p
# find . -exec touch {} -r /somewhereElse/{} \;
