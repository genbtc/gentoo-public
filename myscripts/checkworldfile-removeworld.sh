#!/bin/sh
# genr8eofl Jan 07, 2023 & July 20, 2023
#checkworldfile-removeworld.sh script v0.21 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution

for i in $(cat /var/lib/portage/world); do
	emerge --ignore-default-opts --depclean --pretend --verbose ${i} | grep "All selected packages" &> /dev/null || echo ${i} can probably be removed from world
done
