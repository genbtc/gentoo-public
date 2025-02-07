#genBTC original work, Aug10 2022 + Dec 2023 + Mar/Apr 2024 + July 2024 - LICENSE: CCSA 4.0

# (as per my genius implementation here)
if [ "${EMERGE_FROM}" == "binary" ] && [ "${EBUILD_PHASE}" == "setup" ]; then
    einfo "Binary install detected!  Confirm BINPKG-CFLAGS: ${CFLAGS}"
fi
if [ "${EMERGE_FROM}" == "binary" ] && [ "${EBUILD_PHASE}" == "instprep" ]; then
    local isz=$(du -ksh "${D}")
    einfo "Binary package install size: ${isz}"
fi
