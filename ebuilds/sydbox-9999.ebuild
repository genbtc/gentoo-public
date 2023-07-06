# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/sydbox/sydbox-1.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sydbox/sydbox-1/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
	S="${WORKDIR}/${PN}-1-${PV}"	# dir is "sydbox-1-2.2.0"
fi

inherit autotools linux-info

DESCRIPTION="sydbox, a seccomp-bpf & seccomp-notify based sandbox,
			 blocks unwanted process access to filesystem and network resources."
HOMEPAGE="https://sydbox.exherbo.org https://pink.exherbo.org/"

#NOTE: SydB@x-2.0.1 and newer do not use ptrace() but use seccomp user notify facilities
#      in recent Linux kernels 5.6 and newer. Hence, PinkTrace is no longer a dependency.

LICENSE="GPL-3+"
SLOT=0
IUSE="+seccomp +bpf +notify tmux cgdb valgrind vim debug static-libs rust pandora"

REQUIRED_USE="
	rust?    ( pandora )
	pandora? ( rust )
"
BDEPEND="
    >=sys-devel/m4-1.4.16
    >=dev-lang/perl-5.10
    >=sys-kernel/linux-headers-5.6
	sys-libs/libseccomp
	dev-libs/libxslt
	app-text/docbook-xml-dtd
	sys-devel/libtool
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/bison
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/gperf
	sys-devel/bzip2
	sys-devel/diffutils
	tmux? ( app-misc/tmux )
	cgdb? ( dev-util/cgdb )
	app-shells/bash
	sys-devel/strace
	valgrind? ( dev-util/valgrind )
	vim? ( app-editors/vim )
	rust?    ( virtual/rust )
	pandora? ( virtual/rust )
"
RDEPEND="
	sys-libs/libseccomp
	sys-devel/strace
	sys-libs/libunwind
"
DEPEND="
    ${RDEPEND}
    >=sys-kernel/linux-headers-5.6
"
CONFIG_CHECK="
	~SECCOMP
	~SECCOMP_FILTER
	~CROSS_MEMORY_ATTACH
	~BPF
	~BPF_SYSCALL
	~PROC_FS
	~NAMESPACES
	~IPC_NS
	~NET_NS
	~PID_NS
	~USER_NS
	~UTS_NS
	~CGROUPS
"

pkg_setup() {
    linux-info_pkg_setup
}

src_prepare() {
	autoreconf -f -i || die
	default
}

src_configure() {
	local myconf="
				  --enable-shared
				  $(use_enable static-libs static)
				  $(use_enable debug)
				  $(use_enable rust sydbox_rs)
				  $(use_enable pandora)
	"
	econf ${myconf}
}

src_compile() {
	default
}

src_test() {
	emake check
}

src_install() {
    default
    find "${ED}" -name '*.la' -delete || die
}
