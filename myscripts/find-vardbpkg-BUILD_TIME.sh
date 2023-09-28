#!/bin/bash
#@genr8eofl @gentoo 2023-01-04 - timestampscript, find-vardbpkg-BUILD_TIME.sh
# Description: Gather emerge BUILD_TIME installation Timestamp from varPkgDB
# Usage: # ./find-vardbpkg-BUILD_TIME.sh 1660008162 > /tmp/timestamp-temp

for x in $(find /var/db/pkg -name BUILD_TIME); do
	q=$(echo $x | sed 's|/var/db/pkg/||g');
	q=$(echo $q | sed 's|/BUILD_TIME||g');
	t=$(cat $x);
	if (( $t <= $1 )); then
		echo $t $q;
	fi;
done
