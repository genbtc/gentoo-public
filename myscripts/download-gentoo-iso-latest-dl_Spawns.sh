#!/bin/bash
# 2023 Spawns_Carpeting @gentoo - v0.6
#Requires gentoo functions & gemato, gpg, wget

usage() {
    echo "Usage: the target you want to download/refresh is the first argument" >&2
    echo "examples:" >&2
    echo "  ${0} install-amd64-minimal" >&2
    echo "  ${0} livegui-amd64" >&2
    echo "  ${0} stage3-amd64-openrc" >&2
    echo "  ${0} stage3-amd64-hardened-nomultilib-selinux-openrc" >&2
}

file="${1}"
if [[ -z ${file} ]]; then
    echo "Usage Error: expected 1 argument, see --help" >&2
	usage && exit 1
elif [[ ${file} = "-h" || ${file} = "--help" ]]; then
	usage && exit 0
fi

#shellcheck disable=SC1091 #if file is not available, we have issues.
if [ -e /lib/gentoo/functions.sh ]; then
	source /lib/gentoo/functions.sh || exit 9
fi

#Hardcoded my primary fast mirror:
GENTOO_MIRRORS="${GENTOO_MIRRORS:=https://mirrors.rit.edu/gentoo/}"
#comment out the above line ^^^, to fall back to Bouncer mirror (below)
bouncer="${GENTOO_MIRRORS:=https://bouncer.gentoo.org/fetch/root/all/}"
gentoo_release='/usr/share/openpgp-keys/gentoo-release.asc'

arch=$(cut -d '-' -f 2 <<< "${file}")
directory="releases/${arch}/autobuilds"

die() {
    local ret="${1}"
    shift
    eend "${ret}" "$@"
    [[ ${ret} -ne 0 ]] && exit "${ret}"
}

_wget() {
#shellcheck disable=SC2086
    wget ${REFRESH_WGET_OPTS} \
        --quiet \
        "$@"
}

wgetretry() {
#shellcheck disable=SC2086
    _wget ${RETRY_WGET_OPTS} \
        --show-progress \
        --continue \
        --retry-connrefused \
        --retry-on-http-error=404 \
        --waitretry=1 \
        "$@"
}

parse_latest_txt() {
    sed -n '6p' | grep '^[^#]' | cut -d ' ' -f 1 | cut -d '/' -f 2
}

echo
ebegin "Fetching latest-${file}.txt ...\n"
_wget "${bouncer}/${directory}/latest-${file}.txt"
die $? "failed to fetch ${latest-${file}.txt}"

echo
latest=$(< "latest-${file}.txt" parse_latest_txt)
ebegin "Parsed file latest-${file}.txt - most recent stage is ${latest}\n"
rm "latest-${file}.txt"

echo
ebegin "Fetching signature .asc for ${file} ...\n"
wgetretry "${bouncer}/${directory}/current-${file}/${latest}.asc"
die $? "failed to fetch ${latest}.asc"

echo
ebegin "Downloading latest release autobuild ${latest} ...\n"
wgetretry "${bouncer}/${directory}/current-${file}/${latest}"
die $? "failed to fetch ${latest}"

echo
ebegin "Verifying signature of release ${latest}\n"
gemato gpg-wrap -K ${gentoo_release} -R -- gpg --verify "${latest}.asc" "${latest}"
die $? "failed to verify! ${latest}"
