# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Gobby, GTK-based collaborative editor"
HOMEPAGE="https://gobby.github.io/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0.6"
KEYWORDS="~amd64 ~x86"
IUSE="avahi gtk +gtk3 doc nls"

RDEPEND="
    dev-cpp/glibmm:2
    dev-cpp/gtkmm:3.0
    x11-libs/gtk+:3
    x11-libs/gtksourceview:3.0
    dev-cpp/libxmlpp:2.6
    dev-libs/libsigc++:2
    net-libs/libinfinity:0/0.7[gtk3,gtk,avahi?]
"
DEPEND="${RDEPEND}
    virtual/pkgconfig
    doc? (
        >=app-text/gnome-doc-utils-0.9.0
        app-text/scrollkeeper-dtd
        app-text/rarian
        )
    nls? ( >=sys-devel/gettext-0.12.1 )
"
src_prepare() {
    eautoreconf
    default
}

src_configure() {
    append-cflags -Wno-deprecated-declarations -DGLIB_DISABLE_DEPRECATION_WARNINGS
    econf $(use_enable doc docs ) \
          $(use_enable nls )
}

src_install() {
    emake DESTDIR="${ED}" install || die
}
