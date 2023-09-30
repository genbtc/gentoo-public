# The best gentoo document!
##### by genr8eofl @gentoo IRC - 2023 LICENSE - Creative Commons 4.0, Attribution

## binhosts, binpkgs, quickpkg, chroots!

Things do with stage3's:
--------------------------

#### Stage3:
1. download directory list of stage3s (elinks --dump)  
    [stage3-CONTENTS-download-list.sh](stage3-CONTENTS-download-list.sh)  
    create file: elinks-dump-gentoo-release-autobuilds-dirlisting-${TODAY}.txt  
2. download all stage3s, one by one (wget, foreach)  
    [stage3-download-all.sh](stage3-download-all.sh)  
3. create amazing image, partitions & fs (truncate sparse, losetup, sfdisk, mkfs)  
    [amazing-make-partition-truncate.sh](amazing-make-partition-truncate.sh)  
4. mount amazing image (mount /dev/loop0 /mnt/stage3_1)  
    [amazing-mount-fs-partitions.sh](amazing-mount-fs-partitions.sh)  
5. extract stage3 into /mnt/stage3_1 (tar xvf * --...)  
    [extract-stage3-all.sh](extract-stage3-all.sh)  
5. genr8-chroot into /mnt/stage3_1 (arch-chroot for/from me/gentoo)  
    [genr8-chroot.sh](genr8-chroot)  
    (binds /etc/resolv.conf DISTDIR=/var/cache/distfiles, PORTDIR=/var/db/repos/gentoo)  
6. fix /etc/portage/ and make.conf (FEATURES="buildpkg")  
    (make.conf can be optionally bound in from the host with genr8-chroot -m)  
7. quickpkg --include-config=y '*/*'  
8. ctrl^D (exit chroot)  
9. mv /mnt/stage3_1/var/cache/binpks ~/binpkg-storage/stage3_1  
10. Done, Binpkgs Created, Repeat.  Then use them on a client.

#### CONTENTS.gz:
1. download directory list of stage3s (elinks --dump) (same as other step 1)  
    [stage3-CONTENTS-download-list.sh](stage3-CONTENTS-download-list.sh)  
2. download all -CONTENTS.gz's, one by one (wget, foreach)  
    [stage3-CONTENTS-download-all.sh](stage3-CONTENTS-download-all.sh)  
3. parse -CONTENTS.gz's - make stage3-xxx-packageslist.txt files (vdb list inside)  
    [stage3-CONTENTS-parse-packagelist-recursive.sh](stage3-CONTENTS-parse-packagelist-recursive.sh)  
