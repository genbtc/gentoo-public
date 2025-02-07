#genBTC original work, Aug10 2022 + Dec 2023 + Mar/Apr 2024 + July 2024 + split files September 2024 + hash_and_xattr 2025 - LICENSE: CCSA 4.0
#_valid_phases="
#       src_prepare src_unpack src_configure src_compile src_install src_test
#       pkg_config pkg_info pkg_nofetch pkg_pretend pkg_setup pkg_preinst pkg_prerm pkg_postinst pkg_postrm"

if [ "${EBUILD_PHASE}" == "preinst" ]; then
  # create parallel file in this stage, for the next stage, because now is the last time we can write to here
  # # pwd == ${D}
  mkdir -p ~/.parallel; touch ~/.parallel/will-cite
  # kernels can be skipped from my shenanigans, have too many files, and slow on large packages. skip
  if [ "${PN}" == "gentoo-sources" ] || [ "${PN}" == "gentoo-kernel" ] || [ "${PN}" == "gentoo-kernel-bin" ] \
   || [ "${PN}" == "papirus-icon-theme" ]; then    return;  fi
  #NOTE: This can be very slow on large packages and useless on non-binary pkgs. skip^!
  echo "::1 /etc/portage/bashrc PreInst: Analyzing files w/ CHECKSEC..."
  #Checksec - Also log its output forever to special buildlogs/checksec dir
  checkseclog="/var/cache/buildlogs/checksec/${PN}-${PV}-1.txt"
  time checksec --dir=${D} | tee ${checkseclog}
  einfo "ChecksecLog: ${checkseclog}" #save logfile name for later
  #AMDGPU PATCH: ( hacky post-image, pre-fs .patch )  #TODO: create scheme for integrating post-install patches.
  if [ x"${CATEGORY}"/"${PN}" == x"x11-drivers/xf86-video-amdgpu" ]; then
    sed -i 6i'	Option "TearFree" "On"' ${D}/usr/share/X11/xorg.conf.d/10-amdgpu.conf
  fi
fi

#if [ "${EBUILD_PHASE}" == "install" ]; then

if [ "${EBUILD_PHASE}" == "postrm" ]; then
    echo "::R /etc/portage/bashrc PostRM Hook: "
    if [ "${PN}" == "parallel" ]; then
        echo "::R /etc/portage/bashrc PostRM Hook: imafix2 Fixing parallel..."
        imafix2 -s /usr/bin/parallel
    fi
    if [ "${PN}" == "python" ]; then
        echo "::R /etc/portage/bashrc PostRM Hook: imafix2 Fixing python..."
        imafix2 -s /usr/bin/python-exec2c
#        portageq contents / ${PN}-${PVR} | parallel -j 32 imafix2 -s #  *   	die "portageq is not allowed in ebuild scope"
        mkdir -p ~/.parallel; touch ~/.parallel/will-cite
        qlist ${PN}-${PVR} | parallel -j 32 imafix2 -s
#        qlist ${PN}-${PVR} | hash_and_xattr
    fi
    if [ "${PN}" == "glibc" ] || [ "${PN}" == "binutils-config" ]; then #sign ldconfig early, regenerate ld.so needs to succeed or else package will fail
        echo "::R /etc/portage/bashrc PostRM Hook: imafix2 SHA512 Hashing in progress..."
        									 # omit dir,path,sym,dev
#        time equery -C files ${PN}-${PVR} -f "obj,conf,cmd,doc,man,info,fifo" | grep -v "debug" | parallel -j 32 imafix2 -s
         time equery -C files ${PN}-${PVR} -f "obj,conf,cmd,doc,man,info,fifo" | grep -v "debug" | hash_and_xattr
    fi
fi

# Breaks for dev-lang/perl , vim , anything that has its own scripts, and runs its own new binary itself first ^^
if [ "${EBUILD_PHASE}" == "postinst" ]; then
    # kernels can be skipped from my shenanigans, have too many files, and slow. skip. glibc handled earlier in postrm ^^
	if [ "${PN}" == "gentoo-sources" ] || [ "${PN}" == "gentoo-kernel" ] || [ "${PN}" == "gentoo-kernel-bin" ] \
	 || [ "${PN}" == "python" ] || [ "${PN}" == "glibc" ] || [ "${PN}" == "binutils-config" ]; then     return;  fi
	echo "::2 /etc/portage/bashrc PostInst: imafix2 SHA512 Hashing in progress..."
      				                     # omit dir,path,sym,dev
#	time equery -C files ${PN}-${PVR} -f "obj,conf,cmd,doc,man,info,fifo" | parallel -j 32 imafix2 -s
	time equery -C files ${PN}-${PVR} -f "obj,conf,cmd,doc,man,info,fifo" | hash_and_xattr
fi

if [ "${EBUILD_PHASE}" == "postinst" ]; then
	#Always Save LogFile to elog. For elogv to correlate the logs
	einfo "Logfile: ${PORTAGE_LOG_FILE}"
fi
