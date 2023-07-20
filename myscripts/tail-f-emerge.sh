cat /var/log/emerge.log | awk  '{ $1 = strftime("%m-%d-%Y %H:%M:%S",$1); print }' "$1" | less
