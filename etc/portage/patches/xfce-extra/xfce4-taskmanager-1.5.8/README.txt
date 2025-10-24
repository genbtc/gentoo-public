#NOTE: (by genr8) Feb 07, 2025
These selinux patches apply configure.ac changes.
Eautoreconf needs to be executed manually
Usage:
 ebuild2 xfce4-taskmanager clean
 ebuild2 xfce4-taskmanager prepare
 cd $WORK_DIR
 autoreconf && chown portage: . -R
 ebuild2 xfce4-taskmanager configure
 ebuild2 xfce4-taskmanager package
 ebuild2 xfce4-taskmanager merge
