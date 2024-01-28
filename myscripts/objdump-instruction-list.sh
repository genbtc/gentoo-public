#!/bin/sh
#script v1.1 by @genr8eofl copyright 2023 - AGPL3 License

#pass path to binary to be scanned (first argv)
PROG="${1:-/usr/bin/ffmpeg}"

objdump -M intel-mnemonic --disassemble --no-show-raw-insn "${PROG}" |
 cut -f2 |
 cut -d' ' -f1 |
 grep -v "Disassembly" |
 grep -v "00" |
 grep -v "${PROG}" |
 sed '/^$/d' |
 sort -u |
 tr '[:lower:]' '[:upper:]'

#Explanation of steps:

#Disassemble program into intel-mnemonic compatible instructions (less width/size operands messing with the names)
#cut by tabs, only keep 2nd field
#cut by spaces, only keep first word (found the instruction)
#grep out Disassembly
#grep out 0000000000003577217 addresses
#grep out PROG name itself
#delete blank lines
#sort --unique
#uppercase
#print to screen
