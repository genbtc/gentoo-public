#!/bin/sh
#2023 genr8eofl - @ gentoo - script v0.1 locates any executable stacks
if [ $(id -u) != 0 ]; then
    echo "You're not root, many proc files will be inaccessible"
fi
find /proc -name maps -exec grep -rl '^+.*rwx.*\[stack\]' {} \;
