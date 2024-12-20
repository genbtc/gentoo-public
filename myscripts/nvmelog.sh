#!/bin/sh
# nvmelog.sh script v1.11 - by @genr8eofl - copyright 2023,2024 - AGPL3 License

LOGDIR=/root/nvmelogs/
DRIVES="nvme0n1 nvme1n1"
#lrwxrwxrwx. 1 root root system_u:object_r:device_t 13 Feb 12 17:35 /dev/disk/by-id/nvme-INTEL_SSDPEKNU010TZ_BTKA10960CZB1P0B -> ../../nvme0n1
#( since Feb 2023, was renamed from n2 to  n1)
#lrwxrwxrwx. 1 root root system_u:object_r:device_t 13 Feb 12 17:35 /dev/disk/by-id/nvme-CT500P1SSD8_2014E29901EC -> ../../nvme1n1

today=$(date "+%Y-%m-%d")

for drive in $DRIVES; do
	nvme list                    > ${LOGDIR}${drive}-smartlog-${today}.log
	nvme smart-log /dev/${drive} >> ${LOGDIR}${drive}-smartlog-${today}.log
	cat ${LOGDIR}${drive}-smartlog-${today}.log
done

#OUTPUT FILENAME:
#nvme0n1-smartlog-2023-09-26.log
#nvme1n1-smartlog-2023-09-27.log

