#!/bin/bash
# equery-alldepgraphs.sh script v0.1 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
# LICENSE - Creative Commons 4.0, Attribution

#Part 1a - get list of installed package atoms (=category/package-version)
cpvfile="portage-cpv.txt"
if [[ ! -e $cpvfile ]]; then
    equery -C -N list -F '=$cpv' '*' | egrep "^=" > $cpvfile
fi

#Part 1b - get list of files provided by all packages
alldepgraphs="portage-alldepgraphs.txt"
for d in `cat $cpvfile`; do
   echo $d;  #show some progress @ stdout
   equery -C depgraph $d >> ${alldepgraphs} #Warning, appends write
done

#sort ${alldepgraphs}.tmp | uniq > $alldepgraphs
#rm ${alldepgraphs}.tmp
#TODO:build more features
