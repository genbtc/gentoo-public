# (c) 2023 - genr8 @ gentoo - script recipe for binhost filter v0.1

# find -name '*.xpak' -exec echo {} >> PACKAGES.txt \;

#1
# cd ~/.cache/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD/binpkgs-gentoo-atom-tablet-1/
# find . -type f -name '*.xpak' -exec echo {} \; -exec qxpak -xO {} CFLAGS \;  > CFLAGS.txt
# grep broadwell -B1 CFLAGS.txt > CFLAGS-broadwell.txt
# grep -v broadwell CFLAGS-broadwell.txt > CFLAGS-broadwell-names.txt
# while read F; do echo $F; D=$(dirname $F); mkdir -p broadwell/$D/$F; mv $F broadwell/$D/ ; done < CFLAGS-broadwell-names.txt

#2
# cd /run/user/1000/gvfs/smb-share:server=10.1.1.1,share=raidz-4tbx4/DiskImages/LinuxDD/binpkgs-gentoo-llvm-031223-June30-1
# find . -type f -name '*.xpak' -exec echo {} \; -exec qxpak -xO {} CFLAGS \;  > CFLAGS.txt

# grep znver3 -B1 CFLAGS.txt > CFLAGS-znver3.txt
# grep xpak CFLAGS-znver3.txt > CFLAGS-znver3-NAMES.txt

# while read F; do echo $F; D=$(dirname $F); mkdir -p znver3/$D/$F; mv $F znver3/$D/ ; done < CFLAGS-znver3-names.txt
# mv znver3 ../binpkgs-gentoo-llvm-znver3

