#!/bin/bash
# stage3-CONTENTS-download-list.sh script v0.16 - genr8eofl @gentoo - Sept 28, 2023

#INPUT:
STAGE3_AMD64="stage3-amd64"
WEBDIR="https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-${STAGE3_AMD64}-hardened-openrc/"

#depend on elinks to convert HTML dir listing to formatted text
TODAY="Sept2823"
DIRLIST="elinks-dump-gentoo-release-autobuilds-dirlisting-${TODAY}"
elinks --dump ${WEBDIR} > ${DIRLIST}.txt

#grab lines containing CONTENTS
GREPCONTENTS="${DIRLIST}-CONTENTS-grep"
grep 'CONTENTS.gz' ${DIRLIST}.txt > ${GREPCONTENTS}.tmp

#throw away bottom half thats not 3 columns wide
AWKCONTENTS="${GREPCONTENTS}-CONTENTS-awk"
awk 'NF>=3 {print $3}' ${GREPCONTENTS}.tmp > ${AWKCONTENTS}.tmp
#OUTPUT:
#[31]livegui-amd64-20230924T163139Z.iso.CONTENTS.gz
#[41]stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#[51]stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz.CONTENTS.gz

#chop off leading [digits]
sed -i 's#^\[[[:digit:]]*\]##' ${AWKCONTENTS}.tmp
#OUTPUT:
#admincd-amd64-20230924T163139Z.iso.CONTENTS.gz
#install-amd64-minimal-20230924T163139Z.iso.CONTENTS.gz
#livegui-amd64-20230924T163139Z.iso.CONTENTS.gz
#stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#stage3-amd64...

SEDCONTENTS="${DIRLIST}-CONTENTS-stage3s"
#filter admin/install/livegui/x32arch out
grep "^${STAGE3_AMD64}" ${AWKCONTENTS}.tmp |
# tee to stdout and to final result file
  tee ${SEDCONTENTS}.txt

#remove tmp files
rm ${GREPCONTENTS}.tmp ${AWKCONTENTS}.tmp

#90% of this script can be replaced by this snippet for url
#grep "${WEBDIR}${STAGE3_AMD64}.*CONTENTS.gz" ${DIRLIST}.txt | awk '{print $2}'
#TODO:Need to download them later
#DONE:see other script : stage3-CONTENTS-download-all.sh
