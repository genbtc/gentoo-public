#!/bin/bash
#script v0.1 by @genr8eofl copyright 2023 - AGPL3 License
# fusermount -Z give root allow_other_user , first
serverdir=${serverdir:-"/run/user/1000/gvfs/smb-share:server=10.2.2.1,share=raidz-4tbx4/DiskImages/LinuxDD"}
#distdir="/var/cache/distfiles"
distdir=$(portageq distdir)
gitsrc="git3-src"
rsync -rtlDv ${distdir}/ ${serverdir}/gentoo-distfiles-all --exclude=${gitsrc}
pushd ${distdir}
#TODO: check for this first then skip
movegit=$(mv ${gitsrc}/ ../)
rmdist=$(rm -I ${distdir}/*)
mvgit=$(mv ../${gitsrc}/ ./)
popd
echo "Done copying files to server!"
