#!/bin/sh
#description: lsmod psaux dmesg cpuinfo gather v0.41 -genr8eofl Dec 2023
datenow=$(date +"%s")
mkdir -p sysgather-logs
cd ~/sysgather-logs
mkdir $datenow
cd $datenow
stringtofile() {
    $($1 > $1)
    head -n-0 $1
}
stringtofile2() {
    $($1 > $2)
    head -n-0 $2
}
stringtofile "uptime"
stringtofile2 "uname -a" "uname-a"
stringtofile "lsmod"
stringtofile2 "ps faux --headers" "ps-faux"
stringtofile "dmesg"
stringtofile2 "cat /proc/cpuinfo" "proc-cpuinfo"
stringtofile "dmidecode"
stringtofile "lspci"
stringtofile2 "lspci -v" "lspci-v"
stringtofile "lsusb"
stringtofile2 "lsusb -v" "lsusb-v"
stringtofile2 "cat /proc/interrupts" "proc-interrupts"
stringtofile "df"
