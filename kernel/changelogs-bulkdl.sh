#!/bin/bash
s1=0 #initialize
s2=1 #initialize
v=5  #Major KV
p=10 #Minor KV
function changelog() { grep -A 4 "^commit" $1 | grep -E "(^    )"; }
function download() {
 mkdir -p changelogs
 pushd changelogs

 for i in {1..199}; do
 s1=$i
 s2=$(( $s1 + 1 ))
 echo "Downloading ChangeLog $i..."
 chf="ChangeLog-$v.$p.$s2"
 wget https://cdn.kernel.org/pub/linux/kernel/v$v.x/$chf
 if [ -f $chf ]; then
  echo "$chf-summary Created!"
  changelog $chf > $chf-summary.txt
 fi
 done
 popd
}
sed -i 's/^EXTRAVERSION = -gentoo/EXTRAVERSION =/' Makefile
download
sed -i 's/^EXTRAVERSION =/EXTRAVERSION = -gentoo/' Makefile
