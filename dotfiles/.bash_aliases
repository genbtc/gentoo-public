#!/bin/bash
#script by @genr8eofl copyright 2023 - AGPL3 License
alias mv='mv -i'
alias cp='cp -i'
alias l='ls -AlZ'
alias ls='ls -alZ --color'
alias less='less -R'
alias dmesg='dmesg -x --color=always | less -R'
alias diffy='diff -y --suppress-common-lines -W240'
alias fattr='getfattr --absolute-names -d -m.'
alias inode='find / -xdev -inum'
alias du='du -d1 -h -c'
alias rsync='rsync --progress -t'
alias ps='ps faux --headers'
alias listen='lsof -i -P -n | grep LISTEN'
alias netstat='netstat -4lpn'
alias stripcolors='sed "s/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g"'
export KERNEL="/usr/src/linux"
alias diffk='${KERNEL}/scripts/diffconfig'
#vars
export serverdir="/run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD"

uniqawk()  { awk '(a[$0]++==0)' "$1" ; }
doubleawk() { awk '{ a[NR]=$1; if (NR>1) print a[NR-1],$1; }' "$1" ; }

ff(){ find "$(pwd)/" -type f -name '*'"$1"'*' ; }
gf(){ grep -n "$1" . -R ; }

#alias imafindmissing="dmesg | grep 'IMA-signature-required' | awk '{print \$14}' | sort | uniq"
#alias imafixmissing="imafindmissing | cut -d\" -f2 | while read D; do evm_sign_cmd $D; done"
#alias evm_sign_cmd="evmctl sign -a sha512 -k /etc/keys/signing_key.priv -s"
#alias ima_hash_cmd="evmctl ima_hash -a sha512 -k /etc/keys/signing_key.priv -s"
#alias ima_fix2_cmd='evmctl2 ima_fix2 -s'
#alias ima_clear='evmctl2 ima_clear -s'
imacleanfix() { evmctl2 ima_clear -s "$@"; imafix2 -s "$@"; }
#rather use imafix2 program :
#(/usr/local/bin/imafix2 custom compiled from self-authored patch @/usr/local/src/ima-evm-utils/imafix2.c)

function changelog()  { grep -A 4 "^commit" "$1" | grep -E "(^    )"; }
function changelog2() { grep -A 4 "^commit" "$1" | grep -E "(^commit|^    )"; }

alias eq='equery'
eqd() { d=$(dirname "$(eq w "$1")"); echo "$d"; ls -at "$d"; }
alias ~~='ACCEPT_KEYWORDS="~amd64"'
ebuild2() { ebuild "$(equery which "$(echo "$1"| awk '{print $1}')")"  "$2" ; }
enano()   {  nano  "$(equery which "$1")" ; }
eclass() { portageq eclass_path / gentoo "$1" ; }
emergelog() { awk  '{$1= strftime("%m-%d-%Y %H:%M:%S",$1); print }' /var/log/emerge.log | less -R; }

efile() {
  echo "${@:2}" >> "$1";			#write all user args after #2, to $1 file
  tail -n1 "$1" "$1" | tail -n2;	#print confirmation filename and last line we output. (with "$1" twice trick + tail again),
}
useflags()     { efile "/etc/portage/package.use/flags" "$@" ; }
keywordflags() { efile "/etc/portage/package.accept_keywords/${1/'/'/-}" "$@" ; }
worldflags()   { efile "/var/lib/portage/world" "$@" ; }

fixelogbugz() {
  cd /var/cache/buildlogs/build || exit
  ls "$1"
  log=$(echo "$1" | sed 's/\.gz//g')
  zcat "$1" > "$log"
  touch -r "$1$log"
  ls "$log"*
  rm -i "$1"
  gzip "$log"
  ls "$log"*
}

#OLD: diffebuild.txt
#Usage:"$1"= sys-libs/ncurses-6.3_p20221203-r2
#       $2 = sys-libs/ncurses-6.3_p20221203
diffebuildold() {
	declare -a newpkgq=($(qatom "$1" -F "%{CATEGORY} %{PN} %{PV} %{PR}"))
	declare -a cutpkg=($(echo "$2" | cut -f1,2 -d'/' --output-delimiter=' '))
# 	newdir=/var/db/repos/gentoo
    newdir=$(portageq get_repo_path / gentoo)
#	oldvdb=/var/db/pkg
    oldvdb=$(portageq vdb_path / )
	newpkg2=$(echo "$1" | cut -f2 -d'/')
	newpkg="${newdir}/${newpkgq[0]}/${newpkgq[1]}/${newpkg2}.ebuild"
	oldpkg="${oldvdb}/${cutpkg[0]}/${cutpkg[1]}/${cutpkg[1]}.ebuild"
	#Output:
	diffy "${newpkg}" "${oldpkg}"
}

ediff() { diffebuild "$@" ; }
#Usage:"$1"= sys-libs/ncurses-6.3_p20221203-r2
diffebuild() {
    declare -a pkgq=($(qatom "$1" -F "%{CATEGORY} %{PN} %{PV} %{PR}"))
    declare -a cutpkg=($(echo "$1" | cut -f1,2 -d'/' --output-delimiter=' '))
    newdir=$(portageq get_repo_path / gentoo)
    : ${newdir:=/var/db/repos/gentoo}
    oldvdb=$(portageq vdb_path / )
    : ${oldvdb:=/var/db/pkg}
    newpkg="${newdir}/${pkgq[0]}/${pkgq[1]}/${cutpkg[1]}.ebuild"
    oldpkg="${oldvdb}/${pkgq[0]}/${pkgq[1]}-${pkgq[2]}*/${pkgq[1]}-${pkgq[2]}*.ebuild" #wildcard %PR -r1
    #Output:           #(unquoted to do * expansion) ^^                     ^^
    diffy "${newpkg}" ${oldpkg}
}

#-SELINUX->
#FIXED?TODO make work for multiple files / FIX: Double Quoted everything
chownse() { chown genr8eofl: "$@"; chcon -v -u user_u "$@"; }
sechown() { chown genr8eofl: "$@"; chcon -v -u user_u "$@"; }

semakefile() { make -f /usr/share/selinux/strict/include/Makefile "$@" || return 3; }
semakemod() {
  pp=$(echo "${1//.te/.pp}")
  if [[ $(semakefile "$pp") ]] ; then
    cp -bvf "$pp" ../modules/
    restorecon -RFv ../modules/
    semodule -i ../modules/"$pp"
  else
    echo -e "${COLOR4}ERROR $?:${ENDCOLOR} There was an error with ${1} inside semakemod"
    return 9
  fi
}

COLOR1="\033[01;31m"
COLOR2="\033[01;32m"
COLOR3="\033[01;33m"
COLOR4="\033[01;34m"
ENDCOLOR="\033[00m"
secheckmods() {
 for D in *.te; do
  pp=$(echo "${D//.te/.pp}")
  if [[ -e "${pp}" ]]; then
   if semakefile "$pp" ; then
    newsum=$(sha512sum "$pp" | awk '{print $1}')
	oldsum=$(sha512sum ../modules/"$pp" | awk '{print $1}')
    if [[ "${oldsum}" != "${newsum}" ]]; then
  	  echo "   ${pp} CHANGED old=${oldsum}"
      echo -e "[^]${COLOR4}${pp} CHANGED${ENDCOLOR} new=${newsum}"
	  semakemod "${D}"
    else
      echo -e "[ ]${COLOR2}${pp} identical, ${ENDCOLOR} no need to rebuild, skipped."
	fi
   else
    echo -e "${COLOR4}ERROR $?:${ENDCOLOR} There was an error processing ${D} with semakefile. Does it exist?"
   fi
  else
    echo -e "${COLOR3}WARNING $?: ${pp} file does not exist! remaking now... ${ENDCOLOR}"
	semakemod "${D}"
  fi
  echo
 done
}

pp2cil() { /usr/libexec/selinux/hll/pp "$@" ; }

aud2te(){ tail -n "$1" "$2" | audit2why -eR >> "$2" ; nano +-1 "$2" ; }

sedupecheck() {
  if [[ $(semodule -r "$1") ]]; then
    cat "$1".te | audit2why \
	 | tee /tmp/sedupes-"$1" | less;
    semodule -i ../modules/"$1".pp
  else
	echo "Error: The module cannot be unloaded safely. check my circular deps?"
  fi
}
setypegrep() {
  grep "^allow\|dontaudit\|auditallow" "$1"\
   | awk '{print $2"\n"$3}' | sed 's/\;//' \
    | cut -d':' -f1 | uniqawk | grep -v "self" \
     | awk '{print "    type " $1;}' \
  | tee /tmp/setypes-"$1" | more ;
}	#pattern deficiency, misses interfaces(type_t) and type_t { com bin at io ns }#
	# doesnt check if they're valid, gets weird words.

serestoremime() {
    sed -e 's#HOME_DIR/\\#/home/genr8eofl/#' /etc/selinux/strict/policy/mime-icon-cache.fc | grep -v "^#\|.*?" | cut -d' ' -f1 | xargs restorecon -RFv
}

oldsuperprocdiskstats() {
  pushd /usr/local/src/aspersa-mirror || exit
  ./superprocdiskstats "$1"
  echo ; cat /tmp/procdiskstats | ./rel | ./align ; popd || exit ;
}
