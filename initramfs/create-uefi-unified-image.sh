esp=/efi
distro=archlinux
mkdir -p $esp/EFI/$distro
# Generate UEFI Unified Image
dracut --force --verbose --kver $(uname -r) $esp/EFI/$distro/linux+initramfs.efi.signed

# Create UEFI boot manager entry
efibootmgr --quiet --create --disk /dev/disk/by-label/EFI --label 'Arch Linux' --loader /EFI/$distro/linux+initramfs.efi.signed