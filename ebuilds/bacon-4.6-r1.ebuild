# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="BaCon - BASIC to C converter plus GTK GUI"

HOMEPAGE="https://basic-converter.org"

SRC_URI="https://basic-converter.org/stable/bacon-4.6.tar.gz"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="+bash zsh ksh +gui +gtk fltk +doc"
REQUIRED_USE="|| ( bash zsh ksh )  gui? ( || ( gtk fltk ) )"

BDEPEND="
    >=sys-devel/flex-2.5
    >=sys-devel/m4-1.4.16
    >=sys-devel/automake-1.13
"
RDEPEND="
 bash? ( >=app-shells/bash-4.0 )
  zsh? ( >=app-shells/zsh-4.0 )
  ksh? ( >=app-shells/ksh-1.0 )
  gtk? (    x11-libs/gtk+:3 )
 fltk? ( x11-libs/fltk:1=[opengl,xft] )
    x11-libs/gtksourceview:3.0
"
DEPEND=${RDEPEND}

src_configure() {
    #NOTE: upstream Makefile = ftfbs, error using regular strip command
    # ?reason?: dir is rm -rf make cleaned, then tried stripped but file not found. odd...
    #replace with a command that wont return an error, the "true" command.
    #but it needs put it back to normal before moving on.
    keepSTRIP=$STRIP
    export STRIP=true
    local myshell=()
    use bash && myshell=$(use_with bash)
    use zsh && myshell=$(use_with zsh)
    use ksh && myshell=$(use_with ksh)
    local mygui=()
    if use gui; then
        use gtk && mygui+=$(use_enable gtk gui-gtk)
        use fltk && mygui+=$(use_enable fltk gui-fltk)
    fi
    econf "${myshell[@]}" "${mygui[@]}"
    export STRIP=$keepSTRIP
}

src_compile() {
# * QA Notice: make jobserver unavailable:
# *      make[1]: warning: jobserver unavailable: using -j1. Add '+' to parent make rule.
# it was breaking the build order of the "all" target without this, and then not generating a bacongtk-gui
    emake -j1
}

src_install() {
#default makefile auto-installs desktop files, icons, gtk-update, etc.
    default
    if use doc; then
        dodoc documentation/*
    fi
    rm usr/share/BaCon/documentation
}
