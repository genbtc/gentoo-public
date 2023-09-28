#!/bin/sh
#script v1.0 by @genr8eofl copyright 2023 - AGPL3 License

cat /var/log/emerge.log | awk  '{ $1 = strftime("%m-%d-%Y %H:%M:%S",$1); print }' "$1" | less
