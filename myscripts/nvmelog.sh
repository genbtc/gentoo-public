#!/bin/sh
#script v1.0 by @genr8eofl copyright 2023 - AGPL3 License
LOGDIR=/root/nvmelogs/
DRIVES="nvme0n1" # nvme1n1" # nvme2n1"
#lrwxrwxrwx. 1 root root system_u:object_r:device_t 13 Feb 12 17:35 /dev/disk/by-id/nvme-INTEL_SSDPEKNU010TZ_BTKA10960CZB1P0B -> ../../nvme0n1
#This was 2
#lrwxrwxrwx. 1 root root system_u:object_r:device_t 13 Feb 12 17:35 /dev/disk/by-id/nvme-CT500P1SSD8_2014E29901EC -> ../../nvme1n1

today=$(date "+%Y-%m-%d")
for drive in $DRIVES; do
	nvme smart-log /dev/nvme0n1 > ${LOGDIR}nvme0n1-smartlog-${today}.log
	nvme smart-log /dev/nvme1n1 > ${LOGDIR}nvme2n1-smartlog-${today}.log
done
