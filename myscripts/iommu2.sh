#!/bin/bash
#script v1.1 by @genr8eofl copyright 2023 - AGPL3 License

red="\033[01;31m"
green="\033[01;32m"
yellow="\033[01;33m"
blue="\033[01;34m"
non="\033[00m"

for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d | sort -V); do
    echo -e "$yellow IOMMU Group $(basename "$iommu_group") $non";
    for device in $(ls -1 "$iommu_group"/devices/); do
        echo -en $green "     ";
        result=($(lspci -nns "$device"));
        echo -e ${result[0]} $non ${result[@]}
    done;
done
