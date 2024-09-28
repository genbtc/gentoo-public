#!/bin/bash
# portage-bootstrap.sh , v0.3 - From https://wiki.gentoo.org/wiki/User:Spawns/Bootstrap_with_emerge
if [[ -z ${1} ]]; then
    printf "Usage: $0 [target dir]\n"
    printf -- "--- no Target Directory specified!\n"
fi

echo ">>> Bootstrap Prepare..."

BASEDIR="/mnt/VM1"
export TARGETDIR=${1:-$BASEDIR}
echo ">>> Target Directory        = $TARGETDIR"

export ROOT=${TARGETDIR}/gentoo
echo ">>> Target Directory + ROOT = $ROOT"

export PORTAGE_CONFIGROOT=${ROOT}
export PORTAGE_TMPDIR=${ROOT}/var/tmp

export EMERGE_LOG_DIR=${ROOT}/var/log
export PORTAGE_LOGDIR=${EMERGE_LOG_DIR}/portage

export DISTDIR=${ROOT}/var/cache/distfiles
export RO_DISTDIRs=$(portageq envvar DISTDIR)

export USE=$(portageq envvar BOOTSTRAP_USE)
export FEATURES='-userpriv -usersync -userfetch'

echo ">>> Bootstrap Done!!! <<<"
