# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="suid, sgid file and directory checking"
HOMEPAGE="http://linukz.org/sxid.shtml https://github.com/taem/sxid"
SRC_URI="http://linukz.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="+mail"
RDEPEND="mail? ( virtual/mailx )"

DOCS=( docs/sxid.{conf,cron}.example )

src_prepare() {
	default
	# this is an admin application and really requires root to run correctly
	# we need to move the binary to the sbin directory
	sed -i s/bindir/sbindir/g source/Makefile.in || die
	eautoreconf
}

pkg_postinst() {
	elog
	elog "Please configure /etc/sxid.conf for your own system. Refer to the sxid.conf manpage."
	elog "Also, no Cron script has been installed, but an example is given in /usr/share/doc/sxid*"
	elog
	if ! use mail; then
	elog "Since you disabled the mail flag, you MUST run the program with -n, the --nomail parameter!!!"
	elog
	fi
}
