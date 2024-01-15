#!/bin/sh
# sqlite-query-use.sh - v0.1 -  by genr8eofl @ gentoo @ 2024 - GPL3
# first use Packages-to-Sqlite.py to make packages.db from Packages text file
sqlite3 -header -table packages.db "select CPV, USE from packages where CPV like '$1%';"

