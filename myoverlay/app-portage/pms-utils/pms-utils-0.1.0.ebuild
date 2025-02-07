# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/Jannik2099/pms-utils.git"
    inherit git-r3
else
    SRC_URI="https://github.com/Jannik2099/pms-utils/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
fi

inherit python-r1 meson

DESCRIPTION="A helper library to implement the Gentoo Package Manager Specification"
HOMEPAGE="https://github.com/Jannik2099/pms-utils/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND="
    dev-python/pybind11[${PYTHON_USEDEP}]
    dev-libs/boost
"
