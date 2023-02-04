# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools gnome2-utils xdg

DESCRIPTION="A graphical hardware temperature monitor for Linux"
HOMEPAGE="https://wpitchoune.net/psensor/"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://gitlab.com/jeanfi/psensor.git"
else
    KEYWORDS="~amd64 ~x86"
    SRC_URI="https://wpitchoune.net/psensor/files/${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+X +gtk +gtop +gsettings smart hddtemp udisks libnotify appindicator curl json docs nls"

RDEPEND="
    >=sys-apps/lm-sensors-3
    smart? ( dev-libs/libatasmart )
    udisks? ( sys-fs/udisks:2 )
    gtop? ( gnome-base/libgtop:2 )
    hddtemp? ( app-admin/hddtemp )
    X? (
        x11-libs/libX11
        x11-libs/libXext
    )
    dev-libs/glib:2
    gtk? (
        x11-libs/gtk+:3
        x11-libs/cairo
    )
    libnotify? ( x11-libs/libnotify )
    appindicator? ( dev-libs/libappindicator
            dev-libs/libayatana-appindicator
            dev-libs/libunity
    )
    gsettings? ( || ( gnome-base/gconf
                      gnome-base/dconf ) )
    curl? ( net-misc/curl )
    json? ( >=dev-libs/json-c-0.12 )
"
DEPEND="
    ${RDEPEND}
    docs? (
        sys-apps/help2man
        app-text/asciidoc
    )
"
BDEPEND="
    virtual/pkgconfig
"
src_prepare() {
    default
    eautoreconf
    eapply "${FILESDIR}/pudisks.c-ftbfs.patch"
}

src_configure() {
    local econfargs=(
        $(use_with gtop)
        $(use_with gsettings)
        $(use_enable nls)
        $(use_with X x)
        --x-includes="${ESYSROOT}/usr/include"
        --x-libraries="${ESYSROOT}/usr/$(get_libdir)"
        --prefix="${EPREFIX}"/usr
        --libdir="${EPREFIX}"/usr/$(get_libdir)
    )

    econf "${econfargs[@]}" || die
}

src_install() {
    default
}

pkg_postinst() {
    gnome2_schemas_update
    xdg_icon_cache_update
}

pkg_postrm() {
    gnome2_schemas_update
    xdg_icon_cache_update
}

