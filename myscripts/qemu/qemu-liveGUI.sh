#!/bin/bash
#c@2023 genr8eofl @gentoo IRC - April 04, 2023

qemu-system-x86_64  -m 4G \
                    -enable-kvm \
                    -cpu host \
                    -smp 4 \
                    -name "Gentoo amd64 LiveGUI" \
                    --netdev user,id=vmnic,hostname=gentoovm \
                    -device e1000,netdev=vmnic \
                    -bios /usr/share/edk2-ovmf/OVMF_CODE.fd \
                    -device intel-hda -device hda-duplex \
        			-usbdevice tablet \
                    -cdrom ${1}
