#!/usr/bin/python3
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
# Source taken from rlpkg (policycoreutils)
#
# Modified by genBTC @ November 3rd 2021 - Version 0.0.1
# Created Stub Version of this style program - Jan 2024 Version 0.1.0

import os
import sys
import getopt

def usage(message=""):
    progname = os.path.basename(sys.argv[0])

    print("Usage: %s [OPTIONS] {<arg1> [<arg2> ...]}" % progname)
    print("")
    print("  -a, --all      ALL")
    print("  -v, --verbose  Enable more verbose output")
    print("  -h, --help     Display this help and exit")
    print("")

    if message != "":
        print('%s: %s' % (progname, message))
        sys.exit(1)
    else:
        sys.exit(0)


def main():
    verbose = False
    all = False

    if len(sys.argv) < 2:
        usage("At least one argument required.")

    try:
        opts, cmdlineargs = getopt.getopt(sys.argv[1:], "ahv", ["all", "help", "verbose"])
    except getopt.GetoptError as error:
        usage(error.msg)

    for o, a in opts:
        if o in ("-a", "--all"):
            cmdlineargs = "*"
        if o in ("-h", "--help"):
            usage()
        if o in ("-v", "--verbose"):
            verbose = True

    if len(cmdlineargs) == 0 and all == False:
        usage("No args specified.")
    else:
        print("args : %s" % cmdlineargs)

    #run main loop

    sys.exit()

if __name__ == "__main__":
    main()
