# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Waveform Seekbar plugin for DeaDBeeF audio player"
HOMEPAGE="https://github.com/cboxdoerfer/ddb_waveform_seekbar"
EGIT_REPO_URI="https://github.com/cboxdoerfer/ddb_waveform_seekbar.git"

LICENSE="GPL-2"
SLOT="0"

DEPEND_COMMON="
	dev-db/sqlite:3
	media-sound/deadbeef"

RDEPEND="${DEPEND_COMMON}"
DEPEND="${DEPEND_COMMON}"

src_compile() {
	emake gtk3
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins gtk3/ddb_misc_waveform_GTK3.so
}
