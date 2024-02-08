#!/bin/bash
#@2023 genr8eofl @gentoo IRC - Feb 6 2023

UEFIFILE="/usr/share/edk2-ovmf/OVMF_CODE.fd"
UEFI="-drive file=${UEFIFILE},if=pflash,format=raw,unit=0,readonly=on"
KVM="-enable-kvm"
CPU="-cpu host -smp 8"
MEM="-m 3G"
#BOOT="-boot d"
DISKFILE="/dev/loop0"
DISK="-hda ${DISKFILE}"
#ISOFILE="/mnt/borg/ISOs/Win10_1909_English_x64.iso"
CDROM="-cdrom ${ISOFILE}"
#runit
params=("${UEFI}" "${KVM}" "${CPU}" "${MEM}" "${BOOT}" "${DISK}" "${CDROM}")
qemu-system-x86_64 ${params[@]} $@
