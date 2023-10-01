#!/bin/sh
# view-emerge-log-humantimestamp.sh script v1.1 by @genr8eofl copyright 2023 - AGPL3 License
ELOG="/var/log/emerge.log"
awk '{ $1 = strftime("%m-%d-%Y %H:%M:%S",$1); print }' "${ELOG}" | less
