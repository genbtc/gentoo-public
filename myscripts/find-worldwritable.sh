#!/bin/bash
#find-worldwritable.sh script v0.1 - custom written by genBTC/genr8eofl @ gentoo, (c) 2021 - 2023
#LICENSE - Creative Commons 4.0, Attribution
#description: finds all world writable files and prints a list
find / -xdev -perm +o=w ! \( -type d -perm +o=t \) ! -type l -print
