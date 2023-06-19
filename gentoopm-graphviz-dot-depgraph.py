#!/usr/bin/env python

import re

import gentoopm
from gentoopm.basepm.atom import PMAtom


pm = gentoopm.get_package_manager()
r = pm.repositories["gentoo"]

usedep_re = re.compile(r"\[(.*)\]")

nodes = set()
edges = set()

for i, pkg in enumerate(r):
    for f in pkg.use:
        if f.startswith("abi_"):
            break
    else:
        continue

    key = str(pkg.key)
    nodes.add(key)
    
    def process_deps(depset):
        for d in depset:
            if isinstance(d, PMAtom):
                for usedep in usedep_re.finditer(str(d)):
                    for flag in usedep.group(1).split(","):
                        if flag.startswith("abi_"):
                            yield str(d.key)
            else:
                yield from process_deps(d)

    deps = set()
    for dg in (pkg.run_dependencies, pkg.post_dependencies,
               pkg.build_dependencies, pkg.cbuild_build_dependencies):
        deps.update(process_deps(dg))
    for dep in deps:
        edges.add((key, dep))


print("digraph {")
print("\trankdir=LR;")
for n in sorted(nodes):
    print(f"\t\"{n}\";")
for beg, end in sorted(edges):
    print(f"\t\"{beg}\" -> \"{end}\";")
print("}")
