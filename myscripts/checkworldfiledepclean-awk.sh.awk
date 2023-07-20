#!/bin/sh
# genr8eofl Nov 16 2021 + Feb 5 2023 + July 20, 2023
#checkworldfiledepclean-awk.sh.awk script v0.21 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution

awk '{
 if (index($0,"checking")==1) {
    a[NR]=$0; b[$2]=NR;
    if (index(a[NR-1],"checking")==1) {
        print $2;
    }
 }
}' /tmp/checking2
