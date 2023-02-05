# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="REAPER is a Digital Audio Production Application for multitrack audio,
offering a full multitrack audio and MIDI recording, editing, processing, mixing and mastering toolset."

HOMEPAGE="https://www.cockos.com/reaper"

PVXYZ=${PV##.}

case ${ARCH} in
    amd64 ) target_arch="x86_64" ;;
    arm64 ) target_arch="aarch64" ;;
    arm   ) target_arch="armv7l" ;;
esac
S="${WORKDIR}/${PN}_linux_${target_arch}"

SRC_URI="
    amd64?   ( https://www.cockos.com/reaper/files/6.x/${PN}${PVXYZ}_${target_arch}.tar.xz -> ${P}.tar.xz )
    arm64?   ( https://www.cockos.com/reaper/files/6.x/${PN}${PVXYZ}_${target_arch}.tar.xz -> ${P}.tar.xz )
    arm?     ( https://www.cockos.com/reaper/files/6.x/${PN}${PVXYZ}_${target_arch}.tar.xz -> ${P}.tar.xz )
"
LICENSE="EULA"

SLOT="0"

KEYWORDS="~amd64 ~arm64 ~arm"

IUSE="+X +gtk3 alsa pulseaudio pipewire jack"
REQUIRED_USE="X gtk3 || ( alsa pulseaudio pipewire jack )"

src_install() {
	#symlink wants to write to /usr/local/bin but that doesnt work, use usr/bin
	dodir usr/bin
    sed -e '/^local_bin/c\local_bin=${ED}/usr/bin' -i ${S}/install-reaper.sh || die
	sed -e '/^srcpath/c\srcpath=${S}/REAPER' -i ${S}/install-reaper.sh || die
    export XDG_DATA_DIRS=usr/share
    DESKTOPDIR="usr/share/applications"
	ICONSDIR="usr/share/icons/hicolor"
	dodir ${DESKTOPDIR} ${ICONSDIR}
	export xdg_global_dir=${ED}/${ICONSDIR}
#xdg-icon-resource: No writable system icon directory found.
#xdg-desktop-menu: No writable system menu directory found.
# /usr/bin/xdg-icon-resource needs changed for this to work continue beyond blanked out var
#788c788
#< xdg_global_dir=
#> #xdg_global_dir=
#have to comment that out so
	#still use their installer tho?.
	${S}/install-reaper.sh --install ${ED}/opt --usr-local-bin-symlink --integrate-sys-desktop
    #fix ACCESS DENIED issue when installer generate desktop files #oof
#	 sed -e "s| --size 256||g" -i ${S}/install-reaper.sh || die
#    sed -e "s|xdg-desktop-icon ||g" -i ${S}/install-reaper.sh || die
#    sed -e "s|xdg-desktop-menu ||g" -i ${S}/install-reaper.sh || die
#    sed -e "s|xdg-icon-resource ||g" -i ${S}/install-reaper.sh || die
#    sed -e "s|xdg-mime |install |g" -i ${S}/install-reaper.sh || die
	#DONT delete tmp files it went through so much work to create
	sed -e "/rm -f.*cockos-reaper.desktop/d" -i ${S}/install-reaper.sh || die
	sed -e "/rm -f.*application-x-reaper.xml/d" -i ${S}/install-reaper.sh || die
	sed -e '/rmdir -- "$tmpdir"/d' -i ${S}/install-reaper.sh || die
    domenu cockos-reaper.desktop
#QA remove useless errors
#Running /usr/bin/update-mime-database
#Usage: /usr/bin/update-mime-database [-hvVn] MIME-DIR
#which: no kbuildsycoca5 in (/usr/lib/portage/python3.10/ebuild-helpers/xattr:/usr/lib/portage/python3.10/ebuild-helpers:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/usr/lib/llvm/15/bin)
#which: no kbuildsycoca4 ^^
#	cp -r ${T}/temp*/* ${S}
	pushd ${ED}/${ICONSDIR}/256x256/apps &&
	doicon cockos-reamote.png  cockos-reaper.png  cockos-reaper-backup.png  cockos-reaper-document.png  cockos-reaper-peak.png  cockos-reaper-template.png  cockos-reaper-template2.png  cockos-reaper-theme.png
	dodoc readme-linux.txt
	dostrip opt/REAPER/reaper opt/REAPER/Plugins/jsfx.so
	default
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
