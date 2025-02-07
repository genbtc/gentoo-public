#genBTC original work, Aug10 2022 + Dec 2023 + Mar/Apr 2024 + July 2024 + Jan 2025 - LICENSE: CCSA 4.0
#_valid_phases="
#       src_prepare src_unpack src_configure src_compile src_install src_test
#       pkg_config pkg_info pkg_nofetch pkg_pretend pkg_setup pkg_preinst pkg_prerm pkg_postinst pkg_postrm"

pre_src_configure() {
    echo "::0 /etc/portage/bashrc $FUNCNAME() begin: "
    #qlop Display average build time
    echo "Estimated Merge Times: "
    qlop -v -t "${CATEGORY}"/"${PN}"
    #q File integrity scan beforehand
    echo "QCheck File Integrity: "
    qcheck -v -P "${CATEGORY}"/"${PN}"
    #Log emerge --info so its stored as an artifact in environment.bz2
    if [ -n EMERGEINFO ]; then
        echo ">>> emerge --info embedded into environment as \$EMERGEINFO"
        export EMERGEINFO=$(emerge --ignore-default-opts --info);  #exports are auto-captured
    fi
    #AutoConf, enumerate --configure Options (for comparison)
    if [ -f configure ] && [ ! -f meson.build ]; then
        if [ x"${CATEGORY}"/"${PN}" == x"dev-util/rr" ]; then return; fi        #package is weird
        # PRINT OUT CONFIGURE HELP
        echo ">>> $FUNCNAME() { ./configure --help }"
        OPTFEATS=$(./configure --help | sed -ne '/^Optional Features/,$ p')
        echo -e "${OPTFEATS}"
        #OPT FEATURES DETECTION FOR DISABLE NLS
        if grep -q "\--disable-nls" <<< "${OPTFEATS}" ; then
            iuse=$(grep -q -w "nls" <<< "${IUSE}");
            if ! $iuse && ! grep -q "\--disable-nls" <<< "${ECONF} ${EXTRA_ECONF} ${MY_ECONF}" ; then
                echo "${CATEGORY}"/"${PN}:"  "ECONF: ${ECONF}  +  EXTRA_ECONF: ${EXTRA_ECONF}  +  MY_ECONF: ${MY_ECONF}"
                einfo "\033[01;31m Disable NLS was found in configure, but NOT passed in ECONF. \033[00m"
                eqawarn "\033[01;31m --disable-nls wasnt passed to configure! \033[01;33m Auto-Adding the correct Fix!\033[00m"
                export EXTRA_ECONF="${EXTRA_ECONF} --disable-nls"
            fi
        fi
    fi
    #Meson, Show configure page (all settings)
    if [ -f meson.build ]; then
        #some packages are weird, need to ignore if toplevel meson file isnt usable. or hangs.
        if [ "${CATEGORY}"/"${PN}" == "x11-libs/gtk+" ]; then return; fi
        if [ "${CATEGORY}"/"${PN}" == "app-crypt/seahorse" ]; then return; fi
        if [ "${CATEGORY}"/"${PN}" == "sys-fs/cryptsetup" ]; then return; fi
        if [ "${CATEGORY}"/"${PN}" == "media-libs/mesa" ]; then return; fi
        echo ">>> $FUNCNAME() { meson configure }"
        PAGER=  meson configure || cat || die
    fi
    #Meson, Show all meson options (for logs, recordkeeping)
    if [ -f meson_options.txt ]; then
        echo ">>> $FUNCNAME() { cat meson_options.txt }"
        cat meson_options.txt | sed '/^$/d'
    fi
}
