#!/usr/bin/env python

import sys, os
from pathlib import Path
from argparse import ArgumentParser as ArgParser

class Cgroup:

    def __init__(self, name):
        self.name = name
        self.path = Path("/sys/fs/cgroup/") / self.name

    def set_controller(self, controller, value):
        controller = self.path / controller
        controller.write_text(value)
        

parser = ArgParser()
parser.add_argument("cgroup")
subparsers = parser.add_subparsers(dest="action", required=True)

parser_create = subparsers.add_parser("create")
parser_create.add_argument("--cpu-weight")
parser_create.add_argument("--cpu-max")
parser_create.add_argument("--mem-high")
parser_create.add_argument("--mem-max")
parser_create.add_argument("--swap-high")
parser_create.add_argument("--swap-max")
parser_create.add_argument("--io-weight")
parser_create.add_argument("--io-max")

subparsers.add_parser("delete")
subparsers.add_parser("kill")
subparsers.add_parser("freeze")
subparsers.add_parser("unfreeze")

if "--" in sys.argv:
    i = sys.argv.index("--")
    args = parser.parse_args(sys.argv[1:i])
    rest = sys.argv[i+1:]
else:
    args = parser.parse_args()
    rest = []
    
cgroup = Cgroup(args.cgroup)

if args.action == "create":
    if not cgroup.path.is_dir():
        cgroup.path.mkdir()

    if (val := args.cpu_weight) != None:
        cgroup.set_controller("cpu.weight", val)
    if (val := args.cpu_max) != None:
        cgroup.set_controller("cpu.max", val)

    if (val := args.mem_high) != None:
        cgroup.set_controller("memory.high", val)
    if (val := args.mem_max) != None:
        cgroup.set_controller("memory.max", val)

    if (val := args.swap_high) != None:
        cgroup.set_controller("memory.swap.high", val)
    if (val := args.swap_max) != None:
        cgroup.set_controller("memory.swap.max", val)

    if (val := args.io_weight) != None:
        cgroup.set_controller("io.weight", val)
elif args.action == "delete":
    cgroup.path.rmdir()
    sys.exit()
elif args.action == "kill":
    cgroup.set_controller("kill", "1")
    sys.exit()
elif args.action == "freeze":
    cgroup.set_controller("cgroup.freeze", "1")
    sys.exit()
elif args.action == "unfreeze":
    cgroup.set_controller("cgroup.freeze", "0")
    sys.exit()

if args.action == "create" and len(rest) > 0:
    cgroup.set_controller("cgroup.procs", str(os.getpid()))
    os.execvp(rest[0], rest)
