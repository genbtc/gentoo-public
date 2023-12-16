#!/bin/sh
#description: lsmod psaux dmesg cpuinfo gather -genr8eofl Feb2023
datenow=$(date +"%s")
pushd ~
mkdir -p sysgather-logs
cd sysgather-logs
mkdir $datenow
cd $datenow
stringtofile() {
    $($1 > $1)
    head -n-0 $1
}

stringtofile "lspci"
stringtofile "lsmod"
stringtofile "ps faux --headers"
stringtofile "dmesg"
stringtofile "cat /proc/cpuinfo"
stringtofile "dmidecode"
stringtofile "lspci -v"
stringtofile "lsusb"
stringtofile "lsusb -v"
stringtofile "cat /proc/interrupts"
stringtofile "df"

popd
