# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="BaCon - BASIC to C converter and GUI (GTK3)"

HOMEPAGE="https://basic-converter.org"

SRC_URI="https://basic-converter.org/stable/${PN}-${PV}.tar.gz"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="+bash zsh ksh +gui +gtk3 -fltk -tk +doc"
REQUIRED_USE="|| ( bash zsh ksh )  gui? ( || ( gtk3 fltk tk ) )"

BDEPEND="
    >=sys-devel/flex-2.5
    >=sys-devel/m4-1.4.16
    >=sys-devel/automake-1.13
"
RDEPEND="
 bash? ( >=app-shells/bash-4.0 )
  zsh? ( >=app-shells/zsh-4.0 )
  ksh? ( >=app-shells/ksh-1.0 )
  gtk3? (    x11-libs/gtk+:3 )
 fltk? ( x11-libs/fltk:1=[opengl,xft] )
   tk? ( >=dev-lang/tk-8.6 )
    x11-libs/gtksourceview:4
    net-libs/webkit-gtk:4
"
#checking if GTK3 and supporting GtkSourceView4 and Webkit4 libraries are installed... not found
#just isnt building baconGTK anymore.
# AC_MSG_CHECKING(if GTK3 and supporting GtkSourceView4 and Webkit4 libraries are installed)
# GTK3=`pkg-config --silence-errors --libs gtk+-3.0`
# SRC3=`pkg-config --silence-errors --libs gtksourceview-4`
# WEB3=`pkg-config --silence-errors --libs webkit2gtk-4.0`
#checking for library containing gtk_init... -lgtk-3
#checking for library containing gtk_source_view_new... -lgtksourceview-4
#checking for library containing webkit_web_view_new... no
#This webkit was for documentation.............!1
#those functions only show up in the bacongui-legacy .bac
#i was wrong. gtk3 was skipped until now. now build error:
#In file included from bacongui-gtk3.bac.h:2,
#                 from bacongui-gtk3.bac.c:2:
#bacongui-gtk3.bac.generic.h:6:10: fatal error: webkit2/webkit2.h: No such file or directory
#    6 | #include <webkit2/webkit2.h>
# sed remove line 6
#then big bad errors
#bacongui-gtk3.bac.gui.h: In function '__b2c__guiDefine':
#bacongui-gtk3.bac.gui.h:346:35: error: 'WEBKIT_TYPE_WEB_VIEW' undeclared (first use in this function)
#  346 | web_view= GTK_WIDGET(g_object_new(WEBKIT_TYPE_WEB_VIEW ,"width-request",1024,"height-request",600,"expand",TRUE, NULL));
#      |                                   ^~~~~~~~~~~~~~~~~~~~
#/usr/include/glib-2.0/gobject/gtype.h:2532:57: note: in definition of macro '_G_TYPE_CIC'
# 2532 | #  define _G_TYPE_CIC(ip, gt, ct)       ((ct*) (void *) ip)
#      |                                                         ^~
#/usr/include/gtk-3.0/gtk/gtkwidget.h:58:44: note: in expansion of macro 'G_TYPE_CHECK_INSTANCE_CAST'
#   58 | #define GTK_WIDGET(widget)                (G_TYPE_CHECK_INSTANCE_CAST ((widget), GTK_TYPE_WIDGET, GtkWidget))
#      |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
#bacongui-gtk3.bac.gui.h:346:11: note: in expansion of macro 'GTK_WIDGET'
#  346 | web_view= GTK_WIDGET(g_object_new(WEBKIT_TYPE_WEB_VIEW ,"width-request",1024,"height-request",600,"expand",TRUE, NULL));
#      |           ^~~~~~~~~~
#bacongui-gtk3.bac.gui.h:346:35: note: each undeclared identifier is reported only once for each function it appears in
#  346 | web_view= GTK_WIDGET(g_object_new(WEBKIT_TYPE_WEB_VIEW ,"width-request",1024,"height-request",600,"expand",TRUE, NULL));
#      |                                   ^~~~~~~~~~~~~~~~~~~~
#/usr/include/glib-2.0/gobject/gtype.h:2532:57: note: in definition of macro '_G_TYPE_CIC'
# 2532 | #  define _G_TYPE_CIC(ip, gt, ct)       ((ct*) (void *) ip)
#      |                                                         ^~
#/usr/include/gtk-3.0/gtk/gtkwidget.h:58:44: note: in expansion of macro 'G_TYPE_CHECK_INSTANCE_CAST'
#   58 | #define GTK_WIDGET(widget)                (G_TYPE_CHECK_INSTANCE_CAST ((widget), GTK_TYPE_WIDGET, GtkWidget))
#      |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
#bacongui-gtk3.bac.gui.h:346:11: note: in expansion of macro 'GTK_WIDGET'
#  346 | web_view= GTK_WIDGET(g_object_new(WEBKIT_TYPE_WEB_VIEW ,"width-request",1024,"height-request",600,"expand",TRUE, NULL));
#

DEPEND=${RDEPEND}

src_prepare() {
    default
    #stopping up the build for something we dont need.
    sed -i -e '209,211 d; /libs webkit2gtk-4.0/c\        WEB3="webkit2gtk-4.0"' configure.in || die
    eautoreconf
}

src_configure() {
    #Shells
    local myshellopts=()
    use bash && myshellopts=$(use_with bash)
    use zsh  && myshellopts=$(use_with zsh)
    use ksh  && myshellopts=$(use_with ksh)
    #  --with-zsh              force compilation with ZSH (default: GUESS)
    #  --with-bash             force compilation with BASH (default: GUESS)
    #  --with-ksh              force compilation with KSH (default: GUESS)

    local myguiopts=()
    if use gui; then
        use gtk3 && myguiopts+=$(use_enable gtk3 gui-gtk3)
        use fltk && myguiopts+=$(use_enable fltk gui-fltk)
        use tk   && myguiopts+=$(use_enable   tk gui-tk)
    fi
    #  --enable-gui-gtk3       Build the GTK3 version of BaconGUI
    #  --enable-gui-fltk       Build the FLTK version of BaconGUI
    #  --enable-gui-tk         Build the TK version of BaconGUI
    #  --enable-gui-legacy     Build the legacy GTK version of BaconGUI
    #  --enable-gui-all        Build all versions of BaconGUI
    #these should be auto-fallbacks.

    #Strip - NOTE: upstream Makefile = FTBFS - error using regular strip command.
    # ?reason?: dir is rm -rf make cleaned, then tried stripped but file not found. odd...
    #replace with a command that wont return an error, the "true" command.
    #but it needs put it back to normal before moving on. send help,
    keepSTRIP=$STRIP
    export STRIP=true
    econf "${myshellopts[@]}" "${myguiopts[@]}"
    export STRIP=$keepSTRIP
}

src_compile() {
# it was breaking the build order of the "all" target without this, and then not generating a bacongtk-gui
#/bin/sh: line 2: build/bacon: No such file or directory
    emake all -j1
#the main job seems to be single threaded anyway:
#Converting 'bacon.bac'... done, 10499 lines were processed in 137 seconds.
}

src_install() {
#default makefile auto-installs desktop files, icons, gtk-update, etc.
    default
    use doc && dodoc documentation/*
    rm usr/share/BaCon/documentation
#/usr/bin/install: cannot stat 'build/bacongui-gtk3': No such file or directory
#install-xattr: failed to stat /var/tmp/portage/dev-lang/bacon-4.7/image/usr/bin/bacongui-gtk3: No such file or directory
#/usr/lib/portage/python3.11/ebuild-helpers/xattr/install -c build/bacongui-gtk3 /var/tmp/portage/dev-lang/bacon-4.7/image/usr/bin/bacongui-gtk3
}

# configuring............
#
#- Makefile created.
#- Using 'bash' to compile BaCon.
#- Creating BaConGUI for GTK3.
#
#Now run 'make' and 'make install' to build and install BaCon.
#
#>>> Source configured.
#>>> Compiling source in /var/tmp/portage/dev-lang/bacon-4.7/work/bacon-4.7 ...
#make -j17 all -j1
#rm -f build/* build-cpp/*
#Converting 'bacon.bac'... done, 10499 lines were processed in 137 seconds.
#Creating lexical analyzer using flex... done.
#Compiling 'bacon.bac'... make[1]: Entering directory '/var/tmp/portage/dev-lang/bacon-4.7/work/bacon-4.7/build'
#x86_64-pc-linux-gnu-gcc  -march=znver3 -mshstk -O2 -pipe -fdiagnostics-color=always -c bacon.bac.c
#x86_64-pc-linux-gnu-gcc -o bacon bacon.bac.o -Wl,-O1 -Wl,--as-needed    -lm
#make[1]: Leaving directory '/var/tmp/portage/dev-lang/bacon-4.7/work/bacon-4.7/build'
#Done, program 'bacon.bac' ready.
#true build/bacon
#Converting 'gui/bacongui-gtk3.bac'... done, 287 lines were processed in 0.007 seconds.
#Creating lexical analyzer using flex... done.
#Compiling 'gui/bacongui-gtk3.bac'... make[1]: Entering directory '/var/tmp/portage/dev-lang/bacon-4.7/work/bacon-4.7/build'
#x86_64-pc-linux-gnu-gcc  -march=znver3 -mshstk -O2 -pipe -fdiagnostics-color=always -DDATA_PATH=\"/usr/share\" `pkg-config --cflags gtk+-3.0` `pkg-config --cflags gtksourceview-4` `pkg-config --cflags webkit2gtk-4.0` -c bacongui-gtk3.bac.c
#make[1]: Leaving directory '/var/tmp/portage/dev-lang/bacon-4.7/work/bacon-4.7/build'
#
#INFO: see full error report (y/[n])? Runtime error: function 'INPUT' at line 10480 in 'bacon.bac': Error opening file: No such file or directory
#Skipping BaConGUI for FLTK.
#Skipping BaConGUI for TK.
#Skipping legacy BaConGUI.
#
#Run 'make install' or 'sudo make install' to install BaCon on your system.
#>>> Source compiled.
