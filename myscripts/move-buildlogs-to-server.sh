#!/bin/bash
#script v0.1 by @genr8eofl copyright 2023 - AGPL3 License
# based on move-distfiles-to-server-0.1.sh
# fusermount -Z give root allow_other_user , first (other larger script checks this)
serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD"
#logdir="/var/cache/buildlogs"
logdir=$(portageq envvar PORTAGE_LOGDIR)
dateNow=$(date +"%F_%H-%M-%S")
targetdir="${serverdir}/gentoo-buildlogs-${dateNow}"
mkdir -p targetdir
rsync -rltDv ${logdir}/ ${targetdir}
pushd ${logdir}
rmdist=$(rm -Ir ${logdir}/*/*)
popd
echo "Done! copied files to server!"
