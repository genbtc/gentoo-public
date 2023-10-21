#!/bin/bash
# timestamps script, find-vardbpkg-BUILD_TIME.sh v0.4 -  by genr8eofl @ gentoo - copyright 2023 - AGPL3 License
# Description: Gather emerge BUILD_TIME installation Timestamp from vdb varPkgDB, compare with some older time, print results

if [[ $# -eq 0 ]]; then
	echo "Usage: # $(basename "$0")  1670008162  (timestamp cutoff to find OLDER packages)" && exit
fi

#shellcheck disable=2044 #(warning): For loops over find output are fragile. Use find -exec or a while read loop.
for x in $(find /var/db/pkg -name BUILD_TIME); do
	#read vdb file from disk
	read btime < "$x"
#shellcheck disable=2001 #(style): See if you can use ${variable//search/replace} instead.
	#chop cruft off path to get Category Package Version + Revision
	cpv=$(echo "$x" | sed 's|/var/db/pkg/||g; s|/BUILD_TIME||g;')
	#numerical compare timestamp, if X is earlier than first parameter $1, jle
	if (( "$btime" <= "$1" )); then
		echo "$btime" "$cpv";	#package is older. print out.
	fi
	#done
done

#OUTPUT:
#1689126989 acct-user/tss-0-r2
#1675319868 app-admin/checksec-2.6.0-r1
#1676041249 app-admin/doas-6.8.2

