#!/bin/bash
# genr8eofl @2023 - gentoo - stage3-CONTENTS-parse-packagelist-ALL.sh script v0.3
#TODO: accept input piped on stdin also

#INPUT FILES:
#-rw-r--r--. 1 genr8eofl users 10464795 Sep 24 13:53 stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS
#-rw-r--r--. 1 genr8eofl users 10704766 Sep 24 15:26 stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz.CONTENTS
#INPUT:
#(does not work for admincd/minimal-installcd, only stage3)
# cat CONTENTS
# ...
#drwxr-xr-x  root/root           0 2023-09-24 17:52 ./var/db/pkg/
#drwxr-xr-x  root/root           0 2023-09-24 17:46 ./var/db/pkg/dev-libs/
#drwxr-xr-x  root/root           0 2023-09-24 17:40 ./var/db/pkg/dev-libs/mpc-1.3.1/			<--- we want this only.
#-rw-r--r--  root/root          11 2023-09-24 17:40 ./var/db/pkg/dev-libs/mpc-1.3.1/BUILD_TIME
# ...

#search for ALL stage3's in current dir.
CONTENTSFILES=($(command ls -1 ./stage3*CONTENTS))

#an array, for each, parse, write file.
for CONTENTS in "${CONTENTSFILES[@]}"; do
	#grab only var/db/pkg lines with a digit[0-9] and a slash/ at the end$
	grep 'var/db/pkg.*[0-9]/$' "${CONTENTS}" |
	 #print the 6th column containing only the pathname
	 awk '{print $6}' |
	  #delete any string components other than the actual CPV
	   # write to *-packagelist.txt files
	  sed 's#./var/db/pkg/##g; s#/$##g' > "${CONTENTS}"-packagelist.txt
done

echo "Finished! output files @ *-packagelist.txt"
echo "$PWD"
command ls -1 ./*-packagelist.txt
#OUTPUT FILES:
#-rw-r--r--. 1 genr8eofl users 12986 Sep 29 16:39 stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS-packagelist.txt
#-rw-r--r--. 1 genr8eofl users 13542 Sep 29 16:39 stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz.CONTENTS-packagelist.txt
#INSIDE:
#dev-libs/mpc-1.3.1
#app-portage/portage-utils-0.96.1
#app-portage/gemato-20.4
