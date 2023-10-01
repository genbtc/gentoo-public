#!/bin/bash
# genr8eofl Nov 16 2021 + Feb 5 2023 + July 20, 2023 + Oct 01 2023
#checkworldfiledepclean.sh script v0.3 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution
# query reverse deps, then check emerge -c to see if packages can be purged, and if they can, make a list.

#Color Codes:
RED="\033[01;31m"
YEL="\033[01;32m"
GRN="\033[01;33m"
BLU="\033[01;34m"
NOCLR="\033[00m"

checking="/tmp/checking"
removals="/tmp/qdependsFoundRemovish"
deselects="/tmp/deselect"
remains="/tmp/remains"
logofresults="/tmp/logofresults"
#cleanup intermediate
rm --force "$removals" "$deselects" "$checking" "$remains" "$logofresults"

#Part 1 - read in packages selected in portage world file
while read -ra pkg; do
    echo "checking" "$pkg"
    qdepends --quiet --query "$pkg"
	#check return code for 1 meaning no result = no deps
    if [ $? -eq 1 ]; then
        echo "$pkg" >> "${removals}"
    fi
	#this extra space is used as a seperator for the text blocks
    echo
#read world file and output to stdout and /tmp/checking file
done < /var/lib/portage/world | tee "$checking"

# or if was output to stdout by: > /tmp/checking | grep -v -e "^$"
# (grep skips empty lines)
# so then run other script:
./checkworldfiledepclean-awk.sh.awk $(grep -v -e "^$" "${removals}")

#Part 2 - run emerge -c to try to remove them, 0 equals purge, else keep
while read -ra pkg; do
    emerge --ignore-default-opts --pretend --quiet --depclean "$pkg" | grep '^Number to remove:     [1-9]'
    if [ $? -eq 0 ]; then
        echo -e "$RED$pkg$NOCLR can be ${GRN}De-Selected!$NOCLR"
        echo "$pkg" >> "${deselects}"
    else
		#>>> No packages selected for removal by depclean
        echo -e "$RED$pkg$NOCLR needs to ${BLU}Remain in World!$NOCLR"
        echo "$pkg" >> "${remains}"
    fi
done < "${removals}" | tee "$logofresults"
