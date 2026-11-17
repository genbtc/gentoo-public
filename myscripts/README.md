# GenBTC's Gentoo & Linux Scripts

A collection of small, practical tools and experiments for administering Gentoo Linux and working with Linux systems. The scripts grew out of real installation, Portage, storage, kernel, SELinux, integrity-measurement, and hardware-debugging work. They are independent utilities rather than one unified application.

Most entries are intended to be read, adapted, and run in the context they were written for. Some are quick one-off helpers; others are pieces of a larger workflow.

> **Read before running:** several scripts assume specific disks, partitions, mount points, mirrors, network shares, or Gentoo paths. In particular, review anything that partitions or formats a device, deletes a local cache, or changes a chroot's mount state. The Btrfs installer recipe under `renich/` explicitly repartitions `/dev/vda`. Do not run these scripts blindly on a machine containing data you care about.

Licensing and attribution are file-specific. Check each file's header before redistributing or reusing it; this directory contains work under several licenses and includes material derived from other projects and community examples.

## Disk images, partitions, filesystems & chroots

- [`amazing-make-disk-truncate.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/amazing-make-disk-truncate.sh) — Creates a sparse disk-image file of a chosen size and attaches it to a loop device with partition scanning enabled.
- [`amazing-make-partition-truncate.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/amazing-make-partition-truncate.sh) — Builds a sparse disk image, writes a GPT layout (EFI, boot, root), and formats the three partitions as FAT32 and ext4.
- [`amazing-mount-fs-partitions.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/amazing-mount-fs-partitions.sh) — Attaches a disk image, mounts its root/boot/EFI filesystems, prepares the usual pseudo-filesystem mount points, and extracts a matching Stage 3 archive when needed.
- [`amazing-pet-gentoo.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/amazing-pet-gentoo.sh) — Orchestrates the Stage 3 download, image/partition setup, mounting, and entry into the resulting Gentoo chroot.
- [`make-disk-partition.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/make-disk-partition.sh) — Writes the same basic EFI/boot/root GPT layout and creates filesystems directly on a disk or disk image. Its default target is `/dev/sda`, so inspect the target before use.
- [`mount-partition.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-partition.sh) — Sets up a loop device for a disk-image file and mounts the image's filesystem under `/mnt`.
- [`mount-disk-partition.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-disk-partition.sh) — Mounts the root, boot, and EFI partitions from a three-partition disk layout.
- [`mount-fresh-install-disk.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-fresh-install-disk.sh) — Mounts a freshly partitioned disk's root/boot/EFI filesystems, then extracts a Stage 3 archive into the root filesystem.
- [`mount-chroot.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-chroot.sh) — Mounts `/proc`, `/sys`, `/dev`, and `/run` into the current chroot directory.
- [`mount-chroot-gentoo.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-chroot-gentoo.sh) — Similar chroot mount setup, with an additional bind mount for the host's Gentoo repository.
- [`mount-chroot-dir.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/mount-chroot-dir.sh) — Performs the standard pseudo-filesystem mounts for a chroot rooted at `/mnt/gentoo`.
- [`genr8-chroot`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/genr8-chroot) — A Gentoo-oriented, `arch-chroot`-style wrapper. It handles chroot mounts and offers optional bindings for kernel sources, distfiles, binary packages, Portage configuration, and host repositories.
- [`extract-stage3-all.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/extract-stage3-all.sh) — Extracts matching Stage 3 tarballs while preserving extended attributes and numeric ownership.
- [`my-initramfs-script.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/my-initramfs-script.sh) — Minimal BusyBox initramfs script: mounts early virtual filesystems, loads NVMe modules, resolves the `root=` kernel argument, mounts an ext4 root filesystem, and calls `switch_root`. Review its fallback UUID/LABEL values for your system.
- [`renich/`](https://github.com/genbtc/gentoo-public/tree/main/myscripts/renich) — Btrfs-focused Gentoo installation recipes. The first script partitions a disk, creates filesystems and Btrfs subvolumes; the second walks through mounting subvolumes, extracting Stage 3, configuring Portage, and installing a bootloader. The partitioning script is destructive and is hard-coded for `/dev/vda`.

## Gentoo downloads, Stage 3 & image creation

- [`download-gentoo-iso-latest-dl_Spawns.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/download-gentoo-iso-latest-dl_Spawns.sh) — Fetches the latest Gentoo autobuild named by its argument, downloads its detached signature, and verifies the image/archive with Gentoo's release key using `gemato` and GPG.
- [`download-livegui-latest.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/download-livegui-latest.sh) — A simpler LiveGUI ISO downloader that reads Gentoo's `latest-livegui-amd64.txt` and downloads the referenced image. Unlike the script above, it does not verify the signature.
- [`directory-listing-download-all-recursive.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/directory-listing-download-all-recursive.sh) — Uses an `elinks`-formatted directory listing and `wget` to recursively download files from the configured Gentoo binary-package mirror. The platform and mirror URL are set inside the script.
- [`stage3-download-all.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-download-all.sh) — Downloads the Stage 3 archives listed in a previously generated Gentoo autobuild directory listing.
- [`stage3-CONTENTS-download-list.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-CONTENTS-download-list.sh) — Dumps a Gentoo autobuild directory listing with `elinks` and extracts the Stage 3 `CONTENTS.gz` filenames.
- [`stage3-CONTENTS-download-all.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-CONTENTS-download-all.sh) — Downloads the Stage 3 `CONTENTS.gz` files selected from the listing and decompresses them for inspection.
- [`stage3-CONTENTS-parse-packagelist.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-CONTENTS-parse-packagelist.sh) — Extracts installed package atoms from one Stage 3 `CONTENTS` file.
- [`stage3-CONTENTS-parse-packagelist-ALL.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-CONTENTS-parse-packagelist-ALL.sh) — Runs the same package-list extraction over all matching Stage 3 `CONTENTS` files in the current directory.
- [`extract-livegui-squashfs-3.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/extract-livegui-squashfs-3.sh) — Extracts `image.squashfs` from a LiveGUI ISO with `7z`, then unpacks the filesystem with `unsquashfs`.
- [`squashfs-mount.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/squashfs-mount.sh) — Mounts the first `.squashfs` file in the current directory at `/mnt/gentoo`.
- [`stage4-make-grub-rescue.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage4-make-grub-rescue.sh) — Builds a GRUB-rescue ISO from a prepared directory using `grub-mkrescue`.
- [`stage4-make-isofs.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage4-make-isofs.sh) — Creates an ISO from a directory tree using `mkisofs` with an ISOLINUX boot catalog and boot-image options.
- [`stage4-make-squashfs.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage4-make-squashfs.sh) — Example `mksquashfs` command for packaging a LiveGUI-style directory as a compressed SquashFS image. Source and output names are currently hard-coded.
- [`stage3-chroot-quickpkg.md`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-chroot-quickpkg.md) — A workflow note covering Stage 3 downloads, chroot preparation, `quickpkg`, binary-package collection, and the related `CONTENTS`-file tools.

## Dialog menus & handbook navigation

- [`install-dialog-handbook.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/install-dialog-handbook.sh) — Supplies the chapter titles, summaries, and outlines used by the Gentoo Handbook menu.
- [`install-dialog.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/install-dialog.sh) — Presents a `dialog` menu for browsing Gentoo Handbook installation chapters and displaying their summaries/outlines; it also includes a chroot entry option.
- [`start-dialog.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/start-dialog.sh) — Presents a small `dialog` menu for the Stage 3 download, minimal ISO/LiveGUI download, partition-image, mount, and chroot steps; it prints the selected command rather than running the workflow itself.

## Portage, package metadata & emerge helpers

- [`allfiles.py`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/allfiles.py) — Queries Portage's installed-package database and prints the filesystem paths owned by selected package atoms; `-a` scans all installed packages and `-v` adds package headers.
- [`equery-alldepgraphs.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/equery-alldepgraphs.sh) — Builds a list of installed package atoms and appends an `equery depgraph` report for each package to a combined dependency-graph file.
- [`equery-allfiles+listdiff.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/equery-allfiles+listdiff.sh) — Collects the files recorded by `equery files`, compares that inventory with files found on the root filesystem, and writes the differences to a report.
- [`diffebuildold.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/diffebuildold.sh) — Compares an ebuild from the current Portage repository with the copy recorded in the installed package database.
- [`checkworldfile-removeworld.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/checkworldfile-removeworld.sh) — Checks each atom in Portage's `world` file with `emerge --depclean --pretend` and reports entries that appear removable from `world`.
- [`checkworldfiledepclean.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/checkworldfiledepclean.sh) — Combines reverse-dependency checks with pretend `emerge --depclean` runs to identify `world` entries that can be deselected versus those that should remain.
- [`checkworldfiledepclean-awk.sh.awk`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/checkworldfiledepclean-awk.sh.awk) — AWK helper used by `checkworldfiledepclean.sh` to extract package names from its intermediate `checking` output.
- [`find-binpkg-qxpak-BUILD_TIME.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-binpkg-qxpak-BUILD_TIME.sh) — Scans the local binary-package cache and prints the `BUILD_TIME` metadata extracted from each `.xpak` archive with `qxpak`.
- [`find-binpkg-qxpak-CFLAGS.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-binpkg-qxpak-CFLAGS.sh) — A commented recipe showing how to extract binary-package `CFLAGS` metadata and sort/filter packages by target architecture; it is an example rather than a standalone executable script.
- [`find-vdb-BUILD_TIME-earlierthan.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-vdb-BUILD_TIME-earlierthan.sh) — Lists installed packages whose Portage VDB `BUILD_TIME` is older than a supplied Unix timestamp.
- [`find-vdb-BUILD_TIME-get-all-PKGTIMES-sorted.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-vdb-BUILD_TIME-get-all-PKGTIMES-sorted.sh) — Produces a timestamp-sorted report of installed packages, including both epoch and human-readable build times.
- [`find-vdb-get-CFLAGS.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-vdb-get-CFLAGS.sh) — Exports the recorded compiler flags for every installed package from Portage's VDB.
- [`find-vdb-get-PKGUSE-flags.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-vdb-get-PKGUSE-flags.sh) — Exports installed package atoms and their recorded per-package USE flags in a `package.use`-style format.
- [`find-vdb-get-flags-PKGUSE.py`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-vdb-get-flags-PKGUSE.py) — Uses the Portage Python API to print installed package atoms alongside their `PKGUSE` metadata.
- [`portage-parse.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/portage-parse.sh) — Extracts package atoms from saved `emerge` update output, focusing on ebuild entries from the Gentoo repository.
- [`portage-parse-script.bash`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/portage-parse-script.bash) — Earlier parsing experiments for extracting package names from `emerge -qpuDU @world` output and saved Portage update logs.
- [`spawn-prefix.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/spawn-prefix.sh) — Sets an alternate Portage `ROOT`, temporary directory, and log locations, then runs a small emerge test against that target.
- [`vdb-bundle.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/vdb-bundle.sh) — Archives the Portage VDB while excluding bulky or reproducible files such as environment dumps, ebuilds, and `CONTENTS` files.
- [`view-emerge-log-humantimestamp.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/view-emerge-log-humantimestamp.sh) — Converts the epoch timestamp at the start of each `/var/log/emerge.log` line into a readable date/time and opens the result in `less`.

## Moving Portage caches and build artifacts

- [`move-binpkgs-to-server.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/move-binpkgs-to-server.sh) — Rsyncs the local Portage binary-package cache to a configured SMB share using incremented destination names, then offers to remove the local copies. Review the destination and deletion step carefully.
- [`move-distfiles-to-server.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/move-distfiles-to-server.sh) — Rsyncs Portage distfiles to a configured server share, temporarily moving `git3-src` out of the way before cleaning the local distfiles directory.
- [`move-buildlogs-to-server.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/move-buildlogs-to-server.sh) — Copies the configured Portage build-log directory to a timestamped directory on a server share and then prompts about deleting local logs.

## CPU architecture, instruction sets & hardware

- [`check-virtualization.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/check-virtualization.sh) — Checks `/proc/cpuinfo` for Intel VT-x or AMD-V flags and displays related KVM kernel/device information.
- [`check-x86-64-glibc-baselines.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/check-x86-64-glibc-baselines.sh) — Invokes the glibc dynamic loader's `--help` output to show the x86-64 glibc-hwcaps subdirectories and their search priority.
- [`check-x86-64-v-baseline-missing-flag.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/check-x86-64-v-baseline-missing-flag.sh) — Determines the highest x86-64-v1/v2/v3/v4 CPU baseline reached and reports the first missing feature flags for the next level.
- [`check-x86-64-v1-v2-v3-v4-baselines.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/check-x86-64-v1-v2-v3-v4-baselines.sh) — Shell/AWK-based check for x86-64-v2, v3, and v4 feature sets using `/proc/cpuinfo`.
- [`check-x86-64-v1-v2-v3-v4-baselines.awk`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/check-x86-64-v1-v2-v3-v4-baselines.awk) — Standalone AWK implementation that detects and prints the highest supported x86-64 microarchitecture level.
- [`lsiommu.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/lsiommu.sh) — Lists Linux IOMMU groups and the PCI devices assigned to each group, using sysfs and `lspci`.
- [`nvmelog.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/nvmelog.sh) — Saves `nvme list` and per-device NVMe SMART logs for the drive names configured in the script.
- [`objdump-instruction-list.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/objdump-instruction-list.sh) — Disassembles a binary with Intel mnemonics and emits a sorted, unique list of the instruction mnemonics it contains.
- [`objdump-insn/`](https://github.com/genbtc/gentoo-public/tree/main/myscripts/objdump-insn) — Reference instruction lists organized by x86 ISA families and extensions (including SSE, AVX, AVX-512, BMI, FMA, VMX, and others), plus helper scripts for mapping an `objdump` mnemonic list to an instruction family.

## SELinux, kernel modules & integrity

- [`find-execstack.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-execstack.sh) — Searches process memory maps under `/proc` for processes with an executable stack mapping.
- [`find-suid.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-suid.sh) — Finds SUID and SGID files on the root filesystem and appends their details to `suidfiles.txt`.
- [`find-worldwritable.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/find-worldwritable.sh) — Finds world-writable entries on the root filesystem while excluding symlinks and sticky-bit directories.
- [`imatest.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/imatest.sh) — Runs `evmctl ima_verify` over a date-stamped file list and records paths whose IMA signatures fail verification.
- [`semakegit.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/semakegit.sh) — Copies SELinux policy `.te`, `.if`, and `.fc` files into a sibling Git working directory and commits the changes with a timestamped message.
- [`sign-module.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/sign-module.sh) — Signs a specified kernel module or other supported kernel artifact with the kernel `sign-file` utility and the configured SHA-512 key pair.
- [`sign-this-dir.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/sign-this-dir.sh) — Finds every `.ko` file below the current directory and signs each one with the configured kernel module key.
- [`te2.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/te2.sh) — SELinux policy-development workbench with helpers for compiling Type Enforcement policy to CIL and testing interface statements against a generated module.
- [`etc/`](https://github.com/genbtc/gentoo-public/tree/main/myscripts/etc) — OpenRC `local.d` startup/shutdown hook examples for capturing IMA runtime measurements, recording TPM 2.0 event logs/PCRs, and writing a boot-complete marker. An IMA policy-reset function is also present, but its call is commented out.

## System inspection, logs & small utilities

- [`sysgather.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/sysgather.sh) — Collects a broad system snapshot (kernel, CPU, PCI/USB, storage, memory, networking, Portage, and optional health/SMART data) into a timestamped directory under `~/sysgather-logs/`.
- [`while-menu.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/while-menu.sh) — A simple interactive loop for displaying uptime/kernel information, filesystem usage, and home-directory space usage.
- [`wtmp-format-boot.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/wtmp-format-boot.sh) — Converts `last`'s system-boot records into date/time and kernel-version lines.
- [`vttsedawk.sh`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/vttsedawk.sh) — Strips the header and markup from a WebVTT-style subtitle file, then writes cue start times and subtitle text to a `.txt` file.

## Companion files and examples

These entries support the scripts but are not themselves general-purpose command-line tools:

- [`download-gentoo-iso-latest-dl_Spawns.txt`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/download-gentoo-iso-latest-dl_Spawns.txt) and 
- [`downloaded-gentoo-livegui.txt`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/downloaded-gentoo-livegui.txt) — Captured example output from Gentoo download runs, including release-signature verification output.
- [`genr8too-installer_2024-12-14_12-25-36.png`](https://github.com/genbtc/gentoo-public/blob/main/myscripts/genr8too-installer_2024-12-14_12-25-36.png) — Installer screenshot retained alongside the scripts.

## A typical Stage 3 → chroot → binary-package workflow

The directory also contains a more detailed [Stage 3 / chroot / quickpkg workflow note](https://github.com/genbtc/gentoo-public/blob/main/myscripts/stage3-chroot-quickpkg.md).
At a high level, the related tools can be used to:

1. Inspect Gentoo's autobuild directory and download Stage 3 archives or their `CONTENTS` metadata.
2. Create a disk image or prepare a disk with EFI, boot, and root filesystems.
3. Mount the filesystems and extract the Stage 3 archive.
4. Enter the installation with `genr8-chroot` and configure Portage.
5. Build a binary-package cache with `quickpkg`, then move or reuse those packages on another machine.

The scripts are deliberately small and environment-specific. Treat them as a toolbox and starting point, not as a fully automated installer.
