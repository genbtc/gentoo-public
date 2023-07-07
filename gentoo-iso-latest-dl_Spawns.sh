#!/bin/bash
# 2023 Spawns_Carpeting @gentoo - v0.21

source /lib/gentoo/functions.sh

bouncer='https://bouncer.gentoo.org/'
gentoo_release='/usr/share/openpgp-keys/gentoo-release.asc'
isos="${HOME}/iso/gentoo/downloads"

die() {
    local ret="${1}"
    shift
    eend "${ret}" "$@"
    [[ ${ret} -ne 0 ]] && exit "${ret}"
}

_wget() {
    wget \
        ${REFRESH_WGET_OPTS} \
        --quiet \
        "$@"
}

retry() {
    _wget \
        ${RETRY_WGET_OPTS} \
        --show-progress \
        --continue \
        --retry-connrefused \
        --retry-on-http-error=404 \
        --waitretry=1 \
        "$@"
}

parse_latest_txt() {
    grep '^[^#]' | cut -d ' ' -f 1 | cut -d '/' -f 2
}

file="${1}"
if [[ -z ${file} ]]; then
    echo "expected 1 argument" > /dev/stderr
    exit 1
elif [[ ${file} = "-h" || ${file} = "--help" ]]; then
    echo "pass the file you want to refresh as the first argument" > /dev/stderr
    echo "examples:" > /dev/stderr
    echo '  refresh.sh install-amd64-minimal' > /dev/stderr
    echo '  refresh.sh livegui-amd64' > /dev/stderr
    echo '  refresh.sh stage3-amd64-openrc' > /dev/stderr
    exit 1
fi

pushd "${isos}"

arch=$(cut -d '-' -f 2 <<<${file})
directory="/fetch/root/all/releases/${arch}/autobuilds"

echo
ebegin "Fetching latest-${file}.txt ...\n"
_wget "${bouncer}/${directory}/latest-${file}.txt"
die $? "failed to fetch ${latest-${file}.txt}"
latest=$(< "latest-${file}.txt" parse_latest_txt)
rm "latest-${file}.txt"
einfo "parsed ${latest} from latest-${file}.txt"

echo
ebegin "Fetching signature for ${file} ...\n"
retry "${bouncer}/${directory}/current-${1}/${latest}.asc"
die $? "failed to fetch ${latest}.asc"

echo
ebegin "Fetching ISO ${latest} ...\n"
retry "${bouncer}/${directory}/current-${1}/${latest}"
die $? "failed to fetch ${latest}"

echo
ebegin "Verifying signature for ${latest}\n"
gemato gpg-wrap -K ${gentoo_release} -R -- gpg --verify "${latest}.asc" "${latest}"
verified=$?
die ${verified}

