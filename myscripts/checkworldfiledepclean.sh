#!/bin/bash
# genr8eofl Nov 16 2021 + Feb 5 2023 + July 20, 2023
#checkworldfiledepclean.sh script v0.21 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution

#Color Codes:
RED="\033[01;31m"
YEL="\033[01;32m"
GRN="\033[01;33m"
BLU="\033[01;34m"
NOCLR="\033[00m"

removals="/tmp/qdependsFoundRemovish"
deselects="/tmp/deselect"

#Part 1 - read in packages selected in portage world file
while 0 && read -ra pkg; do
    echo
    echo "checking" $pkg
    qdepends -q -Q $pkg
    if [ $? -eq 1 ]; then
        echo $pkg >> ${removals}
    fi
done < <(cat /var/lib/portage/world)

# or if was output to stdout by: > /tmp/checking | grep -v -e "^$"
# so then run other script:
# ./checkworldfiledepclean-awk.sh.awk

#Part 2 - run emerge -c to try to remove them, 0 equals purge, else keep
while read -ra pkg; do
    emerge --ignore-default-opts -p --quiet --depclean $pkg | grep '^Number to remove:     1'
    if [ $? -eq 0 ]; then
        echo -e $RED$pkg$NOCLR "can be ${GRN}De-Selected!$NOCLR"
        echo $pkg >> ${deselects}
    else
        echo $pkg "needs to stay in @world"
    fi
done < <(cat ${removals})
