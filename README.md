# gentoo-public
Public scripts for Gentoo Linux community
by genr8eofl genBTC

## IMA
    - IMA-ascii_runtime_measurements (hash of verified boot process)
    - diff-6.3.11-gentoo-dist-hardened-default-vs-IMA.config.txt
    - IMA custom patch to disable appraise after its enabled via sysfs
    - 15 different policy files, stock + custom.
## chroot
    - chroot-mounts.sh is the simplest version.
    - mattst88-chroot is unshare based, just mounts, and simplified to read
    - scripts based on arch-chroot -> kangie-chroot
    - genr8-chroot fork
    - fdisk-partition.sh and sfdisk-dump.conf can be used to automate partitioning
## dotfiles
    - .bash_aliases
    - .bashrc
    - .nanorc
    - .tmux.conf
    - htoprc
## ebuilds
    - ebuilds I made and collected
## etc
    - my /etc/ folder, /etc/bash/bashrc and /etc/eusesrc is also a dotfile
    - /etc/kernel - postinst.d/grub-manual-entry custom grub-mkconfig script on install
    - /etc/portage - current config
## gentoo
    - some random world files
## kernel
    - changelog.sh (Download changelogs and summary them)
    - patch-new.sh (Detect & Download new patches, actually patch the kernel, also read/store changelogs)
## myoverlay
    - created two custom profiles, hardened-desktop and nomultilib-hardened-clangllvm-mergedusr-custom
## myscripts
    - All my scripts - click through to see README
## patches
    - custom patches for: (elogv, lxc-checkconfig, quickpkg) I need the changes.
## selinux
    - sec-policy-selinux-policies-list-all-060923.txt (list of all policy packages on gentoo repo)
    - selinux-semanage-boolean-l-list-Jun1623.txt (boolean toggle knobs for my installed policy)
    - xevent3.te ( example of xserver_object_manager policy - extra granular GUI window manager permissions)

## top dir Files:
    copytogit.sh
    doas-persist-myanalysis-Aug2922.txt
    eselect-profiles-list-June302023.txt
    gentoo-Infrastructure-Servers-Details-Jun0323.txt
    gentoo-Infrastructure-Servers-List-Jun0323.txt
    gentoo-all-profiles-USE-flags-July0123.txt
    gentoo-all-profiles-USE-flags-Sept0322.txt
    gentoo-all-profiles-expanded.txt
    gentoo-all-profiles-toplevels.txt
    gentoo-bug-471718.txt
    gentoo-chroot-binhost-ideas-July0423.txt
    gentoo-dilfridge-binhost-Packages-Names-Feb1723.txt
    gentoo-eix-equery-gentoopm---helps.txt
    gentoo-gentoopm-python-docs-nb.txt
    gentoo-git-rsync-convert.txt
    gentoo-ideas-Interesting-lines-of-thought-1.txt
    gentoo-ideas-portage_web_api.txt
    gentoo-installation-instructions_gen.txt
    gentoo-iso-latest-dl_Spawns.sh
    gentoo-isos-latest-list-Feb0723.txt
    gentoo-newfeature-ideas-2022+2023update.txt
    gentoo-portage-niceness.txt
    gentoo-profiles-project1.txt
    gentoo-profiles-script-1.sh.txt
    gentoo-qsize-all-my-packages-sortbysize-Feb0323.txt
    gentoo-stage3-available-list-Mar1323.txt
    gentoo-uid-gid-July0223.txt
    gentoo-wiki-mountcommands.txt
    gentoopm-graphviz-dot-depgraph.py
    gentoopm-small-test-list-pkgs-script.py
    gentoopm-smallest-script-list-installed.py
    git-source-repos-ive-cloned-urls2-July072023.txt
    human-wellness-list.txt
    immutable-root-description.txt
    kubler-notebook+documentation.txt
    mime-xpak.xml
    rit.edu.autobuild.list.txt
    welcome-to-gentoo.txt
