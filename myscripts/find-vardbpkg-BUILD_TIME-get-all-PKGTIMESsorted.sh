#!/bin/bash
# find-vardbpkg-BUILD_TIME-get-all-PKGTIMESsorted.sh v0.2 by @genr8eofl copyright 2023 - AGPL3 License
# Description: Get BUILD_TIME, human date, sorted list of packages and timestamps.

find /var/db/pkg -type f -name BUILD_TIME > BUILDTIMES.tmp
sed -i 's|/var/db/pkg/||g' BUILDTIMES.tmp
while read -ra PKG; do
	read -ra epoch < $PKG;
    humandate=$(date --date=@${epoch})
    echo "$PKG  =  $epoch  =  \"$humandate\"" >> PKGTIMES.tmp
done < BUILDTIMES.tmp;
rm BUILDTIMES.tmp #cleanup intermediate
sed -i 's|/BUILD_TIME||g' PKGTIMES.tmp
sort -k3nr PKGTIMES.tmp | awk 'BEGIN { FS="  =  " } { print $3,$2,$1 }' |& tee PKGTIMESsorted
rm PKGTIMES.tmp   #cleanup intermediate
#TODO: use tmp/scratch dir instead of .tmp files
