#!/bin/bash
#
# arch-chroot -> genr8-chroot (a gentoo compatible version made by a person named genr8eofl)
# LICENSE: AGPL3
#
# Shamelessly borrowed from Arch to make Gentoo development in chroots easier;
# Thanks for doing all of the hard work! -@Kangie, 2022
# subsequently modified by -@genr8eofl, 2023
#  (ran shellcheck) (sorted code for readability) (comments)
#  (unshare removed) (auto bind mount itself - fix warning)
# slightly modified Sept 28, 2023 & February 06, 2024
#
# Optional Parameters: (short, long options, environment var name, path)
#   -f | --no-bind-distfiles | NO_MOUNT_DISTFILES	|	/var/cache/distfiles
#   -k | --no-bind-kernel | NO_MOUNT_KERNEL_SOURCE	|	/usr/src/linux
#   -n | --no-bind-bashrc | NO_MOUNT_BASHRC		|	/root/.bashrc
#   -b | --bind-binpkgs   | MOUNT_BINPKGS		|	/var/cache/binpkgs
#   -m | --bind-makeconf  | MOUNT_MAKECONF		|	/etc/portage/make.conf
#   -r | --bind-hostrepos | MOUNT_HOSTREPOS 		|	/var/db/repos/* (3rd party, not ::gentoo)
#   -d | --debug
#   -u | --user | USERSPEC=user[:group]
#

usage() {
  echo "$1"
  cat <<EOF
Usage: ${0##*/} [-o|--options] /path/to/chroot [command]
Description:
   Provide a path to directory to chroot into.
   ${0##*/} will handle all of the pre-requisite mounts, plus advanced features!
   Includes the following options: (and each has a matching ENV VAR)
Options:
 [ -f | --no-bind-distfiles ], [ -k | --no-bind-kernel, [ -n | --no-bind-bashrc ],
 [ -b | --bind-binpkgs ], [ -m | --bind-makeconf ], [ -r | --bind-hostrepos ],
 [ -d | --debug ], [ -u | --user <user>[:group] ]

/path/to/chroot is REQUIRED. (obvious choice is /mnt/gentoo)
[command] is optional. If unspecified, launch a /bin/bash shell by default.

EOF
  if [ "$1" == "Help" ]; then
    exit 0
  else
    exit 2
  fi
}

shopt -s extglob

#shellcheck disable=SC2059  # "Don't use variables in the printf format string. Use printf '..%s..' "$foo""
out() { printf "$1 $2\n" "${@:3}"; }
error() { out "==> \033[1;31mERROR\033[0m:" "$@"; } >&2
warning() { out "==> \033[1;33mWARNING\033[0m:" "$@"; } >&2
msg() { out "==>" "$@"; }
msg2() { out "  ->" "$@";}
die() { error "$@"; exit 1; }

ignore_error() {
  "$@" 2>/dev/null
  return 0
}

chroot_add_mount() {
  mount "$@" && CHROOT_ACTIVE_MOUNTS=("$2" "${CHROOT_ACTIVE_MOUNTS[@]}")
}

chroot_maybe_add_mount() {
  local cond=$1; shift
  if eval "$cond"; then
    chroot_add_mount "$@"
  fi
}

# meat
chroot_setup() {
  CHROOT_ACTIVE_MOUNTS=()
  [[ $(trap -p EXIT) ]] && die '(BUG): attempting to overwrite existing EXIT trap'
  trap 'chroot_teardown' EXIT

  chroot_add_mount proc "$1/proc" -t proc -o nosuid,noexec,nodev &&
  chroot_add_mount sys "$1/sys" -t sysfs -o nosuid,noexec,nodev,ro &&
  ignore_error chroot_maybe_add_mount "[[ -d '$1/sys/firmware/efi/efivars' ]]" \
      efivarfs "$1/sys/firmware/efi/efivars" -t efivarfs -o nosuid,noexec,nodev &&
  chroot_add_mount udev "$1/dev" -t devtmpfs -o mode=0755,nosuid &&
  chroot_add_mount devpts "$1/dev/pts" -t devpts -o mode=0620,gid=5,nosuid,noexec &&
  chroot_add_mount shm "$1/dev/shm" -t tmpfs -o mode=1777,nosuid,nodev &&
  chroot_add_mount run "$1/run" -t tmpfs -o nosuid,nodev,mode=0755 &&
  chroot_add_mount tmp "$1/tmp" -t tmpfs -o mode=1777,strictatime,nodev,nosuid
}

chroot_teardown() {
  if (( ${#CHROOT_ACTIVE_MOUNTS[@]} )); then
    umount "${CHROOT_ACTIVE_MOUNTS[@]}"
  fi
  unset CHROOT_ACTIVE_MOUNTS
  sleep 1
  umount -l "$(realpath "${CHROOT_DIR}")"
}

chroot_bind_device() {
  local DEVICE="${CHROOT_DIR}/$1"
  touch "${DEVICE}" && CHROOT_ACTIVE_FILES=("${DEVICE}" "${CHROOT_ACTIVE_FILES[@]}")
  chroot_add_mount "$1" "${DEVICE}" --bind
}

chroot_add_link() {
  ln -sf "$1" "$2" && CHROOT_ACTIVE_FILES=("$2" "${CHROOT_ACTIVE_FILES[@]}")
}

resolve_link() {
  local target=$1  root=$2

  # If a root was given, make sure it ends in a slash.
  [[ -n $root && $root != */ ]] && root=$root/

  while [[ -L $target ]]; do
    target=$(readlink -m "$target")
    # If a root was given, make sure the target is under it.
    # Make sure to strip any leading slash from target first.
    [[ -n $root && $target != $root* ]] && target=$root${target#/}
  done

  printf %s "$target"
}

# potato
# Mount arbitrary files into your chroot
# usage: chroot_add_file src-file[:dst-file]
# 		 (gets CHROOT_DIR from environment)
chroot_add_file() {
  local SRC_FILE  DST_FILE
  if [[ "${1}" == *:* ]]; then
    # Bind src -> dest
    SRC_FILE=${1%:*}
    DST_FILE=${1#*:}
    SRC_FILE=$(resolve_link "${SRC_FILE}")
    DST_FILE=$(resolve_link "${CHROOT_DIR}/${DST_FILE}" "${CHROOT_DIR}")
  else
    SRC_FILE=$(resolve_link "${1}")
    DST_FILE=$(resolve_link "${CHROOT_DIR}/${1}" "${CHROOT_DIR}")
  fi

  # If we don't have a source file, there's nothing useful we can do.
  [[ -e ${SRC_FILE} ]] || return 0

  if [[ ! -e $DST_FILE ]]; then
    # $DST_FILE may not exist because:
    #
    # 1. The file truly does not exist, so the variable becomes equal to $CHROOT_DIR/$1.
    # 2. $1/$2 is (or resolves to) a broken link.
    # The environment clearly intends for there to be a file here, but something's wrong. Maybe it
    #      normally creates the target at boot time.  We'll (try to) take care of it by
    #      creating a dummy file at the target, so that we have something to bind to.
    # Case 1.
    #commented out because other files may error out and its ok.
    #[[ ${DST_FILE} = "${CHROOT_DIR}/${1}" ]] && return 0
    # Case 2.
    install -Dm644 /dev/null "${DST_FILE}" || die "${DST_FILE} does not exist in chroot and a dummy file to bind to could not be created"
  fi

  chroot_add_mount "${SRC_FILE}" "${DST_FILE}" --bind
}

# path variables
dir_vardbrepos="/var/db/repos"
dir_vardbgentoo="/var/db/repos/gentoo"
dir_binpkgs="/var/cache/binpkgs"
dir_distfiles="/var/cache/distfiles"
dir_usrclinux="/usr/src/linux"
file_makeconf="/etc/portage/make.conf"
file_reposconf="/etc/portage/repos.conf"
file_resolvconf="/etc/resolv.conf"
gentoo_bashrc="/tmp/gentoo-bashrc"

# main - the core program
gentoo-chroot() {
  local CHROOT_FILES=( )
  # required preliminary checks
  (( EUID == 0 )) || die "This script must be run with root privileges"
  [[ -d $CHROOT_DIR ]] || die "Can't create chroot on non-directory %s" "$CHROOT_DIR"

  # bind mount to itself now. must come before chroot_setup and subsequent check
  if ! mountpoint -q "$CHROOT_DIR"; then
      warning "$CHROOT_DIR is not a mountpoint, and causes undesirable side effects."
      msg2 "Fixing! Bind Mounting ${CHROOT_DIR} to itself for you ..."
      realchrootdir=$(realpath "${CHROOT_DIR}")
      mount --bind "${realchrootdir}" "${realchrootdir}"   #TODO: what about errors?
      #on exit, does an umount lazy in chroot_teardown() function
  fi

  # actually do setup of chroot (ALL basic mounts)
  chroot_setup "$CHROOT_DIR" || die "failed to setup chroot %s" "$CHROOT_DIR"

  # warn if somehow its still not mounted, NonFatal?
  #these warnings can be deprecated soon or at some point later, soon.
  if ! mountpoint -q "$CHROOT_DIR"; then
    warning "$CHROOT_DIR is not a mountpoint. This has undesirable side effects."
    warning "-Tip, you can bind mount the directory on itself to make it a mountpoint:"
    warning " 'mount --bind /your/chroot /your/chroot'   (as a workaround)"
	warning "#DONE#TODO#: can bind-mount itself to itself in the script now instead of leaving it to the user"
  fi

  # DNS Resolver, always use host's /etc/resolv.conf for network DNS nameserver settings 	[ALWAYS]
  #TODO: make optional
  #   -R | --no-bind-resolvconf | NO_MOUNT_RESOLVCONF /etc/resolv.conf
#  CHROOT_FILES+=( "${file_resolvconf}" )

  # .bashrc - Create new bashrc which does useful gentoo functions like env-update and setting $PS1=(chroot)
  if [[ -z ${NO_MOUNT_BASHRC+x} ]]; then
    #only populates this file in /tmp once, (caveat: when editing this script, rm /tmp/gentoo-bashrc)
	if [[ ! -r ${gentoo_bashrc} ]]; then
		cat > ${gentoo_bashrc} <<EOF
#!/usr/bin/env bash
source /etc/profile && env-update
export PS1="(gentoo-chroot) \$PS1"
EOF
	fi				#^ backslash to escape the $ so it doesnt expand the variable
    CHROOT_FILES+=( "${gentoo_bashrc}:/root/.bashrc" ) # map .bashrc to /root, inside the chroot
  fi

  # Kernel Source dir, '-k', /usr/src/linux, Kernels can be shared (caveat: may need make clean) [DEFAULT]
  if [[ -z ${NO_MOUNT_KERNEL_SOURCE+x} ]] && [[ -d "${dir_usrclinux}" ]]; then
    if [[ ! -d "${CHROOT_DIR}${dir_usrclinux}" ]]; then
        if [[ -e "${CHROOT_DIR}${dir_usrclinux}" && ! -s "${CHROOT_DIR}${dir_usrclinux}" ]]; then
            warning "Empty Blocker file found for ./usr/src/linux , Deleting."
            rm "${CHROOT_DIR}${dir_usrclinux}"
        fi
        msg "Creating blank dir for mountpoint! Binding now."
        mkdir -p "${CHROOT_DIR}${dir_usrclinux}"
    fi
    if [[ -d "${CHROOT_DIR}${dir_usrclinux}" ]]; then
        msg "Binding $dir_usrclinux now."
        chroot_bind_device $dir_usrclinux "${CHROOT_DIR}${dir_usrclinux}"
    else
        warning "Kernel usr/src/linux directory/symlink still has issues. not bound yet."
    fi
  fi

#GENTOO SPECIFIC:
#
  # Make.conf, '-m', re-use the host system's /etc/portage/make.conf     (optional)
  if [[ -n ${MOUNT_MAKECONF+x} ]]; then
    CHROOT_FILES+=( "${file_makeconf}" )
  fi

  # Repos, '-r', Portage repos config, /etc/portage/repos.conf           (optional)
  #         Third Party Portage Repos, /var/db/repos/*/        (optional 3rd party)
  if [[ -n ${MOUNT_HOSTREPOS+x} ]]; then
    chroot_bind_device $file_reposconf "${CHROOT_DIR}${file_reposconf}"
    chroot_bind_device $dir_vardbrepos "${CHROOT_DIR}${dir_vardbrepos}"
  # ::Gentoo Main Repo, 			   /var/db/repos/gentoo/			 [DEFAULT]
  else
    # A fresh stage3 may not have it, so create/bind it in new
    if [[ ! -d "${CHROOT_DIR}${dir_vardbgentoo}" ]]; then
      ignore_error rm "${CHROOT_DIR}${dir_vardbgentoo}"
      mkdir -p "${CHROOT_DIR}${dir_vardbgentoo}"
    fi
    chroot_bind_device $dir_vardbgentoo "${CHROOT_DIR}${dir_vardbgentoo}"
  fi

  # Distfiles, '-f', /var/cache/distfiles, cache avoids network downloads [DEFAULT]
  if [[ -z ${NO_MOUNT_DISTFILES+x} ]]; then
    chroot_bind_device $dir_distfiles "${CHROOT_DIR}${dir_distfiles}"
  fi

  # Binpkgs, '-b', /var/cache/binpkgs,  carry over from the host         (optional)
  if [[ -n ${MOUNT_BINPKGS+x} ]] && [[ -d "${dir_binpkgs}" ]]; then
    chroot_bind_device $dir_binpkgs "${CHROOT_DIR}${dir_binpkgs}"
  fi

  #User Extendable Additional Files, 									 (optional)
  # The user can provide this env var, a list of arbitrary files to mount
  if (( ${#ADDITIONAL_CHROOT_FILES[@]} )); then
    CHROOT_FILES+=( "${ADDITIONAL_CHROOT_FILES}" )
  fi
  for FILE in "${CHROOT_FILES[@]}"; do
      chroot_add_file "${FILE}" || die "failed to setup ${FILE}"
  done

#CHROOT:
  # Run it!
  CHROOT_ARGS=()
  [[ $USERSPEC ]] && CHROOT_ARGS+=(--userspec "$USERSPEC")
  # If arguments = 0, run a shell
  if [ ${#ARGS[@]} -eq 0 ]; then
    SHELL=/bin/bash chroot "${CHROOT_ARGS[@]}" -- "$CHROOT_DIR"
  else
  # else run the command specified in the @ARGS ($* expands args to string with IFS) #shellcheck disable=SC2145
    chroot "${CHROOT_ARGS[@]}" -- "$CHROOT_DIR" /bin/bash -c "source /etc/profile && env-update && $*"
  fi
}

#argument parsing
PARSED_ARGS=$(getopt -a -n "${0##*/}" -o bfdhkmnNru: --long bind-binpkgs,no-bind-distfiles,debug,help,no-bind-kernel,bind-makeconf,no-bind-bashrc,bind-hostrepos,user: -- "$@")
eval set -- "$PARSED_ARGS"
while :
do
  case "$1" in
    -b | --bind-binpkgs ) MOUNT_BINPKGS=1 ; shift ;;
    -f | --no-bind-distfiles ) NO_MOUNT_DISTFILES=1 ; shift ;;
    -d | --debug ) DEBUG=1; echo -e "\e[1;35mEnabling very-basic debug!\e[0m"; set -x; shift ;;
    -h | --help )  usage "Help" ;;
    -k | --no-bind-kernel) NO_MOUNT_KERNEL_SOURCE=1; shift ;;
    -m | --bind-makeconf ) MOUNT_MAKECONF=1 ; shift ;;
    -n | --no-bind-bashrc ) NO_MOUNT_BASHRC=1 ; shift ;;
    -r | --bind-hostrepos ) MOUNT_HOSTREPOS=1 ; shift ;;
    -u | --user )  USERSPEC="${2}"; shift 2 ;;
    -- ) shift ; break ;;
  esac
done

#executable Boilerplate
if [[ $# -eq 0 ]]; then
  usage "Missing parameter - please specify a chroot directory!"
fi

#argument handling
CHROOT_DIR=$1
shift
ARGS=("$@")

#run script, main function
gentoo-chroot
