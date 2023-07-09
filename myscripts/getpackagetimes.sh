#!/bin/bash
#script v0.1 by @genr8eofl copyright 2023 - AGPL3 License

rm PKGTIMES   #cleanup intermediate
#cd /var/db/pkg
find . -type f -name BUILD_TIME > BUILDTIMES
sed -i 's#\.\/##g' BUILDTIMES
while read -ra PKG; do
	read -ra epoch < $PKG;
    humandate=$(date --date=@${epoch})
    echo "$PKG  =  $epoch  =  \"$humandate\"" >> PKGTIMES
done < BUILDTIMES;
rm BUILDTIMES #cleanup intermediate
sed -i 's#/BUILD_TIME##g' PKGTIMES
sort -k3nr PKGTIMES | awk 'BEGIN { FS="  =  " } { print $3,$2,$1 }' > PKGTIMESsorted
cat PKGTIMESsorted
rm PKGTIMES   #cleanup intermediate
