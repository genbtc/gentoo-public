#!/bin/bash
#.bash_aliases script by @genr8eofl copyright 2024 - AGPL3 License
alias mv='mv -i'
alias cp='cp -i'
alias l='ls -alZ --color'
alias ls='ls -alZ --color'
alias lt='ls -t | head'
alias less='less -R'
alias dmesg='dmesg -x --color=always'
alias diffy='diff -y --suppress-common-lines -W240'
alias fattr='getfattr --absolute-names -d -m.'
alias inode='find / -xdev -inum'
alias du='du -d1 -h -c'
alias rsync='rsync --progress -t'
alias ps='ps faux --headers'
alias listen='lsof -i -P -n | grep LISTEN'
alias netstat='netstat -4lpn'
alias stripcolors='sed "s/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g"'
alias cats='spc'

#define vars
COLOR1="\033[01;31m"
COLOR2="\033[01;32m"
COLOR3="\033[01;33m"
COLOR4="\033[01;34m"
ENDCOLOR="\033[00m"
export mydir="/home/genr8eofl/src/gentoo-public/"
export serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD"

#linux kernel
export KERNEL="/usr/src/linux"
alias diffk='${KERNEL}/scripts/diffconfig'
#Changelog = summary only, or summary + commit hash
function changelog() { grep -A 4 "^commit" "$1" | grep -E "(^    )"; }
function changelog2(){ grep -A 4 "^commit" "$1" | grep -E "(^    |^commit)"; }

#findfile
function ff(){ find "$(pwd)/" -type f -name '*'"$1"'*' ; }
#grepfile
function gf(){ grep -n "$1" . -R ; }

#works like sort | uniq, but no need to sort. uses AWK array in RAM to cache seen
uniqawk()  { awk '(a[$0]++==0)' "$1" ; }
#make alternating pairs with even/odd lines combined
# ie: a 3 line file AAA\n BBB\n CCCC\n would become:      AAA BBB\n BBB CCC\n
doubleawk() { awk '{ a[NR]=$1; if (NR>1) print a[NR-1],$1; }' "$1" ; }

# Portage aliases
source ~/.bash_aliases_portage
# Selinux aliases
source ~/.bash_aliases_selinux
# IMA aliases
source ~/.bash_aliases_ima

#super old script for disk stats
oldsuperprocdiskstats() {
  pushd /usr/local/src/aspersa-mirror || exit
  ./superprocdiskstats "$1"
  echo ; cat /tmp/procdiskstats | ./rel | ./align ; popd || exit ;
}
