# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="https://bibletime.info/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~amd64"
# only locales with handbook+howto
PLOCALES=( ar br cs de es en fi fr hu it ko lt nl pt_BR th )
IUSE="doc ${PLOCALES[@]/#/l10n_}"

RDEPEND="
	>=app-text/sword-1.8.1[curl,icu]
	dev-cpp/clucene:1
	dev-qt/qtbase:6[gui,widgets,xml]
	dev-qt/qtdeclarative:6"
DEPEND="${RDEPEND}
	dev-libs/boost"
BDEPEND="
	dev-qt/qttools:6[linguist]
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		app-text/po4a
		dev-libs/libxslt
	)"
#PATCHES=( )
#DOCS=( ChangeLog README.md )
DOCS=( README.md )

src_prepare() {
	cmake_src_prepare

	sed -e "s:Dictionary;Qt:Dictionary;Office;TextTools;Utility;Qt:" \
		-i cmake/platforms/linux/bibletime.desktop.cmake || die "fixing .desktop file failed"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_HANDBOOK_HTML=$(usex doc)
		-DBUILD_HANDBOOK_PDF=no
		-DBUILD_HOWTO_HTML=$(usex doc)
		-DBUILD_HOWTO_PDF=no
		-DUSE_QT6=ON
	)
	if use doc; then
		for LANG in ${PLOCALES[@]}; do
			if use l10n_${LANG}; then
				local languages+="${LANG};"
			fi
		done
		mycmakeargs+=(
			-DBUILD_HANDBOOK_HTML_LANGUAGES="${languages[@]%;}"
			-DBUILD_HOWTO_HTML_LANGUAGES="${languages[@]%;}"
		)
	fi
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
