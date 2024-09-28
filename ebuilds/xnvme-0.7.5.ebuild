# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="xNVME Cross-platform libraries and tools for NVMe devices"
HOMEPAGE="https://xnvme.io/index.html"
SRC_URI="https://github.com/xnvme/xnvme/releases/download/v${PV}/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
    app-arch/libarchive
    app-shells/bash
    dev-build/meson
    dev-lang/nasm
    dev-libs/isa-l
    dev-libs/libaio
    dev-libs/openssl
    dev-python/pip
    dev-python/pyelftools
    dev-util/cunit
    dev-util/pkgconf
    dev-vcs/git
    sys-libs/liburing
    sys-libs/ncurses
    sys-process/numactl
    sys-apps/findutils
    dev-build/make
    sys-devel/patch
"

src_prepare() {
    einfo "build requires linking against ncurses AND tinfo, run the following before compilation:"
    einfo "export LDFLAGS=\"-ltinfo -lncurses\""
    export LDFLAGS="${LDFLAGS} -ltinfo -lncurses"

##
## Clone, build and install libvfn
##
## Assumptions:
##
## - Dependencies for building libvfn are met (system packages etc.)
## - Commands are executed with sufficient privileges (sudo/root)
##
#git clone https://github.com/SamsungDS/libvfn.git toolbox/third-party/libvfn/repository

#pushd toolbox/third-party/libvfn/repository
#git checkout v5.0.0
#meson setup builddir -Dlibnvme="disabled" -Ddocs="disabled" --buildtype=release --prefix=/usr
#meson compile -C builddir
#meson install -C builddir
#popd

## Install packages via the Python package-manager (pip)
#python3 -m pip install --break-system-packages
#pipx

}
