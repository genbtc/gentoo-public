# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
    GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/eepp/jome.git"
else
	SRC_URI="https://github.com/eepp/jome/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

inherit cmake ${GIT_ECLASS}

DESCRIPTION=" An emoji picker desktop application "
HOMEPAGE="https://github.com/eepp/jome"
LICENSE="MIT"
SLOT="0"
IUSE="+qt5"
REQUIRED_USE="qt5"

DEPEND="
	dev-qt/qtbase[gui,network,widgets]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
BDEPEND="
	>=dev-util/cmake-3.10
	>=dev-libs/boost-1.58
"
src_configure() {
    #/var/tmp/portage/app-i18n/jome-0.5.0/work/jome-0.5.0/jome/jome.cpp:169:34: error: aggregate 'std::array<char, 32> buf' has incomplete type and cannot be defined
    #insert missing include. Fixed in commit 910028a
    sed -i '16i#include <array>' jome/jome.cpp

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	elog "Jome is finished installing 🥴!"
}
