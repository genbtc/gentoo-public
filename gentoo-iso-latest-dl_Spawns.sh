#!/bin/bash

bouncer='https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds'
gentoo_release='/usr/share/openpgp-keys/gentoo-release.asc'
isos="${HOME}/iso/gentoo/downloads"

source /lib/gentoo/functions.sh

die() {
    echo $@
    edie 1
}

_wget() {
    wget --quiet --show-progress $@
}

retry() {
    local tries=$1
    local backoff=1
    shift
    while [[ ${tries} -gt 0 ]]; do
        _wget --continue $@ && return 0
        eerror "failure during download, sleeping for ${backoff} until next retry"
        sleep ${backoff}
        [[ ${backoff} -lt 32 ]] && backoff=$((${backoff} * 2))
    done
}

parse_latest_txt() {
    grep '^[^#]' | cut -d ' ' -f 1 | cut -d '/' -f 2
}

file="${1}"
if [[ -z ${file} ]]; then
    echo "expected 1 argument" > /dev/stderr
    exit 1
fi

pushd "${isos}"

ebegin "fetching latest-${file}.txt\n"
_wget "${bouncer}/latest-${file}.txt" || die "failed to fetch ${latest-${file}.txt}"
latest=$(< "latest-${file}.txt" parse_latest_txt)
einfo "parsed ${latest} from latest-${file}.txt"
eend 0

ebegin "fetching signature for ${file}\n"
retry 25 "${bouncer}/current-${1}/${latest}.asc" || die "failed to fetch ${latest}.asc"
eend 0

ebegin "fetching ${latest}\n"
retry 25 "${bouncer}/current-${1}/${latest}" || die "failed to fetch ${latest}"
eend 0

ebegin "verifying signature for ${latest}\n"
gemato gpg-wrap -K ${gentoo_release} -R -- gpg --verify "${latest}.asc" "${latest}"
verified=$?
eend ${verified}
