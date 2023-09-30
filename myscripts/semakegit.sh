#!/bin/bash
#@genr8eofl - gentoo (2023) July 24, Sept 30
# semakegit.sh v0.2 - LICENSE CCBYSA 4.0
#orig oneliner: genr8too /etc/selinux/strict/policy # THISPROJECTNAME="gitupdate"; cp -u *.{te,if,fc} ../git/; cd ../git; git add . ; git commit -m `date +"%F_%H-%M-%S"`\ "${THISPROJECTNAME}" ; cd ../policy

THISPROJECTNAME="$1" ;
yes "yes" | cp -u -v *.{te,if,fc} ../git/ ;
cd ../git ;
git add . ;
git commit -m `date +"%F_%H-%M-%S"`\ "${THISPROJECTNAME}" ;
cd ../policy ;
