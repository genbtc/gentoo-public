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
    copytogit.sh - create this git repo, update git files from where they live at.
    doas-persist-myanalysis-Aug2922.txt - I looked into and did my own research on the doas persist function
    eselect-profiles-list-June302023.txt - all primary gentoo profiles
    gentoo-Infrastructure-Servers-List-Jun0323.txt  - official gentoo servers list
    gentoo-Infrastructure-Servers-Details-Jun0323.txt - official gentoo servers details
    gentoo-all-profiles-USE-flags-Sept0322.txt - USE flags for each primary profile
    gentoo-all-profiles-USE-flags-July0123.txt - USE flags for each primary profile
    gentoo-all-profiles-expanded.txt - profiles are expanded by recursing backwards
    gentoo-all-profiles-toplevels.txt - the top level of profile tree nodes
    gentoo-bug-471718.txt - some random bug
    gentoo-chroot-binhost-ideas-July0423.txt - ** creative plans and ideas. **
    gentoo-dilfridge-binhost-Packages-Names-Feb1723.txt - what dilfridge provides on his binhost
    gentoo-eix-equery-gentoopm---helps.txt - list of package query helper --help's
    gentoo-git-rsync-convert.txt - how to convert repos.conf from rsync to git.
    gentoo-ideas-Interesting-lines-of-thought-1.txt - ** creative plans and ideas. **
    gentoo-ideas-portage_web_api.txt - ** creative plans and ideas. **
    gentoo-installation-instructions_gen.txt - ** personal quick install guide to gentoo **
    gentoo-iso-latest-dl_Spawns.sh - download the latest ISO script
    gentoo-isos-latest-list-Feb0723.txt - list of the ISOs that were available on Feb 07, 2023
    gentoo-newfeature-ideas-2022+2023update.txt - ** creative plans and ideas. **
    gentoo-portage-niceness.txt -  how to make lag go away using ionice, chrt, io-priority & NICE niceness
    gentoo-profiles-project1.txt - working on a project to interact with a profile manager
    gentoo-profiles-script-1.sh.txt - working on a project to interact with a profile manager
    gentoo-qsize-all-my-packages-sortbysize-Feb0323.txt - Sizes of Packages, what i had installed
    gentoo-stage3-available-list-Mar1323.txt - list of the Stage3's that were available on March 13, 2023
    gentoo-uid-gid-July0223.txt - official UID/GID api list for portage gentoo user/groups
    gentoo-wiki-mountcommands.txt - chroot mount commands quick reference
    gentoopm-python-docs-nb.txt - heres some docs for gentooPM (python script to interact with portage)
    gentoopm-graphviz-dot-depgraph.py - graph the dependencies of portage with graphviz, script by mgorny
    gentoopm-small-test-list-pkgs-script.py - example gentoopm script
    gentoopm-smallest-script-list-installed.py - example gentoopm script
    git-source-repos-ive-cloned-urls2-July072023.txt - personal list of favorite github open source repos
    human-wellness-list.txt - learn how to be a healthy human
    immutable-root-description.txt - what is immutable root ? I will tell you.
    kubler-notebook+documentation.txt - I did a brief structural software engineering analysis of Kubler and its good!
    mime-xpak.xml - some lacking MIME types, portage.tar.bz2 .tbz2 ,
    rit.edu.autobuild.list.txt - list of stage3's that were available from fast RIT.edu mirror as of June 25, 2023
    welcome-to-gentoo.txt - WELCOME TO GENTOO (if you made it this far, contact me on IRC)
