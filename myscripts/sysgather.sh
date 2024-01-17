#!/bin/sh
# Description: lsmod psaux dmesg cpuinfo string to file gatherer tool v0.5 
# Author: genr8eofl @ gentoo - Dec 2023 + Jan 2024

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
stringtofile "dmesg"
stringtofile "lsmod"

stringtofile2 "cat /proc/interrupts" "proc-interrupts"
stringtofile2 "cat /proc/cpuinfo" "proc-cpuinfo"
stringtofile "lscpu"

stringtofile "dmidecode"
stringtofile2 "i2cdetect -l" "i2cdetect-l"
stringtofile "lspci"
stringtofile2 "lspci -v" "lspci-v"
stringtofile "lsusb"
stringtofile2 "lsusb -v" "lsusb-v"

stringtofile "df"
stringtofile "du"
stringtofile "free"
stringtofile "mount"
stringtofile "swapon"
stringtofile2 "ps faux --headers" "ps-faux"

stringtofile2 "emerge --info" "emerge-info"
stringtofile2 "resolve-march-native"
stringtofile2 "cpuid2cpuflags"

stringtofile2 "nvme-cli smart-log /dev/root" "nvme-cli-smart-log-dev-root"
stringtofile2 "smartctl -a /dev/root" "smartctl"

stringtofile2 "ip l" "ip-l"
stringtofile2 "ip a" "ip-a"
stringtofile2 "ip r" "ip-r"


