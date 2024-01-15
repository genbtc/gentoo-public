#!/bin/sh
# converts sqlite packages.db with table "packages" to output packages.csv, in current dir.
#  by genr8eofl @ gentoo @ 2024 - GPL3
NAME="packages"
sqlite3 -header -csv ${NAME}.db "select * from ${NAME};" > ${NAME}.csv
