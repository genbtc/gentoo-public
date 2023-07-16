#!/bin/bash
#v0.2 script by genr8eofl @ gentoo 2023 - AGPL3
allflags() {
/usr/bin/env python3 - <<EOF
import portage
cpv = portage.db["/"]["vartree"].dbapi.cpv_all()
for pvr in cpv:
    use = portage.db["/"]["vartree"].dbapi.aux_get(pvr, ['PKGUSE'])
    if '' not in use:
        print(pvr, ' '.join(use))
EOF
}
allflags
