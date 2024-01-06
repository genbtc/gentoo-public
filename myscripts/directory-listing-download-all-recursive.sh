#!/bin/bash
# ./directory-listing-download-all-recursive.sh - v0.32 - Jan 06, 2024 -  based on:
# stage3-CONTENTS-download-all.sh script v0.22 - genr8eofl @gentoo - Sept 28, 2023

#INPUT:
PLATFORM="x86-64_hardened"
WEBDIR="https://mirrors.rit.edu/gentoo/releases/amd64/binpackages/17.1/${PLATFORM}/"

#RE-PROCESSING
if [[ -e "target.txt" ]]; then
    elinks --dump $(cat "target.txt") > "elinks.txt"
fi
if [[ -e "elinks.txt" ]]; then
    FILEDLS=($(grep "${WEBDIR}" "elinks.txt" | awk '{print $2}' | sort | uniq | tee "elinks-dl.txt"))
fi
if [[ -e "elinks-dl.txt" ]]; then
    FILEDLS=($(cat "elinks-dl.txt"))
fi

CWD=$(basename "${PWD}")
#ITERATION
#an array, for each
for filedl in "${FILEDLS[@]}"; do
    CATDIR=$(basename "${filedl}")
    if [[ ! ${filedl} =~ ${CWD} ]]; then
        continue    #skip links that dont match local path
    fi
    if [[ "${filedl}" =~ "?C=" ]]; then
        continue    #skip junk files, "index.html?C=S;O=A"
    fi
    #RECURSION
    if [[ "/" == "${filedl: -1}" ]]; then
        mkdir -pv "${CATDIR}"
        echo "${filedl}" | grep "${CATDIR}" > "${CATDIR}"/"target.txt"
        cd "${CATDIR}" || exit 9
        if [[ ! -e "complete.txt" ]]; then
            directory-listing-download-all-recursive.sh
        fi  #recurse or mark as complete and skip
        touch "complete.txt"
        cd .. || exit 8
        continue
    fi
    #dont issue duplicate requests to the network, and dont clobber overwrite existing
    if [[ -e ${filedl} ]]; then
    	echo "Downloading:      ${filedl} ..."
    	wget --no-clobber "${filedl}"
    else
        echo "File exists: ${filedl} !"
    fi
done

#OUTPUT:
