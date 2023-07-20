#!/bin/sh
#Copyright 2022 Genr8EOFL, March 22, 2022 - April 22, 2022 ++ Dec 30, 2022
#Usage:
#OLD: # ./diffebuild.txt sys-libs/ncurses-6.3_p20221203-r2 sys-libs/ncurses-6.3_p20221203
#NEW: # ./diffebuild.txt sys-libs/ncurses 6.3_p20221203-r2 6.3_p20221203
set $1-$2 $1-$3

#$1 = sys-libs/ncurses-6.3_p20221203-r2
#newdir=/var/db/repos/gentoo/
newdir=$(portageq get_repo_path / gentoo)
declare -a newpkgq=($(qatom $1 -F "%{CATEGORY} %{PN} %{PV} %{PR}"))
newpkg2=$(echo $1 | cut -f2 -d'/')
newpkg=${newpkgq[0]}/${newpkgq[1]}/${newpkg2}.ebuild
#pkgpath=$(equery w $1)

#maybe/alternate way:
#newpkgcpv=$(portageq best_visible / $1)
#oldpkgcpv=$(portageq best_version / $2)
#echo ${newdir}${newpkgcpv} ${olddir}${oldpkgcpv}

#$2 = sys-libs/ncurses-6.3_p20221203-r1
olddir=/var/db/pkg/
declare -a oldpkg2=($(echo $2 | cut -f1,2 -d'/' --output-delimiter=' '))
oldpkg=${oldpkg2[0]}/${oldpkg2[1]}/${oldpkg2[1]}.ebuild

#Output:
alias diffy='diff -y --suppress-common-lines -W180'
diffy ${newdir}${newpkg} ${olddir}${oldpkg}

