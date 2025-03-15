#!/bin/sh
# sqlite-query-use.sh - v0.11 -  by genr8eofl @ gentoo @ 2024 - GPL3
# first use Packages-to-Sqlite.py to make Packages.db from binhost Packages file
# Usage: ./sqlite-query-use.sh $1/Packages.db
db="${1:-Packages.db}"
sqlite3 -header -table $db "select CPV, USE from packages where CPV like '$1%';"
