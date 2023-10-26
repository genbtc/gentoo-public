#!/bin/bash
#script v0.3 by @genr8eofl copyright 2023 - AGPL3 License
if ! pgrep -f 'fuse.*allow_root' ; then
    echo "Error. fusermount -Z should give root allow_other_user or allow_root for SMB first" && exit
fi
echo "Found PID of server's fuse mount from userspace. Good. Continuing..."
echo "move-binpkgs-to-server.sh - script v0.3 - by @genr8eofl, Starting in 2 seconds ..."
sleep 2
#-------------------------VARIABLES--------------------------------
#LocalDir
pkgdirb="/var/cache/binpkgs"
pkgdir="$(portageq pkgdir)"
if [[ $pkgdir != $pkgdirb ]] ; then
    echo "Your package dir does not match, expected: $pkgdirb"
    echo "Confirm bin pkgdir is correct: PKGDIR = $pkgdir"
fi
#-------------------------DIRECTORIES-------------------------------
serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD/"
versionfile="gentoo-zen3-var-cache-binpkgs.version.txt"
read -a verid < ${serverdir}/${versionfile}
echo "Reading saved incremental counter file (for directory naming): $verid"
((verid++))
#TargetDir-#N(incremental)
targetdir="gentoo-zen3-var-cache-binpkgs-00/gentoo-zen3-var-cache-binpkgs-${verid}"
finaldir="$serverdir/$targetdir"
if [[ -w $finaldir ]] ; then
    echo "Found dir: ${targetdir} to write to. Correct? Starting in 5 seconds..."
elif [[ ! -e $finaldir ]] ; then
    echo "The next incremental dir doesnt exist! : $finaldir"
    echo "Create the dir? - Starting in 5 seconds..."
else
    echo "We can't write to the blasted dir! "
    echo "Exit quietly. Get your stuff together." && exit 1
fi
sleep 5
mkdir -p $finaldir
#--------------------------COPY-----------------------------------
echo "Begin process of copying ALL binpkgs to server with rsync now!..."
rsync --progress -rltDv ${pkgdir}/  $finaldir
echo "Done copying binpkgs to server!"
#--------------------------DELETE---------------------------------
pushd ${pkgdir} || exit
echo "Deleting ALL binpkgs locally in 10 seconds! Ctrl+C to stop ..."
#10 second Countdown timer
for i in {10..1} ; do
    dashes=$(printf '%0.s-' $(seq 1 $i))
    echo "$i$dashes"
    sleep 1
done
echo "Deleting all files..."
a=$(rm -r -I ${pkgdir}/*)
echo "Done, Finished deleting all local binpkgs from ${pkgdir}!"
popd
#------------------------Increment Counter--------------------------------
echo "Saving incremental dirname counter:  $verid : in ${versionfile}"
echo $verid > ${serverdir}/${versionfile}
