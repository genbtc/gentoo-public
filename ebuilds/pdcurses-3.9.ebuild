# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# pdcurses-3.9.ebuild, 1/14/23 @genr8eofl
EAPI=8

inherit autotools

DESCRIPTION="Public Domain Curses library"
HOMEPAGE="https://pdcurses.org https://sourceforge.net/projects/pdcurses https://github.com/wmcbrine/PDCurses"
LICENSE="public-domain"

MyPN="PDCurses"
S="${WORKDIR}/${MyPN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MyPN}-${PV}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug +static-libs unicode force-utf8 -sdl +sdl2 +X demos" #-win32
REQUIRED_USE="|| ( X sdl2 sdl )
			 sdl2? ( static-libs )
			  sdl? ( static-libs )
"
BDEPEND="
	X? (
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXext
		x11-base/xorg-proto
	)
	sdl2? ( media-libs/libsdl2 )
	sdl? ( media-libs/libsdl )
	virtual/pkgconfig
"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if use sdl && use sdl2; then
		ewarn "${MyPN}: sdl and sdl2 - redundant USE flags: ( sdl && sdl2 )"
		ewarn "SDL1 is deprecated, SDL2 supercedes it - Ignoring SDL1, Building SDL2!"
	fi
}

src_prepare() {
	default
	if use X; then
	  cd ${S}/x11
	  eautoreconf
	fi
}

src_configure() {
	if use X; then
	  cd ${S}/x11
	  local myeconfargs=(
		$(use_with X x)
		$(usex X --x-includes="${EPREFIX}/usr/include/X11/")		#fixes configure.ac MH_CHECK_X_INC
		--prefix="${ED}/usr/"		#fixes install script outputdir
		$(use_enable debug)
		$(usev !unicode '--disable-widec')
		$(use_enable force-utf8)
	  )
	  econf "${myeconfargs[@]}"
	fi
}

src_compile() {
	local demos=$(usex demos "demos")
	use X  && emake -C ${S}/x11 all ${demos}
	use sdl && ! use sdl2 && emake -C ${S}/sdl1 libs ${demos}
	use sdl2 && emake -C ${S}/sdl2 libs ${demos}
	default
}

src_install() {
	dodoc README.md

	if use X; then
	  # Run Makefile install script, outputs /usr/lib64
	  emake -C ${S}/x11		install
	  elog "Installing ${MyPN} X11 libs..."
	  #dolib.so x11/libXCurses.so	# already done above
	  #use static-libs && dolib.a x11/libXCurses.a
  #  ^ already done *, and now the static use flag is not guarding, so:
	  use static-libs || find "${ED}" -name "*.a" -delete +
	  docinto x11 && dodoc x11/README.md
	fi
	if use sdl && ! use sdl2; then
	  elog "Installing ${MyPN} SDL1 libs..."
	  dolib.a sdl1/pdcurses.a
	  docinto sdl1 && dodoc sdl1/README.md
	fi
	if use sdl2; then
	  elog "Installing ${MyPN} SDL2 libs..."
	  dolib.a sdl2/pdcurses.a
	  docinto sdl2 && dodoc sdl2/README.md
		#TODO: Populate demos dir
	#DEMOS=("firework ozdemo ptest rain sdltest testcurs tuidemo worm xmas")
	  dodir /usr/share/${PN}/demos/

	fi
}
