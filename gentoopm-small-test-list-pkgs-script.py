#!/usr/bin/env python

import sys, portage
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("-i", "--installed-only", action="store_true")
parser.add_argument("-v", "--versions", action="store_true")
args = parser.parse_args(sys.argv[1:])

portdb = portage.db[portage.root]["porttree"].dbapi
vardb = portage.db[portage.root]["vartree"].dbapi

if args.installed_only:
    db = vardb
else:
    db = portdb

packages = {}

for cpv in db.cpv_all():
    repo = db.aux_get(cpv, ["repository"])[0]
    catpkg, ver, rev = portage.pkgsplit(cpv)
    key = f"{catpkg}::{repo}"
    if key in packages.keys():
        if ver not in packages[key]:
            packages[key].append(ver)
    else:
        packages[key] = [ver]

for catpkg, vers in packages.items():
    buff = catpkg
    if args.versions:
        buff += " "
        buff += " ".join(v for v in vers)
    print(buff)
