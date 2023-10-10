#!/bin/sh
# 2023 genr8eofl - simple Script to automate the download of the latest liveGUI v0.2
# Oct 10 - patched sed to use line 6 of signed timestamp latest.txt
osusrc="https://gentoo.osuosl.org/releases/amd64/autobuilds/"
latest="latest-livegui-amd64.txt"
echo "Downloading latest.txt..."
wget "${osusrc}/${latest}"
isodl=$(sed -n '6p' ${latest} | awk 'END{ print $1 }')
echo "Downloading latest = ${isodl} ..."
wget "${osusrc}/${isodl}"
