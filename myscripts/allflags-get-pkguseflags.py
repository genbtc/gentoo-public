#!/bin/bash
#v0.2 script by genr8eofl @ gentoo 2023 - AGPL3
allflags() {
/usr/bin/env python3 - <<EOF
import portage
cpv = portage.db["/"]["vartree"].dbapi.cpv_all()
for d in cpv:
    u = portage.db["/"]["vartree"].dbapi.aux_get(d, ['PKGUSE'])
    if '' not in u:
        print(d, ' '.join(u))
EOF
}
allflags
