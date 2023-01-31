# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="REAPER is a Digital Audio Production Application for multitrack audio,
offering a full multitrack audio and MIDI recording, editing, processing, mixing and mastering toolset. "

HOMEPAGE="https://www.cockos.com/reaper"

SRC_URI="
amd64?   ( https://www.cockos.com/reaper/files/6.x/${PN}673_linux_x86_64.tar.xz -> ${P}.tar.xz )
arm64?   ( https://www.cockos.com/reaper/files/6.x/${PN}673_linux_aarch64.tar.xz -> ${P}.tar.xz )
arm?     ( https://www.cockos.com/reaper/files/6.x/${PN}673_linux_armv7l.tar.xz -> ${P}.tar.xz )"

LICENSE="EULA"

SLOT="0"

KEYWORDS="~amd64 ~arm64 ~arm"

IUSE="X"

src_install() {
	insinto /opt/REAPER/
	default
}
