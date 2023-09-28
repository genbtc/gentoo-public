#!/bin/sh
# 2023 genr8eofl - simple Script to automate the download of the latest liveGUI v0.11
osusrc="https://gentoo.osuosl.org/releases/amd64/autobuilds/"
latest="latest-livegui-amd64.txt"
echo "Downloading latest.txt..."
wget "${osusrc}/${latest}"
isodl=$(awk 'END{ print $1 }' ${latest})
echo "Downloading latest = ${isodl} ..."
wget "${osusrc}/${isodl}"
