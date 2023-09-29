#!/bin/bash
# stage3-CONTENTS-download-CONTENTS.sh script v0.2 - genr8eofl @gentoo - Sept 28, 2023

#INPUT:
STAGE3_AMD64="stage3-amd64"
WEBDIR="https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-${STAGE3_AMD64}-hardened-openrc/"

#this was processed by the last script stage3-CONTENTS-download-list.sh"
#TODO: just call the script from here
ELINKSDUMP="elinks-dump-gentoo-release-autobuilds-dirlisting-Sept2823.txt"

#RE-PROCESSING
STAGEDLS=($(grep "${WEBDIR}${STAGE3_AMD64}.*CONTENTS.gz" ${ELINKSDUMP}  | awk '{print $2}'))
#an array, for each, download.
for stage in ${STAGEDLS[@]}; do
	echo ${stage}
	wget --no-clobber ${stage}
done

#OUTPUT (the real files):
#-rw-r--r--.  1 genr8eofl users      945063 Sep 24 13:53 stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      964745 Sep 24 15:26 stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      962663 Sep 24 16:29 stage3-amd64-desktop-systemd-mergedusr-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      582238 Sep 25 03:11 stage3-amd64-hardened-nomultilib-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      652402 Sep 25 04:02 stage3-amd64-hardened-nomultilib-selinux-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      585052 Sep 25 01:39 stage3-amd64-hardened-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#-rw-r--r--.  1 genr8eofl users      655550 Sep 25 03:37 stage3-amd64-hardened-selinux-openrc-20230924T163139Z.tar.xz.CONTENTS.gz

gunzip -d ${STAGE3_AMD64}-*tar.xz.CONTENTS.gz
