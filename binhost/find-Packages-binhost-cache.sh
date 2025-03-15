#!/bin/sh
# find-Packages-binhost-cache.sh - v0.1 - by genr8eofl @ gentoo @ 2025 - GPL3
# Find all cached remote binhost Packages files
binhost_cache="/var/cache/edb/binhost"
cd $binhost_cache
declare -a foundPackages=($(find . -name "Packages"))
#echo "${foundPackages[0]}"
#echo "${foundPackages[1]}"
for P in ${foundPackages[@]}; do
	echo $P;
done;
#execute script
cd $OLDPWD
