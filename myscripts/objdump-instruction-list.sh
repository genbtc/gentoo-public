#!/bin/sh
#script v1.0 by @genr8eofl copyright 2023 - AGPL3 License

#pass path to binary to be scanned (first argv)
PROG="${1:-/usr/bin/ffmpeg}"

#Disassemble program into instructions
objdump -d "${PROG}" |
 cut -f3 |
 cut -d' ' -f1 |
 grep -v "Disassembly" |
 grep -v "00" |
 grep -v "${PROG}" |
 sed '/^$/d' |
 sort |
 uniq \
> /tmp/instructions2.txt

#Steps:
#cut by tabs, only keep 3rd field
#cut by spaces, only keep first word (found the instruction)
#grep out Disassembly
#grep out 0000000000003577217 addresses
#grep out PROG name itself
#clear out blank lines
#sort
#uniq
