# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6,7,8,9} )
CRATES="
udp-over-tcp-0.1.0
"

inherit cargo

DESCRIPTION="The Mullvad VPN client"
HOMEPAGE="https://mullvad.net/ https://github.com/mullvad/mullvadvpn-app"
SRC_URI="https://github.com/mullvad/mullvadvpn-app/archive/${PV}.tar.gz -> ${P}.tar.gz
	udp-over-tcp-0.1.0.crate"
#	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3"
KEYWORDS="amd64"
SLOT="0"
IUSE="gui uspace_wireguard"

RDEPEND="
	x11-libs/libnotify
	dev-libs/libappindicator
	"
DEPEND="${RDEPEND}"

BDEPEND="net-libs/libnftnl"

S="${WORKDIR}/mullvadvpn-app-${PV}"

DOCS=( README.md LICENSE.md )
