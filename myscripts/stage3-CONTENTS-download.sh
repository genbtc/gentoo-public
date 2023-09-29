#!/bin/bash
# stage3-CONTENTS-download.sh script v0.1 - genr8eofl @gentoo - Sept 28, 2023

WEBDIR="https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened-openrc/"
TODAY="Sept2823"
DIRLIST="elinks-dump-gentoo-release-autobuilds-dirlisting-${TODAY}"

#depend on elinks to convert HTML dir listing to formatted text
elinks --dump ${WEBDIR} > ${DIRLIST}.txt

#grab lines containing CONTENTS
CONTENTS="${DIRLIST}-grep-CONTENTS"
grep 'CONTENTS.gz' ${DIRLIST} > ${CONTENTS}.txt

#throw away everything else
AWKCONTENTS='${CONTENTS}-awk'
awk 'NF>=3 {print $3}' ${CONTENTS}.txt > ${AWKCONTENTS}.txt
#[31]livegui-amd64-20230924T163139Z.iso.CONTENTS.gz
#[41]stage3-amd64-desktop-openrc-20230924T163139Z.tar.xz.CONTENTS.gz
#[51]stage3-amd64-desktop-systemd-20230924T163139Z.tar.xz.CONTENTS.gz

#chop off leading [digits]
SEDCONTENTS='${AWKCONTENTS}-sed'
sed 's#^\[[[:digit:]]*\]##' ${AWKCONTENTS}.txt > ${SEDCONTENTS}.txt
