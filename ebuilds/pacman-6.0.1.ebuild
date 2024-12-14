# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
        GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://gitlab.archlinux.org/pacman/pacman"
else
	SRC_URI="https://sources.archlinux.org/other/pacman/${PN}-${PV}.tar.xz"
	KEYWORDS="amd64"
fi

inherit meson ${GIT_ECLASS}

DESCRIPTION="Pacman - A library-based package manager with dependency support from Arch Linux"
HOMEPAGE="https://www.archlinux.org/pacman/"
LICENSE="GPL-2"
SLOT="0"
IUSE="i18n +man doc +gpg +curl"
REQUIRED_USE="gpg curl"

RDEPEND="
	dev-libs/openssl
	curl? (	>=net-misc/curl-7.55.0 )
	gpg? (  >=app-crypt/gpgme-1.3.0 )
	app-crypt/gnupg
	>=app-arch/libarchive-3.0.0
	>=app-shells/bash-4.4
"
DEPEND="${RDEPEND}
	sys-libs/glibc
	sys-apps/coreutils
	sys-apps/gawk
	sys-apps/grep
"
#meson_feature: Crypto = openssl-libcrypto / or / libnettle
BDEPEND="
	i18n? ( virtual/libintl
		>=sys-devel/gettext-0.19.8 )
	doc? ( app-doc/doxygen )
	man? ( app-text/asciidoc )
	virtual/pkgconfig
	app-arch/xz-utils
	dev-util/meson
"

PATCHES=(
#	"${FILESDIR}/${PN}-${PV}-test.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_feature man doc)
		$(meson_feature doc doxygen)
		$(meson_use i18n)
		$(meson_feature curl)
		$(meson_feature gpg gpgme)
		--localstatedir="${EPREFIX}/var"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	keepdir /var/lib/pacman/
#	keepdir /var/cache/pacman/pkg/
	rm -rf "${ED}"/var/cache/
	keepdir /usr/share/makepkg-template/
	keepdir /usr/share/libalpm/hooks/
}

pkg_postinst() {
	elog "please edit /etc/pacman.conf, specify [core],[extra],[community] repos"
	#TODO: Just auto-add these sections to the .conf file
	elog "download pacman-mirrorlist to /etc/pacman.d/mirrorlist or"
	elog "create a mirrorlist using reflector"
	elog "sync, pacman -Syu"
	elog "download archlinux-keyring to /usr/share/pacman/keyrings/"
	elog "pacman-key --init && pacman-key --populate"
}
