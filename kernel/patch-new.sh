#!/bin/bash
#genr8eofl @gentoo - copyleft 2021,2022,2023 - GPL2
# Check Kernel.org for New Patch and Changelog,
#  then Download and Patch linux-sources @ /usr/src/linux
# Usage:
#  in /usr/src/linux # ./patch-new.sh
# Deps: bash, grep, awk, wget, xz, patch, less, sed

function changelog() { grep -A 4 "^commit" "$1" | grep -E "(^    )"; }

#use of eval justified to import makefile vars
eval "$(awk -F' = ' '{print $1 "=" $2}' <(tail -n+2 Makefile | head -n3) )"
#current base version will be auto-determined
v=$VERSION p=$PATCHLEVEL s=$SUBLEVEL
echo "Kernel Version, currently = $v.$p.$s (local)"
##s1=${1-"`grep "SUBLEVEL" Makefile | head -1 | awk '{print $3}'`"} #(old way)
s1=$s            #sublevel1 is current local version
s2=$(( s1 + 1 )) #sublevel2 is next remote patch

URL="https://cdn.kernel.org/pub/linux/kernel/v${v}.x/"

function download() {
 echo "Downloading Patch..."
 ptf="patch-$v.$p.$s1-$s2"
 mkdir -p patches; pushd patches || die
 download1=$(wget "${URL}/incr/${ptf}.xz")
 if [ -f "${ptf}.xz" ]; then
  echo "Patch ${ptf}.xz found. Decompressing patch .XZ..."
  xz -d -T0 "${ptf}.xz"
  echo "Now Patching..."
  popd || die
  mkdir -p patched
  patch -p1 < patches/"$ptf" > patched/patched-"$s1-$s2".txt
  echo "Patch Complete! Log Saved @ ${PWD}/patched/patched-$s1-$s2.txt"
 else
  echo "Patch 404 not found, this means we're up to date. Bailing out!"
  exit
 fi
 mkdir -p changelogs; pushd changelogs || die
 echo "Downloading ChangeLog..."
 chlog="ChangeLog-$v.$p.$s2"
 download2=$(wget "${URL}/${chlog}")
 if [ -f "$chlog" ]; then
  echo "ChangeLog Summary Created!"
  changelog "$chlog" > "$chlog-summary.txt"
  echo "ChangeLog Saved! @ $(realpath ${chlog})"
  echo "ChangeLog is opening, q to quit..."
  less "$chlog-summary.txt"
 fi
 popd || die
}

#Patch wont apply cleanly and its struggling with my  custom ver string:

#ifdef you are me
sed -i 's/^EXTRAVERSION = -gentoo-hardened1/EXTRAVERSION =/' Makefile
#endif

download #run it, execute!

#ifdef you are me
sed -i 's/^EXTRAVERSION =/EXTRAVERSION = -gentoo-hardened1/' Makefile
#endif
