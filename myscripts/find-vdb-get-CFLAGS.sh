#!/bin/bash
#find-vdb-get-CFLAGS.sh script - v0.33 by genr8eofl @ gentoo - copyright 2023 - AGPL3 License
#Description: Outputs All installed packages and their user-adjusted USE flags
#OUTPUT: a file of All installed packages, the CFLAGS they were compiled with.
# OUTPUT will be printed to screen, pipe this script to a file if needed.

echo "# This file was automatically generated on $(date +"%FT%H-%M-%S")"
echo "# - created by genr8eofl's find-vdb-get-CFLAGS.sh script v0.33"

#start with correct portage vdb dir
vdb=$(portageq vdb_path / )
: "${vdb:=/var/db/pkg}"

#create a FD with <(, find all CFLAGS's, loop through, print out metadata, sort
sort -h < <(
    #find all metadata files named CFLAGS, loop.
    #shellcheck disable=2044  #(for loops over find output are fragile, better to use find -exec, or while read)
    for apkg in $(find "${vdb}" -name CFLAGS); do
        cd "$(dirname "${apkg}")" || exit  #enter that directory(or fail)
        echo "$(cat CATEGORY)/$(cat PF)" "$(cat CFLAGS)"
    done
)

#OUTPUT File:
#
#media-libs/dav1d-1.2.1 -march=native -O2
#app-editors/nano-7.2-r1 -march=znver3 -O3 -pipe
#net-analyzer/wireshark-4.0.8 -march=broadwell
#...

