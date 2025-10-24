# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 cmake

DESCRIPTION="Library to instrument executable formats"
HOMEPAGE="https://lief.quarkslab.com/"
SRC_URI="https://github.com/lief-project/LIEF/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples +python static-libs"

RDEPEND="python? ( ${PYTHON_DEPS}
	dev-python/pydantic-core[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/xtract[${PYTHON_USEDEP}]
	dev-python/nanobind[${PYTHON_USEDEP}]
)"
DEPEND="${RDEPEND}"
BDEPEND="${DISTUTILS_DEPS}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
#FIXME: LIEF_TESTS
RESTRICT="test"

S=${WORKDIR}/LIEF-${PV}

wrap_python() {
	if use python; then
		pushd "./api/python" >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null
	fi
}

src_prepare() {
	#fix multilib
	sed -i "s|CMAKE_INSTALL_LIBDIR \"lib\"|CMAKE_INSTALL_LIBDIR \"$(get_libdir)\"|" CMakeLists.txt || die

	cmake_src_prepare
	wrap_python ${FUNCNAME}
	eapply_user
}

src_configure() {
	#cmake/LIEFOptions.cmake
	local FORCE32=NO
	use x86 && FORCE32=YES

	local PYTHON_API=NO
	local NANOBIND_DIR

	if use python; then
		#set EPYTHON variable for python_get_sitedir
		python_setup
		PYTHON_API=YES
		NANOBIND_DIR=$(python_get_sitedir)/nanobind/cmake
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS="$(usex static-libs OFF ON)"
		-DLIEF_EXAMPLES="$(usex examples ON OFF)"
		-DLIEF_PYTHON_API="$PYTHON_API"
		-DLIEF_FORCE32="$FORCE32"
	)
	use python && mycmakeargs+=(
		-DLIEF_OPT_NANOBIND_EXTERNAL=1
		-Dnanobind_DIR="${NANOBIND_DIR}"
	)

	cmake_src_configure
	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile
	wrap_python ${FUNCNAME}
}

src_install() {
	cmake_src_install
	wrap_python ${FUNCNAME}
}

# FAILS AT: (02/06/24)
#/var/tmp/portage/dev-util/lief-0.14.0/work/LIEF-0.14.0/api/python/src/Abstract/pyBinary.cpp: In function 'void LIEF::py::create(nanobind::module_&) [with T = LIEF::Binary]':
#/var/tmp/portage/dev-util/lief-0.14.0/work/LIEF-0.14.0/api/python/src/Abstract/pyBinary.cpp:129:9: error: unable to find string literal operator 'operator""_p' with 'const char [33]', 'long unsigned int' arguments
#  129 |         "(self) -> list[Union[str,bytes]]"_p)
#      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#/var/tmp/portage/dev-util/lief-0.14.0/work/LIEF-0.14.0/api/python/src/Abstract/pyBinary.cpp:206:9: error: unable to find string literal operator 'operator""_p' with 'const char [30]', 'long unsigned int' arguments
#  206 |         "abstract(self) -> lief.Binary"_p,
#      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#/var/tmp/portage/dev-util/lief-0.14.0/work/LIEF-0.14.0/api/python/src/Abstract/pyBinary.cpp:219:9: error: unable to find string literal operator 'operator""_p' with 'const char [71]', 'long unsigned int' arguments
#  219 |         "concrete(self) -> lief.ELF.Binary | lief.PE.Binary | lief.MachO.Binary"_p,
#      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#Revert to 0.13.2 until we can figure out what this means
