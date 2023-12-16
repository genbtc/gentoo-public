#!/bin/sh
#description: lsmod psaux dmesg cpuinfo gather
datenow=$(date +"%s")
cd ~
mkdir sysgather-logs
cd sysgather-logs
mkdir $datenow
cd $datenow
stringtofile() {
    $($1 > $1)
    head -n-0 $1
}


a="lspci"
$($a > $a)
head -n-0 $a
b="lsmod"
$($b > $b)
head -n-0 $b
c="ps faux --headers"
$($c > $c)
head -n-0 $c
d="dmesg"
$($d > $d)
head -n-0 $d
e="cat /proc/cpuinfo"
$($e > $e)
head -n-0 $e
f="dmidecode"
$($f > $f)
head -n-0 $f
g="lspci -v"
$($g > $g)
head -n-0 $g
h="lsusb"
$($h > $h)
head -n-0 $h
i="lsusb -v"
$($i > $i)
head -n-0 $i
j="cat /proc/interrupts"
$($j > $j)
head -n-0 $j
k="df"
$($k > $k)
head -n-0 $k
