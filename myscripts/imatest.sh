#!/bin/bash
#imatest.sh script v0.2 by @genr8eofl copyright 2023 - AGPL3 License

#simple verify command:
# evmctl ima_verify example -k /etc/keys/signing_key.x509

dateNow=$(date +"%F")
while read -r f; do
#    echo $f; #filename
    isverif=$(evmctl ima_verify "$f" -k /etc/keys/signing_key.x509)
    if [[ $? != 0 ]]; then
        echo "SIGNFAIL: ${f} failed verification!"
        echo "${f}" >> failfiles-${dateNow}.txt
    fi
done < allfiles-${dateNow}.txt
