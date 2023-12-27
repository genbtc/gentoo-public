#!/bin/bash
#find-suid.sh script v0.1 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution
#description: finds all SUID(4) & GUID(2) files and saves a list to current dir.
find / -xdev -type f \( -perm -004000 -o -perm -002000 \) -exec ls -lg {} \; 2>/dev/null | tee -a suidfiles.txt
