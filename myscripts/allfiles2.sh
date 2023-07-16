#!/bin/bash
#Part 1a - get list of installed package atoms (=category/package-version)
cpvfile="portage-cpv.txt"
equery -C -N list -F '=$cpv' '*' | egrep "^=" > $cpvfile
#Part 1b - get list of files provided by all packages
allfiles="portage-allfiles.txt"
for d in `cat $cpvfile`; do
   echo $d;  #show some progress @ stdout
   equery -C files $d >> ${allfiles}.tmp
done
sort ${allfiles}.tmp | uniq > $allfiles
rm ${allfiles}.tmp

#Part 2 - get list of files on / rootfs (xdev skips other mounts/partitions)
diskfiles="rootfs-files.txt"
find / -xdev | sort | uniq > $diskfiles

#Part 3 - diff the two lists of files.
difffile="difference.txt"
diff $diskfiles $allfiles > $difffile
