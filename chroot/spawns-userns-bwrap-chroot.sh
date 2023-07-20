#!/bin/bash
#2023 Spawns_Carpeting

info=$(mktemp -u)
userns=$(mktemp -u)

mkfifo ${info}
mkfifo ${userns}

(
    exec {info_fd}<${info}
    exec {userns_fd}>${userns}
    rm ${info} ${userns}
    pid=$(<&${info_fd} jq '."child-pid"')
    newuidmap \
        ${pid} \
        0 1000 1 \
        1 100000 65535
    newgidmap \
        ${pid} \
        0 1000 1 1 \
        100000 65535
    echo 1 >&${userns_fd}
) &

exec {info_fd}>${info}
exec {userns_fd}<${userns}

exec bwrap \
     --unshare-all \
     --unshare-user \
     --info-fd ${info_fd} \
     --userns-block-fd ${userns_fd} \
     --clearenv \
     --dev /dev \
     --proc /proc \
     --tmpfs /run \
     --perms 1777 \
     --tmpfs /tmp \
     --bind ${ROOT}/bin /bin \
     --bind ${ROOT}/sbin /sbin \
     --bind ${ROOT}/lib /lib \
     --bind ${ROOT}/lib64 /lib64 \
     --bind ${ROOT}/usr /usr \
     --bind ${ROOT}/etc /etc \
     --bind ${ROOT}/var /var \
     --bind /sys /sys \
     --ro-bind /var/db/repos/gentoo /var/db/repos/gentoo \
     --ro-bind /var/cache/distfiles /var/cache/distfiles \
     "$@"
