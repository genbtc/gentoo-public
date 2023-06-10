#!/bin/sh
# 2023 genr8eofl - Script to automate the download of the latest liveGUI
osusrc="https://gentoo.osuosl.org//releases/amd64/autobuilds/"
latest="latest-livegui-amd64.txt"
wget "${osusrc}/${latest}"
isodl=$(tail -n1 latest-livegui-amd64.txt | awk '{print $1}')
wget "${osusrc}/${isodl}"
