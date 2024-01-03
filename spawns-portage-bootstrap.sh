#!/bin/sh
# portage-bootstrap.txt , v0.2 - From https://wiki.gentoo.org/wiki/User:Spawns/Bootstrap_with_emerge

export TARGETDIR="/mnt/VM1"
export ROOT=${TARGETDIR}/gentoo
export PORTAGE_LOGDIR=${ROOT}/var/log/portage
export EMERGE_LOG_DIR=${ROOT}/var/log/

export USE=$(portageq envvar BOOTSTRAP_USE)
export PORTAGE_CONFIGROOT=${ROOT}
export PORTAGE_TMPDIR=${ROOT}/var/tmp/
export DISTDIR=${ROOT}/var/cache/distfiles
export RO_DISTDIRs=$(portageq envvar DISTDIR)

export FEATURES='-userpriv -usersync -userfetch'
