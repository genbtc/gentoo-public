#!/bin/sh

	### for pcie sound card pass-though, add/edit these lines
	### note: you need iommu/vfio setup on your host
	#-device pcie-root-port,id=root,slot=0 \
	#-device vfio-pci,host=0b:00.4,id=audio,bus=root \
qemu-system-x86_64 -cpu host,+topoext -accel kvm -smp 24,sockets=1,cores=12,threads=2 -m 16384 \
	-drive file=config,if=virtio,readonly=on \
	-device virtio-tablet-pci,id=input0,bus=pci.0,addr=0x10 \
	-device virtio-keyboard-pci \
	-device virtio-net,netdev=vmnic -netdev bridge,id=vmnic,br=br0 \
	-display gtk,gl=on,show-cursor=off -vga virtio \
	-kernel bootx64.efi
