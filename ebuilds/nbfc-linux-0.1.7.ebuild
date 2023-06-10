# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12} )

inherit autotools linux-info

DESCRIPTION="NoteBook FanControl"
HOMEPAGE="https://github.com/nbfc-linux/nbfc-linux"
SRC_URI="https://github.com/nbfc-linux/nbfc-linux/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64"
SLOT="0"
IUSE=""

RDEPEND="sys-apps/lmsensors
         sys-apps/dmidecode
        "
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( README.md LICENSE )

pkg_setup() {
    local CONFIG_CHECK=" \
        ~CONFIG_CROS_EC_SYSFS \
        ~CONFIG_ACPI_EC_DEBUGFS \
    "
#    linux-info_pkg_setup   #uncomment when modules are confirmed required
}

src_prepare() {
    default
    #NOTE: Arch uses usr/local and merged-usr for etc . install dirs may need tweaking
    sed -i -e "s:PREFIX   = /usr/local:PREFIX   = ${EPREFIX}/usr:" Makefile || die
    sed -i -e 's:confdir  = $(PREFIX)/etc:confdir  = /etc:' Makefile || die
}

src_install() {
    default
    keepdir /etc/nbfc
}

#NOTES:
#System service : systemd script provided (etc/systemd/system/ dir) -  but no openrc
#auto-completion: bash zsh fish (completion/ dir)
#XML: how is it reading the (XML/ dir) files
