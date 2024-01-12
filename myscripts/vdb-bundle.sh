#!/bin/bash
# vd-bundle.sh script v0.1 - created by genr8eofl @ gentoo - Jan 3, 2024 - AGPL3
vdb=$(portageq vdb_path / )
tar czv --exclude='*environment.bz2' --exclude='*.ebuild' --exclude='CONTENTS' -f var-db-pkg-no-envbz2-no-ebuild-no-CONTENTS.tar.gz ${vdb}
