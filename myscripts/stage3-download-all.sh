#!/bin/bash
# stage3-download-all.sh script v0.21 - genr8eofl @gentoo - Sept 28, 2023

#INPUT:
STAGE3_AMD64="stage3-amd64"
WEBDIR="https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-${STAGE3_AMD64}-hardened-openrc/"

#this was processed by the last script stage3-download-list.sh
#TODO: just call that script from here?
STAGESFILE="elinks-dump-gentoo-release-autobuilds-dirlisting-Sept2823-CONTENTS-stages.txt"

#RE-PROCESSING
STAGE3DLS=($(grep "${STAGE3_AMD64}.*tar\.xz" "${STAGESFILE}" | sed 's#\.CONTENTS\.gz##'))
#an array, for each
for stage in "${STAGE3DLS[@]}"; do
	echo "${stage}"
	wget --no-clobber "${WEBDIR}/${stage}"	#dont let default behavior redownload as duplicates if script is rerun
done

#OUTPUT Files:
#-rw-r--r--.  1 genr8eofl users      945063 Sep 24 13:53 stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz
#-rw-r--r--.  1 genr8eofl users      964745 Sep 24 15:26 stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz
#-rw-r--r--.  1 genr8eofl users      655550 Sep 25 03:37 stage3-amd64-hardened-selinux-openrc-20230924T163139Z.tar.xz

#DONE: this was the entire previous script
#    while read D; do wget $RITURL/$D; done < rit.edu.autobuild.list.txt
