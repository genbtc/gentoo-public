# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION=""
HOMEPAGE="http://pdcurses.sourceforge.net/"
LICENSE="public-domain"

MyPN="PDCurses"
MyP="${MyPN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MyP}.tar.gz"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="debug static-libs unicode"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MyP}"

myARCH="${CATEGORY/cross-/}"

src_prepare() {
	eapply -p0 "${FILESDIR}/${PV}-resize-fix.patch"
	sed -i '
		s/\\exp/\/exp/;
		s/del /rm /;
		s/type /cat /;
		s/copy /cp /;
		s/\$?/$? -lgdi32/;
		s/\bar\b/$(AR)/;
		s/\bgcc\b/$(CC)/;
		s/^\([[:space:]]*\)\(CC[[:space:]]*=\)/\1#\2/;
	' win32/mingwin32.mak
	eapply "${FILESDIR}/${PV}-flags.patch"

	default
}

src_configure() {
	true  # Ignore configure script
}

src_compile() {
	cd "${S}/win32"
	local OPTS=()
	OPTS+=("-f" "mingwin32.mak")
	[ "$myARCH" = "$CATEGORY" ] && myARCH="${CHOST}"
	OPTS+=("CC=${myARCH}-gcc")
	OPTS+=("AR=${myARCH}-ar")
	OPTS+=("DEBUG=$(use debug && echo Y || echo N)")
	OPTS+=($(use unicode && echo WIDE=Y UTF8=Y || echo WIDE=N UTF8=N))
	OPTS+=("USER_CFLAGS=${CFLAGS}")
	OPTS+=("USER_LDFLAGS=${LDFLAGS}")
	make "${OPTS[@]}" DLL=Y libs
	if use static-libs; then
		mv pdcurses.dll dll
		make "${OPTS[@]}" DLL=Y clean
		mv dll pdcurses.dll
		make "${OPTS[@]}" DLL=N libs
	fi
}

src_install() {
	local subroot="/usr/${myARCH}"
	[ "${CATEGORY/cross/}" = "$CATEGORY" ] && subroot=
	insinto "${subroot}/usr/include"
	doins curses.h panel.h
	into "${subroot}/usr"
	dolib.so win32/pdcurses.dll
}
