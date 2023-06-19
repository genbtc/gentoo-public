#!/usr/bin/env python3
import gentoopm
pm = gentoopm.get_package_manager()
pkgs = pm.installed
for i, p in enumerate(pkgs):
    print("i",i,"p",p)