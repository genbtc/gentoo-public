#!/bin/bash
#script v0.22 by @genr8eofl copyright 2023 - AGPL3 License
if ! pgrep -f allow_root ; then
    echo "Error. fusermount -Z should give root allow_other_user or allow_root , first" && exit
fi
echo "Found PID of server's fuse mount. Good." # Starting in 3 seconds..."
echo "move-binpkgs-to-server.sh - script v0.22 - by @genr8eofl, continuing in 3 seconds ..."
sleep 3
#-------------------------VARIABLES--------------------------------
#LocalDir
pkgdirb="/var/cache/binpkgs"
pkgdir="$(portageq pkgdir)"
if [[ $pkgdir != $pkgdirb ]] ; then
    echo "Your package dir does not match, expected: $pkgdirb"
    echo "Confirm bin pkgdir is correct: PKGDIR = $pkgdir"
fi
#-------------------------DIRECTORIES-------------------------------
serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD"
versionfile="gentoo-zen3-var-cache-binpkgs.version.txt"
echo "Reading saved incremental counter file (for directory naming): $verid"
read -a verid < ${serverdir}/${versionfile}
#TargetDir-#N(incremental)
targetdir="gentoo-zen3-var-cache-binpkgs-${verid}"
if [[ -w $serverdir/$targetdir ]] ; then
    echo "Found dir: ${targetdir} writeable, is this correct? Starting in 5 seconds..."
    ((verid++))
    sleep 5
else
    echo "We can't write to the blasted dir!" #  casually exit. dont make a scene."
    echo "Create it?! - Starting in 5 seconds..."
    sleep 5 && mkdir ${targetdir}
fi
#--------------------------COPY-----------------------------------
echo "Begin process of copying ALL binpkgs to server now!..."
rsync --progress -rltDv ${pkgdir}/  ${serverdir}/${targetdir}
echo "Done copying files to server!"
echo "Saving next dirname counter: ++ incremented  $verid  : in ${versionfile}"
echo $verid > ${serverdir}/${versionfile}
#--------------------------DELETE---------------------------------
pushd ${pkgdir} || exit
echo "Deleting ALL binpkgs locally in 10 seconds! ctrl+C to stop ..."
#10 second Countdown timer
for i in {10..1} ; do
    dashes=$(printf '%0.s-' $(seq 1 $i))
    echo "$i$dashes"
    sleep 1
done
echo "Deleting..."
a=$(rm -r -I ${pkgdir}/*)
#b=$(mkdir ${pkgdir})
#c=$(chown root:portage ${pkgdir})
echo "Done, Finished deleting all local binpkgs from ${pkgdir}!"
popd
