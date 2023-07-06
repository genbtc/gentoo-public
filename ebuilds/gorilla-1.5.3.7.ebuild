# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg desktop

DESCRIPTION="GUI Password vault/manager, pwsafe3.2 compatible secure db, written entirely in Tcl/Tk"
HOMEPAGE="https://github.com/zdia/gorilla/wiki"
SRC_URI="https://github.com/zdia/gorilla/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86 ~arm64 ~ppc"

DEPEND="
	>=dev-lang/tcl-8.5:=
	>=dev-lang/tk-8.5:=
	dev-tcltk/iwidgets
	dev-tcltk/bwidget
"
RDEPEND="${DEPEND}"

src_install() {
    find . -name "*.so" -delete || die
    find . -name "*.dylib" -delete || die
    find . -name "*.dll" -delete || die
    pushd sources || die
    sed -e 's/tclsh8\.5/tclsh/g' -i gorilla.tcl
    #install everything to /opt/gorilla-1.5.3.7
	insinto /opt/${P}
    doins -r *
    fperms +x /opt/${P}/gorilla.tcl
    #make versioned /usr/bin symlink
# (or name will collide with 1.4) (this file originated in 1.4)
cat << EOF > gorilla15
#! /bin/sh
# the next line restarts using wish \\
exec /usr/bin/wish "\$0" \${1+"\$@"}

set myName [info script]
set myGorilla /opt/${P}/gorilla.tcl

if {![catch {
    set linkName [file readlink \$myName]
}]} {
    set myName \$linkName
}
source [file join [file dirname \$myName] \$myGorilla]
EOF
    dobin gorilla15
    #make desktop file (handmade?)
cat << EOF > gorilla15.desktop
[Desktop Entry]
Name=Password Gorilla
Comment=${DESCRIPTION}
Keywords=safe;security;vault;password;manager
Type=Application
Exec=gorilla15
TryExec=gorilla15
Icon=password-gorilla
StartupNotify=false
Terminal=false
Categories=Utility;
EOF
#Desktop Entry
#    insinto usr/share/applications
#    doins gorilla15.desktop
#just use this:
    # @FUNCTION: make_desktop_entry
    # @USAGE: <command> [name] [icon] [type] [fields]
#Handle Icons
#    pushd pics || die
#    ICONS="application.gif  browse.gif  gorilla-16x16.gif  gorilla-32x32.gif  gorilla-48x48.gif  gorilla-logo.jpg  gorilla-splash.gif  group.gif  login.gif  splash.gif"
#    VECTORICONS="vector-logo/"+["gorilla-logo.fig  gorilla-logo-lines.pbm  gorilla-logo.svg"]
#    doicon ${ICONS}
#    doicon ${VECTORICONS}
#    newicon pics/vector-logo/gorilla-logo.svg password-gorilla.svg
#    newicon pics/gorilla-splash.gif password-gorilla-splash.gif
#just do this:
    doicon pics/vector-logo/gorilla-logo.svg pics/gorilla-splash.gif
    make_desktop_entry "gorilla15" "Password Gorilla" "gorilla-splash.gif" "Utility" "Keywords=safe;security;vault;password;manager"
}

xdgupdate() {
    xdg_icon_cache_update
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

pkg_postinst() {
    xdgupdate
}

pkg_postrm() {
    xdgupdate
}


