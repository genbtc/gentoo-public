#!/bin/bash
#find-vdb-get-PKGUSE-flags.sh script - v0.32 by genr8eofl @ gentoo - copyright 2023 - AGPL3 License
#Description: Outputs All installed packages and their user-adjusted USE flags

echo "# This file was automatically generated on $(date +"%FT%H-%M-%S")"
echo "# a package.use file,  created by genr8eofl's find-vdb-get-PKGUSE-flags.sh script v0.32"

#start with correct portage vdb dir
vdb=$(portageq vdb_path / )
: "${vdb:=/var/db/pkg}"

#create a FD with <(, find all PKGUSE's, loop through, print out metadata, sort
sort -h < <(
    #find all metadata files named PKGUSE, loop.
    for apkg in $(find "${vdb}" -name PKGUSE); do
        cd "$(dirname "${apkg}")" || exit   #enter that directory(or fail)
        echo ">=$(cat CATEGORY)/$(cat PF)" "$(cat PKGUSE)"
    done
)

#OUTPUT: All installed packages and their user-adjusted USE flags
#...
#media-libs/dav1d-1.2.1 xxhash
#app-editors/nano-7.2-r1 magic justify
#net-analyzer/wireshark-4.0.8 brotli smi
#...
