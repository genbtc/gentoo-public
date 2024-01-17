#!/bin/sh
# Description: lsmod psaux dmesg cpuinfo string to file gatherer tool v0.51 
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

stringtofile "hostname"
stringtofile "uptime"
stringtofile2 "uname -a" "uname-a"
stringtofile "dmesg"
stringtofile "lsmod"
stringtofile2 "cat /proc/cmdline" "proc-cmdline"

stringtofile2 "cat /proc/interrupts" "proc-interrupts"
stringtofile2 "cat /proc/cpuinfo" "proc-cpuinfo"
stringtofile2 "grep 'Name\|Sysfs' /proc/bus/input/devices" "proc-bus-input-devices"
stringtofile "lscpu"

stringtofile "dmidecode"
stringtofile2 "i2cdetect -l" "i2cdetect-l"
stringtofile "lspci"
stringtofile2 "lspci -v" "lspci-v"
stringtofile "lsusb"
stringtofile2 "lsusb -v" "lsusb-v"

stringtofile "blkid"
stringtofile "lsblk"
stringtofile2 "lsblk -f" "lsblk-f"
stringtofile "df"
stringtofile "du"
stringtofile "free"
stringtofile "mount"
stringtofile "swapon"
stringtofile2 "ps faux --headers" "ps-faux"

stringtofile2 "cat /etc/os-release" "etc-os-release"

stringtofile2 "emerge --info" "emerge-info"
stringtofile "resolve-march-native"
stringtofile "cpuid2cpuflags"

stringtofile2 "nvme-cli smart-log /dev/root" "nvme-cli-smart-log-devroot"
stringtofile2 "smartctl -a /dev/root" "smartctl-a-devroot"

stringtofile2 "ip l" "ip-l"
stringtofile2 "ip a" "ip-a"
stringtofile2 "ip r" "ip-r"


