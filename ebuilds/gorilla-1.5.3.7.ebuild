# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Password Safe in secure way with GUI interface"
HOMEPAGE="https://github.com/zdia/gorilla/wiki"
SRC_URI="https://github.com/zdia/gorilla/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 arm64 ppc"

DEPEND="
	>=dev-lang/tcl-8.5:=
	>=dev-lang/tk-8.5:=
	dev-tcltk/iwidgets
	dev-tcltk/bwidget
"
RDEPEND="${DEPEND}"

src_install() {
    find . -name "*.so" -delete || die
    pushd sources || die
	insinto /opt/${P}
    doins -r *
cat << EOF > gorilla
#! /bin/sh
# the next line restarts using wish
exec /usr/bin/wish "\$0" \${1+"\$@"}

set myName [info script]
set myGorilla /opt/gorilla-1.5.3.7/gorilla.tcl

if {![catch {
    set linkName [file readlink \$myName]
}]} {
    set myName \$linkName
}
source [file join [file dirname \$myName] \$myGorilla]
EOF
    dobin gorilla
}
