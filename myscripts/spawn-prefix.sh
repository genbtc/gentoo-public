#!/bin/bash
# spawn-prefix.sh - v0.2 - by @genr8eofl copyright 2023 - AGPL3 License
#                   v0.1 - originally from SpawnsCarpeting

export ROOT=$(realpath "${1}")
export PORTAGE_TMPDIR="${ROOT}/var/tmp"
export PORTAGE_LOGDIR="${ROOT}/var/log/portage"
export EMERGE_LOG_DIR="${ROOT}/var/log"
export FEATURES="-news -userpriv -userfetch -usersync"

emerge -v1 app-misc/hello
