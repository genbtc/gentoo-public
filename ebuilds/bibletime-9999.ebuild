# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="https://bibletime.info/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/bibletime/bibletime.git"
	inherit git-r3
else
    SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
	S="${WORKDIR}/${PN}-v${PV}"
    KEYWORDS="amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND=">=app-text/sword-1.8.1[curl,icu]
	dev-cpp/clucene:1
	dev-qt/qtcore:5
	dev-qt/qtgui:5
    dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
    dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
    dev-qt/qtdeclarative:5
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-qt/qttest:5
"
BDEPEND="dev-qt/linguist-tools:5
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		app-text/po4a
		dev-libs/libxslt
	)
"

DOCS=( README.md )

src_prepare() {
	cmake_src_prepare

	sed -e "s:Dictionary;Qt:Dictionary;Office;TextTools;Utility;Qt:" \
		-i cmake/platforms/linux/bibletime.desktop.cmake || die "fixing .desktop file failed"
}

# TODO: FOO_HTML_LANGUAGES. Current lists for "all languages":
# handbook: ar br cs de en es fi fr hu it ko lt nl pt_BR ru th uk
# howto: ar bg br cs da de en es fi fr hu it ja ko lt nl pt_BR ru th uk
src_configure() {
	local mycmakeargs=(
		-DBUILD_HANDBOOK_HTML=$(usex doc)
		-DBUILD_HANDBOOK_PDF=no
		-DBUILD_HOWTO_HTML=$(usex doc)
		-DBUILD_HOWTO_PDF=no
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
    xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
    xdg_desktop_database_update
}
