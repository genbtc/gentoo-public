#!/bin/bash
#@2023 genr8eofl @gentoo IRC - Feb 6 2023
#                          v2 -Mar 26 2023

UEFIFILE="/usr/share/edk2-ovmf/OVMF_CODE.fd"
UEFI="-drive file=${UEFIFILE},if=pflash,format=raw,unit=0,readonly=on"
KVM="-enable-kvm"
CPU="-cpu host -smp 8"
MEM="-m 4G"
DISKFILE="blankqemudrive.img"
DISK="-hda ${DISKFILE}"
#BOOT="-boot d"
#ISOFILE="/mnt/borg/ISOs/Win10_1909_English_x64.iso"
CDROM="-cdrom ${ISOFILE}"
#runit
params=("${UEFI}" "${KVM}" "${CPU}" "${MEM}" "${BOOT}" "${DISK}" "${CDROM}")
fallocate -l 1G blankqemudrive.img
qemu-system-x86_64 ${params[@]} $@ \
--netdev user,id=vmnic,hostname=gentoovm \
-device e1000,netdev=vmnic \
-device intel-hda -device hda-duplex \
-usbdevice tablet
rm blankqemudrive.img
