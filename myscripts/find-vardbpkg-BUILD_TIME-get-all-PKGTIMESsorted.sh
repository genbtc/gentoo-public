#!/bin/bash
# find-vardbpkg-BUILD_TIME-get-all-PKGTIMESsorted.sh v0.3 by @genr8eofl copyright 2023 - AGPL3 License
# Description: Get BUILD_TIME, human date, sorted list of packages and timestamps.
#shellcheck disable=2128 #SC2128 (warning): Expanding an array without an index only gives the first elemen

PKGDIR="/var/db/pkg"
find $PKGDIR -type f -name BUILD_TIME | sed 's|/var/db/pkg/||g' > BUILDTIMES.tmp
while read -ra PKG; do
	read -ra epoch < "$PKGDIR/$PKG";
    humandate=$(date --date=@"$epoch")
    echo "$epoch   =   $humandate   =   $PKG" >> PKGTIMES.tmp
done < BUILDTIMES.tmp;
rm BUILDTIMES.tmp #cleanup intermediate
sed -i 's|/BUILD_TIME||g' PKGTIMES.tmp
#process it, sort it, and print it to stdout, and write to file
sort -k1nr PKGTIMES.tmp | awk 'BEGIN { FS="  =  " } { print $1,$2,$3 }' |& tee "PKGTIMESsorted.txt"
rm PKGTIMES.tmp   #cleanup intermediate
#TODO: use tmp/scratch dir instead of .tmp files
echo "Finished! File is @ PKGTIMESsorted.txt"

#OUTPUT:
# # cat PKGTIMESsorted.txt
#1696093428   Sat Sep 30 01:03:48 PM EDT 2023   dev-libs/libcgroup-3.0.0
#1696058321   Sat Sep 30 03:18:41 AM EDT 2023   app-arch/pacman-6.0.1
#1696058307   Sat Sep 30 03:18:27 AM EDT 2023   dev-util/perf-6.3
