#!/bin/sh
# diffebuild.sh script 0.4 - created by genr8eofl @ gentoo - Feb 26, 2023 - GPL2

diffebuild() {
    declare -a newpkgq=($(qatom "$1" -F "%{CATEGORY} %{PN} %{PV} %{PR}"))
    declare -a cutpkg=($(echo "$2" | cut -f1,2 -d'/' --output-delimiter=' '))
#   newdir=/var/db/repos/gentoo
    newdir=$(portageq get_repo_path / gentoo)
#   oldvdb=/var/db/pkg
    oldvdb=$(portageq vdb_path / )
    newpkg2=$(echo "$1" | cut -f2 -d'/')
    newpkg="${newdir}/${newpkgq[0]}/${newpkgq[1]}/${newpkg2}.ebuild"
    oldpkg="${oldvdb}/${cutpkg[0]}/${cutpkg[1]}/${cutpkg[1]}.ebuild"
    #Output:
    diffy "${newpkg}" "${oldpkg}"
}

