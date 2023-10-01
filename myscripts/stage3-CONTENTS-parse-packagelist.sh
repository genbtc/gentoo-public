#!/bin/bash
# genr8eofl @2023 - gentoo - stage3-CONTENTS-parse-packagelist.sh script v0.16

if [[ $# -eq 0 ]]; then
	echo "Usage: # $(basename "$0") CONTENTSFILE)" && exit
fi

#INPUT:
CONTENTSFILE="${1-:/home/genr8eofl/Downloads/stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS}"
#(does not work for admincd/minimal-installcd, only stage3)
#TODO: accept input piped on stdin also
# cat $CONTENTSFILE
# ...
#drwxr-xr-x  root/root           0 2023-09-24 17:52 ./var/db/pkg/
#drwxr-xr-x  root/root           0 2023-09-24 17:46 ./var/db/pkg/dev-libs/
#drwxr-xr-x  root/root           0 2023-09-24 17:40 ./var/db/pkg/dev-libs/mpc-1.3.1/			<--- we want this only.
#-rw-r--r--  root/root          11 2023-09-24 17:40 ./var/db/pkg/dev-libs/mpc-1.3.1/BUILD_TIME
# ...

#PROCESS:
#grab only var/db/pkg lines with a digit[0-9] and a slash/ at the ends$
grep 'var/db/pkg.*[0-9]/$' "${CONTENTSFILE}" |
#print the 6th column containing only the pathname
 awk '{print $6}' |
#delete any string components other than the actual CPV
  sed 's#./var/db/pkg/##g; s#/$##g'

#OUTPUT: (print to stdout)
#dev-libs/mpc-1.3.1
#app-portage/portage-utils-0.96.1
#app-portage/gemato-20.4
