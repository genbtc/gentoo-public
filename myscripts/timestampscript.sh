#!/bin/bash
#@genr8eofl @gentoo 2023-01-04
# Descr: Gather emerge BUILD_TIME installation Timestamp from varPkgDB
# Usage: ./timestampscript.sh 1660008162 > /tmp/timestamp-temp
for x in $(find /var/db/pkg -name BUILD_TIME); do
	q=$(echo $x | sed 's|/var/db/pkg/||g');
	q=$(echo $q | sed 's|/BUILD_TIME||g');
	t=$(cat $x);
	if (( $t <= $1 )); then
		echo $t $q;
	fi;
done
# Step2: Feed it back into emerge
#TODO:
#FEATURES="-getbinpkg" emerge -uav1 --usepkg=n --selective=n \
# $(~/timestampscript 1660000000 | awk '{print "="$2}') \
# --exclude "$(awk '{system("qatom -F\"%{CATEGORY}/%{PN}\" " $2)}' /tmp/excludelist-temp | xargs)" \
# --exclude flaggie --exclude logclean --exclude "app-portage/*::mv"

