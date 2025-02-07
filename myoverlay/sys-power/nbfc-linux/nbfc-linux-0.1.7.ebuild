# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

PYTHON_COMPAT=( python3_{9..12} )

DESCRIPTION="NoteBook FanControl"
HOMEPAGE="https://github.com/nbfc-linux/nbfc-linux"
SRC_URI="https://github.com/nbfc-linux/nbfc-linux/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64"
SLOT="0"

RDEPEND="sys-apps/lm-sensors
         sys-apps/dmidecode
        "
DEPEND="${RDEPEND}"

pkg_setup() {
    local CONFIG_CHECK=" \
        ~CONFIG_CROS_EC_SYSFS \
        ~CONFIG_ACPI_EC_DEBUGFS \
    "
#    linux-info_pkg_setup   #uncomment this when modules are confirmed required
}

src_prepare() {
    default
    #NOTE: Arch uses usr/local and merged-usr for etc . install dirs may need tweaking
    sed -i -e "s:PREFIX   = /usr/local:PREFIX   = ${EPREFIX}/usr:" Makefile || die
    sed -i -e 's:confdir  = $(PREFIX)/etc:confdir  = /etc:' Makefile || die
}

src_install() {
    default
    keepdir /etc/nbfc       #Blank dir needs to be kept
}

#NOTES:
#System service : systemd script provided (etc/systemd/system/ dir) -  but no openrc
#auto-completion: bash zsh fish (completion/ dir)
#XML: how is it reading the (XML/ dir) files?
