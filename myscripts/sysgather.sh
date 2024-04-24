#!/bin/sh
# Description: lsmod psaux dmesg cpuinfo string to file gatherer tool v0.54
# Author: genr8eofl @ gentoo - Dec 2023 + Jan 2024 + Apr 2024 - LICENSE AGPL3

datenow=$(date +"%s")
mkdir -pv ~/sysgather-logs
cd ~/sysgather-logs
mkdir $datenow
cd $datenow
stringtofile() {
    if ! command -v $1 >/dev/null; then return 1; fi #command Not Found
    $($1 > $1)
    head -n-0 $1
}
stringtofile2() {
    if ! command -v $1 >/dev/null; then return 1; fi #command Not Found
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
stringtofile2 "cat /proc/iomem" "proc-iomem"
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

#IP
stringtofile2 "ip l" "ip-l"
stringtofile2 "ip a" "ip-a"
stringtofile2 "ip r" "ip-r"

#Gentoo
stringtofile2 "emerge --info" "emerge-info"
stringtofile "resolve-march-native"
stringtofile "cpuid2cpuflags"

#Disks (optional)
stringtofile2 "nvme smart-log /dev/root" "nvme-smart-log-devroot"
stringtofile2 "smartctl -a /dev/root" "smartctl-a-devroot"

#Clean up any failed files
find . -size 0 -delete
