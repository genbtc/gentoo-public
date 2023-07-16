#!/bin/bash
allflags() {
/usr/bin/env python3 - <<EOF
import portage
cpv = portage.db["/"]["vartree"].dbapi.cpv_all()
for d in cpv:
    u = portage.db["/"]["vartree"].dbapi.aux_get(d, ['PKGUSE'])
    for e in u:
       print(e)
EOF
}
allflags | sed 's/\s/\n/g' | sed 's/\+//' | sort | uniq
