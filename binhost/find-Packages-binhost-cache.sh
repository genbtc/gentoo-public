#!/bin/sh
# find-Packages-binhost-cache.sh - v0.12 - by genr8eofl @ gentoo @ 2025 - GPL3
# Find all cached remote binhost Packages files
binhost_cache="/var/cache/edb/binhost"
declare -a foundPackages=($(find $binhost_cache -name "Packages"))
for P in "${foundPackages[@]}"; do
	echo "$P found";
	#execute Sqlite conversion script
	db=$(python3 ./Packages-to-Sqlite.py "$P");
	sqlite3 -header -table "$db" "select CPV, USE from packages where CPV like '$1%';";
done;
