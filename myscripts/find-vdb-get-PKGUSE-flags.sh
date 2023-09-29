#!/bin/bash
#script v0.31 by @genr8eofl copyright 2023 - AGPL3 License
echo "# This file was automatically generated on $(date +"%FT%H-%M-%S")"
echo "# a package.use file,  created by genr8eofl's findPKGUSE.sh script v0.31"

#start with correct portage vdb dir
vdb=$(portageq vdb_path / )
: ${vdb:=/var/db/pkg}
#create a FD with <(, find all PKGUSE's, loop through, print out metadata, sort
sort -h < <(
    #find all metadata files named PKGUSE, loop.
    for apkg in $(find ${vdb} -name PKGUSE); do
        cd $(dirname ${apkg})    #enter that directory
        echo ">="$(cat CATEGORY)"/"$(cat PF) $(cat PKGUSE)
    done
)
