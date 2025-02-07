# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module

MY_COMMIT="0bf4b8031cbeffc0347007d85647062953e90571"
DESCRIPTION="Tags files for access via a nifty virtual filesystem from any application"
HOMEPAGE="https://github.com/oniony/TMSU"
SRC_URI="https://github.com/oniony/TMSU/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S="${WORKDIR}"/${PN^^}-${MY_COMMIT}

# COPYING.md
LICENSE="GPL-3 BSD MIT"
SLOT="0"
KEYWORDS="amd64"

src_prepare() {
	default

	# Don't try to compress man pages
	sed -i -e '/gzip.*\.1/d' Makefile || die
}

src_install() {
	emake DESTDIR="${ED}" BASH_COMP_INSTALL_DIR="\$(DESTDIR)/$(get_bashcompdir)" install
	doman misc/man/tmsu.1
}
