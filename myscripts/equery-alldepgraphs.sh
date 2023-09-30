#!/bin/bash
# equery-ALLDEPGRAPHS.sh script v0.2 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
# LICENSE - Creative Commons 4.0, Attribution
# Output:

#Part 1a - get list of installed package atoms (=category/package-version)
CPVFILE="portage-cpv.txt"
if [[ ! -e ${CPVFILE} ]]; then
#shellcheck disable=2016,2196 #(syntax is correct)
    equery -C -N list -F '=$cpv' '*' | grep -E "^=" > ${CPVFILE}
fi

#Part 1b - get dependency tree depgraph for all packages
echo "This takes about 5 minutes..."
ALLDEPGRAPHS="portage-ALLDEPGRAPHS.txt"
while read -r d; do
   echo "$d";  #show package progress @ stdout
   equery -C depgraph "$d" >> ${ALLDEPGRAPHS} #Warning, appends write
done < ${CPVFILE}

echo "Finished! The CPV installed package list File is @ ${CPVFILE}"
echo "Finished! The All DepGraphs txt File is @ ${ALLDEPGRAPHS}"
