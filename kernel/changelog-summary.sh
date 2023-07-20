#!/bin/sh
#  - changelog-summary.sh - version 1.0
#  by genr8eofl @ gentoo @ 2023 - AGPL3
# ./changelog-summary.sh 6.4.3
curl --silent https://cdn.kernel.org/pub/linux/kernel/v${1:0:1}.x/ChangeLog-${1} | grep -A 4 "^commit" | grep -E "(^    )";
