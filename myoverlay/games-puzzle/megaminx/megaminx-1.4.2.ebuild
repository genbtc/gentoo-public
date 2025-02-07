# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Megaminx Dodecahedron Future Cube Emulator"
HOMEPAGE="https://github.com/genbtc/megaminx/"
SRC_URI="${HOMEPAGE}archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~amd64 x86 ~x86"
IUSE="+opengl +glut"

DEPEND="
	glut? ( media-libs/freeglut )
	opengl? (
		media-libs/glu
		virtual/opengl
	)
"
DOCS=(
	README.md
    doc/functions-shadow.txt
    doc/functions-face.txt
    doc/algo-test-modBy.txt
)

src_configure() {
	cmake_src_configure
}

src_install() {
    newbin ${BUILD_DIR}/Megaminx megaminx
    einstalldocs
}

pkg_postinst() {
	elog "Megaminx is finished installing !"
}
