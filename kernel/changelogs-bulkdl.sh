#!/bin/bash
s1=0
s2=1
v=5
p=10
function changelog() { grep -A 4 "^commit" $1 | grep -E "(^    )"; }
function download() {
 pushd changelogs

 for i in {1..70}; do
 s1=$i
 s2=$(( $s1 + 1 ))
 echo "Downloading ChangeLog..."
 chf="ChangeLog-$v.$p.$s2"
 wget https://cdn.kernel.org/pub/linux/kernel/v$v.x/$chf
 if [ -f $chf ]; then
  echo "ChangeLog Summary Created!"
  changelog $chf > $chf-summary.txt
#  less $chf-summary.txt
 fi
 done
 popd
}
sed -i 's/^EXTRAVERSION = -gentoo/EXTRAVERSION =/' Makefile
download
sed -i 's/^EXTRAVERSION =/EXTRAVERSION = -gentoo/' Makefile

