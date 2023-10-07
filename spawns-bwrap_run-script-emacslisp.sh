#!/bin/bash

source /lib/gentoo/functions.sh

bwrap_run() {
    local pipe=$(mktemp -u) bwrapfd status
    mkfifo "${pipe}"
    (
        exec {bwrapfd}>"${pipe}"
        bwrap \
            --unshare-all \
            --die-with-parent \
            --new-session \
            --json-status-fd "${bwrapfd}" \
            --proc /proc \
            --dev /dev \
            --tmpfs /tmp \
            --tmpfs /run \
            --tmpfs ${HOME} \
            --dir /var/ \
            --dir /var/tmp \
            --dir /var/cache \
            --symlink /run /var/run \
            --ro-bind /lib /lib \
            --ro-bind /lib64 lib64 \
            --ro-bind /bin /bin \
            --ro-bind /sbin /sbin \
            --ro-bind /usr /usr \
            --ro-bind /etc /etc \
            --ro-bind /var/db/repos /var/db/repos \
            --ro-bind /var/db/pkg /var/db/pkg \
            --ro-bind /var/lib/portage /var/lib/portage \
            --ro-bind /var/cache/ /var/cache \
            "$@"
    ) &
    status=$(<"${pipe}" jq "select(.\"exit-code\") | .\"exit-code\"")
    if [[ ${status} = [0-9]* ]]; then
        return "${status}"
    else
        return 1
    fi
}

scripts="$(portageq get_repo_path "/" elisp-native-comp)/scripts"

if [[ -z ${1} ]]; then
    eerror 1 "no package specified"
    exit 1
fi

if [[ ${1} != *.ebuild ]]; then
    best=$(portageq best_visible "/" "${1}")
    ebuild=$(equery which "${best}")
else
    ebuild="${1}"
fi

p=$(qatom --format '%{P}' "${ebuild}")
pn=$(qatom --format '%{PN}' "${ebuild}")


export TMPDIR="${TMPDIR:-/tmp}"
export ROOT="${TMPDIR}/${p}"
export PORTAGE_TMPDIR="${ROOT}"
export USE="${USE:-native-compilation}"

ebegin "creating temporary directory ${ROOT}"
mkdir -p "${ROOT}"
eend $? "failed to create temporary directory ${ROOT}"

ebegin "emerging ${p}"
bwrap_run \
    --bind "${ROOT}" "${ROOT}" \
    ebuild "${ebuild}" clean merge
eend $? "failed to merge ${p}" || exit 1


ebegin "running elisp test script for ${p}"
bwrap_run \
    --ro-bind "${ROOT}/usr/share/emacs/site-lisp" "/usr/share/emacs/site-lisp" \
    --ro-bind "${ROOT}/usr/lib64/emacs/gentoo-native-lisp" "/usr/lib64/emacs/gentoo-native-lisp" \
    "${scripts}/test.el" "${pn}"
eend $? "test for ${p} failed" || exit 1

# Local Variables:
# mode: bash-ts
# End:
