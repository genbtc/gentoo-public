#!/bin/bash

set -Eeuxo pipefail

MACHINE_NAME="verified"
QEMU_IMG="${MACHINE_NAME}.img"
OVMF_CODE="/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd"
OVMF_VARS_ORIG="/usr/share/edk2-ovmf/OVMF_VARS.fd"
OVMF_VARS="$(basename "${OVMF_VARS_ORIG}")"

GENTOO_ISO="/mnt/crucialp1/ISO/livegui-amd64-20240114T164819Z.iso"

#if [ ! -e "${QEMU_IMG}" ]; then
#        qemu-img create -f qcow2 "${QEMU_IMG}" 8G
#fi
#if [ ! -e "${OVMF_VARS}" ]; then
#        cp "${OVMF_VARS_ORIG}" "${OVMF_VARS}"
#fi
#SSH_PORT="5555"
#        -drive file="${QEMU_IMG}",format=qcow2 \
#        -net nic,model=virtio -net user,hostfwd=tcp::${SSH_PORT}-:22 \
#https://wiki.archlinux.org/title/QEMU#Virtual_machine_not_booting_when_using_a_Secure_Boot_enabled_OVMF -global ICH9-LPC.disable_s3=1
TPMDIR="/tmp/mytpm1"
mkdir -pv "${TPMDIR}"
swtpm socket --tpmstate dir="${TPMDIR}" --ctrl type=unixio,path="${TPMDIR}"/swtpm-sock --tpm2   &
sleep 1
qemu-system-x86_64 \
        -enable-kvm -cpu host -smp 8 -m 4096 \
        -machine q35,smm=on \
		-global ICH9-LPC.disable_s3=1 \
		-boot menu=on \
		-net nic,model=virtio \
		-net user \
        -global driver=cfi.pflash01,property=secure,value=on \
        -drive if=pflash,format=raw,unit=0,file="${OVMF_CODE}",readonly=on \
        -drive if=pflash,format=raw,unit=1,file="${OVMF_VARS}" \
		-cdrom "${GENTOO_ISO}" \
        -hda /dev/loop0 \
        -vga virtio \
        -name "${MACHINE_NAME}" \
		-chardev socket,id=chrtpm,path="${TPMDIR}"/swtpm-sock \
	    -tpmdev emulator,id=tpm0,chardev=chrtpm \
		-device tpm-tis,tpmdev=tpm0 \
        -device virtio-rng-pci \
        -device virtio-rng-pci,rng=rng0 \
		-object rng-random,filename=/dev/urandom,id=rng0 \
		$@
