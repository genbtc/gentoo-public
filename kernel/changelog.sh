#!/bin/bash
function changelog() { grep -A 4 "^commit" $1 | grep -E "(^    )"; }

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]; then
    echo "Kernel Version (given on command line) = $1.$2.$3"
    v=$1 p=$2 s=$3
else
    eval `awk -F' = ' '{print $1 "=" $2}' <(tail -n+2 Makefile | head -n3)`
    echo "Kernel Version (parsed from Makefile, currently) = $VERSION.$PATCHLEVEL.$SUBLEVEL"
    v=$VERSION p=$PATCHLEVEL s=$SUBLEVEL
fi

function download() {
 echo "Downloading ChangeLog..."
 wget https://cdn.kernel.org/pub/linux/kernel/v$v.x/ChangeLog-$v.$p.$s
 if [ -f ChangeLog-$v.$p.$s ]; then
  echo "ChangeLog Summary Created!"
  changelog ChangeLog-$v.$p.$s > ChangeLog-$v.$p.$s-summary.txt
  less ChangeLog-$v.$p.$s-summary.txt
 fi
}
download
