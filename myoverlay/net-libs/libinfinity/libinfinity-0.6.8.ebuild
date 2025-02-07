# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_PV=$(ver_cut 1-2)

DESCRIPTION="An implementation of the Infinote protocol written in GObject-based C"
HOMEPAGE="https://gobby.github.io/"
SRC_URI="https://github.com/gobby/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
         http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0/0.6"
KEYWORDS="~amd64 ~x86"
IUSE="avahi gtk +gtk3 server static-libs doc"

RDEPEND="dev-libs/glib:2
    dev-libs/libxml2
    net-libs/gnutls
    sys-libs/pam
    virtual/gsasl
    avahi? ( net-dns/avahi )
    gtk3? ( x11-libs/gtk+:3 )
    gtk? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
        acct-user/infinote
        acct-group/infinote
    virtual/pkgconfig
    sys-devel/gettext
    doc? ( dev-util/gtk-doc )
"
DOCS=( AUTHORS ChangeLog NEWS README.md TODO )

src_prepare() {
    eautoreconf
    default
}

src_configure() {
    append-cflags -Wno-deprecated-declarations -DGLIB_DISABLE_DEPRECATION_WARNINGS
    econf \
        $(use_enable doc gtk-doc) \
        $(use_with gtk inftextgtk) \
        $(use_with gtk infgtk) \
        $(use_with gtk3) \
        $(use_with server infinoted) \
        $(use_with avahi) \
        $(use_with avahi libdaemon)
}

src_install() {
    emake DESTDIR="${ED}" install
    if use server ; then
        newinitd "${FILESDIR}/infinoted.initd" infinoted
        newconfd "${FILESDIR}/infinoted.confd" infinoted

        keepdir /var/lib/infinote
        fowners infinote:infinote /var/lib/infinote
        fperms 770 /var/lib/infinote

        dosym "/usr/bin/infinoted-${MY_PV}" "/usr/bin/infinoted"

        elog "Add local users who should have local access to the documents"
        elog "created by infinoted to the infinote group."
        elog "The documents are saved in /var/lib/infinote per default."
    fi
    if ! use static-libs ; then
        find "${ED}" -name "*.a" -delete +
        find "${ED}" -name "*.la" -delete +
    fi
}
