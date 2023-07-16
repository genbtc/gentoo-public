#!/usr/bin/python3.9
#
# Copyright(c) 2006, Chris PeBenito <pebenito@gentoo.org>
# Copyright(c) 2006, Gentoo Foundation
#
# Portage query code derived from gentoolkit:
# Copyright(c) 2004, Gentoo Foundation
# Copyright(c) 2004, Karl Trygve Kalleberg <karltk@gentoo.org>
#
# Licensed under the GNU General Public License, v2
#
# $Header: /var/cvsroot/gentoo-projects/hardened/policycoreutils-extra/scripts/rlpkg,v 1.11 2009/08/02 01:20:32 pebenito Exp $
#
# Source taken from rlpkg (policycoreutils)
# Modified by genBTC @ November 3rd 2021 - Version 0.0.1

import os
import sys
import string
import getopt
import selinux
import portage
import subprocess

settings = portage.config(clone=portage.settings)

class Package:
    """Package descriptor. Contains convenience functions for querying the
    state of a package, its contents, name manipulation, ebuild info and
    similar."""

    def __init__(self, cpv):
        self._cpv = cpv
        self._scpv = portage.catpkgsplit(self._cpv)

        if not self._scpv:
            raise RuntimeError("invalid cpv: %s" % cpv)
        self._db = None
        self._settings = settings

    def get_cpv(self):
        """Returns full Category/Package-Version string"""
        return self._cpv

    def get_name(self):
        """Returns base name of package, no category nor version"""
        return self._scpv[1]

    def get_version(self):
        """Returns version of package, with revision number"""
        v = self._scpv[2]
        if self._scpv[3] != "r0":
            v += "-" + self._scpv[3]
        return v

    def get_category(self):
        """Returns category of package"""
        return self._scpv[0]

    def is_installed(self):
        """Returns true if this package is installed (merged)"""
        self._initdb()
        return os.path.exists(self._db.getpath())

    def get_contents(self):
        """Returns the full contents, as a dictionary, on the form
        [ '/bin/foo' : [ 'obj', '1052505381', '45ca8b8975d5094cd75bdc61e9933691' ], ... ]"""
        self._initdb()
        if self.is_installed():
            return self._db.getcontents()
        return {}

    def _initdb(self):
        """Internal helper function; loads package information from disk,
        when necessary"""
        if not self._db:
            cat = self.get_category()
            pnv = self.get_name() + "-" + self.get_version()
            self._db = portage.dblink(cat, pnv, "/", settings)


def find_installed_packages(search_key):
    """Returns a list of Package objects that matched the search key."""
    try:
        if search_key=="*":
            t = portage.db["/"]["vartree"].dbapi.cpv_all()
        else:
            t = portage.db["/"]["vartree"].dbapi.match(search_key)
    # catch the "ambiguous package" Exception
    except ValueError as e:
        if type(e[0]) == list:
            t = []
            for cp in e[0]:
                t += portage.db["/"]["vartree"].dbapi.match(cp)
        else:
            raise ValueError(e)
    return [Package(x) for x in t]


def get_packages(packages, verbose):
    """get specified packages"""
    # build package list
    pkglist = []
    for pkgname in packages:
        pkglist += find_installed_packages(pkgname)

    if len(pkglist) == 0:
        print("No packages found by that string")
        sys.exit(1)

    for i in pkglist:
        if verbose:
            print("\n>Package: %s" % i.get_cpv())
        for j in i.get_contents().keys():
            print(j)

def usage(message=""):
    pgmname = os.path.basename(sys.argv[0])

    print("Usage: %s [OPTIONS] {<pkg1> [<pkg2> ...]}" % pgmname)
    print("")
    print("  -a, --all      Scan ALL installed packages instead of individual packages.")
    print("  -v, --verbose  Enable more verbose output (package name headers)")
    print("  -h, --help     Display this help and exit")
    print("")
    print("Packages can be specified with a portage package atom specification, for example,")
    print('"policycoreutils" or ">=sys-apps/policycoreutils-1.30".')
    print("")

    if message != "":
        print('%s: %s' % (pgmname, message))
        sys.exit(1)
    else:
        sys.exit(0)


def main():
    verbose = False
    all = False

    if len(sys.argv) < 2:
        usage("At least one argument required.")

    try:
        opts, packages = getopt.getopt(sys.argv[1:], "ahv", ["all", "help", "verbose"])
    except getopt.GetoptError as error:
        usage(error.msg)

    for o, a in opts:
        if o in ("-a", "--all"):
            packages = "*"
        if o in ("-h", "--help"):
            usage()
        if o in ("-v", "--verbose"):
            verbose = True

    if len(packages) == 0 and all == False:
        usage("No packages specified.")

    get_packages(packages, verbose)

    sys.exit()

if __name__ == "__main__":
    main()
