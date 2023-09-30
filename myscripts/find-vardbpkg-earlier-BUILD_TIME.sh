#!/bin/bash
# timestamps script, find-vardbpkg-BUILD_TIME.sh v0.3 -  by genr8eofl @ gentoo - copyright 2023 - AGPL3 License
# Description: Gather BUILD_TIME installation emerge Timestamp from vdb varPkgDB

if [[ $# -eq 0 ]]; then
	echo "Usage: # $(basename "$0")  1670008162  (must provide a timestamp)" && exit
fi
#shellcheck disable=2044 #(warning): For loops over find output are fragile. Use find -exec or a while read loop.
for x in $(find /var/db/pkg -name BUILD_TIME); do
	btime=$(cat "$x");
#shellcheck disable=2001 #(style): See if you can use ${variable//search/replace} instead.
	cpv=$(echo "$x" | sed 's|/var/db/pkg/||g; s|/BUILD_TIME||g;');
#	cpv=$(echo "$f" | sed 's|/BUILD_TIME||g');
	#compare numeric timestamp, if X is earlier than first parameter $1, jle
	if (( "$btime" <= "$1" )); then
		echo "$btime" "$cpv";	#package is older.
	fi;
done

#OUTPUT:
#1689126989 acct-user/tss-0-r2
#1675319868 app-admin/checksec-2.6.0-r1
#1676041249 app-admin/doas-6.8.2

