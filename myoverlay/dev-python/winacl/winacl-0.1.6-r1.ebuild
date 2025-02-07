# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="ACL/ACE/Security Descriptor manipulation library in pure python"
HOMEPAGE="https://github.com/skelsec/winacl"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"

RDEPEND="
	>=dev-python/cryptography-38.0.1[${PYTHON_USEDEP}]
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

