#!/bin/bash
# wtmp-format-boot.sh script v1.1 by @genr8eofl copyright 2023 - AGPL3 License
# Description: Interpret the "last log" to check for boot activity
# 			   Print your last boot or reboot dates in sequence

last -w --time-format=iso |
 grep "system boot" |
  sed 's/reboot   system boot  //g' |
   awk '{ cmd="date --date=" $2 " +\"%Y-%m-%d_%H:%M:%S\""; cmd |& getline q; close(cmd); print q " = " $1}'

# example output:
#2023-07-18_08:23:09 = 6.1.13-gentoo-dist+
#2023-07-11_20:09:56 = 5.10.186-gentoo-hardened1-ZEN3iGPU-DBG8
