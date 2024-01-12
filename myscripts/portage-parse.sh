#!/bin/bash
#scripts to parse portage output - beta version v0.5 - 2023 July 10 + October 8 + October 17 2023 + Jan 6 2024
#v2 (designed by genr8eofl
#v3 take $1 on command line
#v4 add rebuild/Update missing some
#sed -nE 's/^\[(ebuild  rR|ebuild  r  U|ebuild     U|binary)[^]]+\] (.*)::gentoo \[.*/\2/p' < ${1}
#v5 shorten and simplify but get all builds
sed -nE 's/^\[(ebuild)[^]]+\] (.*)::gentoo .*/\2/p' < ${1}
#TODO chop :slot off
#TODO un-indent left margin
