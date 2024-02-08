#!/bin/sh
if ! command -v dialog >/dev/null; then
    echo "This program requires dialog to be installed."
fi
DIAHEIGHT=0;	DIAWIDTH=40;

exec 3>&1       #open FD3 as a clone of 1
#Command substitution inside subshell
selected=$(dialog \
    --title "Gentoo Image Scripts" \
    --menu "" $DIAHEIGHT $DIAWIDTH 0 \
    "S" "Download Stage 3 .tar.gz" \
    "M" "Download Minimal Install .iso" \
    "L" "Download LiveGUI .iso" \
    "P" "Make partition image" \
    "F" "Make filesystem & mounts" \
    "C" "Chroot in" \
2>&1 1>&3)
#Fancy FD redirection stores selection in FD3
exit_status=$?  #numerical return code
exec 3>&-       #close FD3

case $selected in
    S) echo "1. s was chosen: download-gentoo-iso-latest-dl_Spawns.sh stage3-amd64-openrc";;
    M) echo "2. m was chosen: download-gentoo-iso-latest-dl_Spawns.sh install-amd64-minimal";;
    L) echo "3. l was chosen; download-gentoo-iso-latest-dl_Spawns.sh livegui-amd64";;
    P) echo "4. p was chosen: make-disk-partition.sh";;
    F) echo "5. f was chosen: mount-partition.sh";;
    C) echo "6. c was chosen: genr8-chroot.sh";;
esac

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
#Check Dialog Return Codes
case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
    $DIALOG_OK)
      echo "Done. (selected $selected)"
      exit 0
      ;;
esac
