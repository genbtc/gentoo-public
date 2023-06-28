# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11,12} )
CRATES=""

inherit cargo

DESCRIPTION="The Mullvad VPN client"
HOMEPAGE="https://mullvad.net/ https://github.com/mullvad/mullvadvpn-app"
SRC_URI="https://github.com/mullvad/mullvadvpn-app/archive/${PV}.tar.gz -> ${P}.tar.gz"
#	udp-over-tcp-0.1.0.crate"
#	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3"
KEYWORDS="amd64"
SLOT="0"
IUSE="gui uspace_wireguard"

RDEPEND="
	x11-libs/libnotify
	dev-libs/libappindicator
	"

#CONFIG_CHECK="
#~NETFILTER_NETLINK
#~WIREGUARD
#~IPV6
#~NETFILTER
#~NETFILTER_NETLINK
#~NF_TABLES
#~NET_UDP_TUNNEL
#~NF_TABLES_IPV6
#~IP6_NF_MANGLE
#~NFT_CT
#~NFT_MASQ
#~NFT_NAT
#~NFT_REJECT
#~NFT_REJECT_INET
#~NF_REJECT_IPV6
#~NF_REJECT_IPV4"

DEPEND="${RDEPEND}"

BDEPEND="net-libs/libnftnl"

S="${WORKDIR}/mullvadvpn-app-${PV}"

DOCS=( README.md LICENSE.md )
