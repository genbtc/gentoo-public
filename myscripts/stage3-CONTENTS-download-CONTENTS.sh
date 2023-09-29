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

