#!/bin/bash
#script v0.1 by @genr8eofl copyright 2023 - AGPL3 License
cd /var/cache/binpkgs
find . -name '*.xpak' -exec echo -n {}" " \; -exec qxpak -xO {} BUILD_TIME \;
