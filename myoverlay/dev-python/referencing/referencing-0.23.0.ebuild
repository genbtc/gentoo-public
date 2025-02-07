# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1 pypi

DESCRIPTION="Cross-specification JSON referencing (JSON Schema, OpenAPI...)"
HOMEPAGE="
	https://github.com/python-jsonschema/referencing/
	https://pypi.org/project/referencing/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.19.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
