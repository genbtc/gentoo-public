#!/bin/bash

export ROOT=$(realpath "${1}")
export PORTAGE_TMPDIR="${ROOT}/var/tmp"
export PORTAGE_LOGDIR="${ROOT}/var/log/portage"
export EMERGE_LOG_DIR="${ROOT}/var/log"
export FEATURES="-news -userpriv -userfetch -usersync"

emerge black
