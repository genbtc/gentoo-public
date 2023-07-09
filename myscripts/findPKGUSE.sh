#!/bin/bash
#script v0.2 by @genr8eofl copyright 2023 - AGPL3 License

#start with correct package db dir
oldvdb=$(portageq vdb_path / )
: ${oldvdb:=/var/db/pkg}
#enter that directory?
#pushd $oldvdb
#find all metadata files named PKGUSE
#pkguses=$(find . -name PKGUSE)
pkguses=($(find ${oldvdb} -name PKGUSE))
#strip out the ./ current directory from it.
#pkguses=${pkguses#.\/}
#pkguses=${pkguses#/var/db/pkg/}
#pkguses=${pkguses%PKGUSE}
#cat <<< $pkguses

#create a FD with <(, loop thru PKGUSE array, print out metadata, sort
sort -h < <(
for apkg in "${pkguses[@]}"; do
      cd $(dirname ${apkg})
      echo $(cat CATEGORY)"/"$(cat PF) $(cat PKGUSE)
done
)
