#!/bin/bash
#scripts to parse portage output - beta version 2023 July 10
#v0-tirnanog script
#v0-tirnanog script modded by genr8eofl
#v2-genr8eofl script

#v0 (from tirnanog - thanks)
sed -nE 's/^\[(ebuild|binary)[^]]+\] ([^ ]+).*/\2/p' < <(emerge -qpuDU @world); wait $!
#v1 (does not grab lines not at top level (tree breaks these with preceding spaces))
sed -nE 's/^\[(ebuild|binary)[^]]+\] ([^ ]+).*/\2/p' < vulty-emerge-update-avuDU-July-10-2023.txt | sed 's/::gentoo//' | tee vulty-emerge-update-avuDU-July-10-2023-names.txt
#v2 (designed by genr8eofl
sed -nE 's/^\[(ebuild  rR|ebuild     U|binary)[^]]+\] (.*)::gentoo \[.*/\2/p' < vulty-emerge-update-avuDU-July-10-2023.txt
