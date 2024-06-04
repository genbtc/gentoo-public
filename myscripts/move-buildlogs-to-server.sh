#!/bin/bash
#script v0.11 by @genr8eofl copyright 2023 - AGPL3 License
# based on move-distfiles-to-server-0.1.sh
# fusermount -Z give root allow_other_user , first (other larger script checks this)
serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD"
logdir="/var/cache/buildlogs"
logdir=$(portageq envvar PORTAGE_LOGDIR)
dateNow=$(date +"%F_%H-%M-%S")
targetdir="${serverdir}/gentoo-buildlogs-${dateNow}"
mkdir -pv targetdir
#Need to use modified rsync with --tr replace mod because ':' in filename is invalid on SMB
rsync -rltDv ${logdir}/ ${targetdir}
echo "Done! copied buildlogs to server!"
pushd ${logdir}
echo "Done! delete buildlogs?"
rmdist=$(rm -Ir ${logdir}/*/*)
popd
