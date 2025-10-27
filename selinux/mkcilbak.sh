#!/bin/sh
#genr8eofl (2023) July 25, LICENSE @AGPL3
SELDIR="/etc/selinux/strict/"
CILDATE="111224"    #increment before running,

mkdir -p ${SELDIR}/cil.bak.${CILDATE}/
pushd /var/lib/selinux/strict/active/modules/400
for F in $(find . -name 'cil'); do
    D=$(dirname $F);
    cp $F ${SELDIR}/cil.bak.${CILDATE}/$D;
done
popd
