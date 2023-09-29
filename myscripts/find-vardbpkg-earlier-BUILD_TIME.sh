#!/bin/bash
#@genr8eofl @gentoo 2023-01-04 - timestampscript, find-vardbpkg-BUILD_TIME.sh
# Description: Gather BUILD_TIME installation emerge Timestamp from vdb varPkgDB
# Usage: # ./find-vardbpkg-earlier-BUILD_TIME.sh  1660008162

for x in $(find /var/db/pkg -name BUILD_TIME); do
	q=$(echo $x | sed 's|/var/db/pkg/||g');
	q=$(echo $q | sed 's|/BUILD_TIME||g');
	t=$(cat $x);
	#compare numeric timestamp, if X earlier than $1, jle
	if (( $t <= $1 )); then
		echo $t $q;	#package is older.
	fi;
done
