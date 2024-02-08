#!/bin/sh
# check-virtualization.sh script v0.1 by @genr8eofl copyright 2024 - AGPL3 License

if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -ge 1 ]; then
	echo "CPU supports VMX/SVM virtualization!"
    echo "still need to make sure that virtualization is enabled in the BIOS."
	dmesg | grep 'kvm'
	ls -al /dev/kvm
else
	echo "0 = CPU doesnt support hardware virtualization."
fi
