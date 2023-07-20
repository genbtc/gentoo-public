#!/bin/sh
#script v1.0 by @genr8eofl copyright 2023 - AGPL3 License

/usr/src/linux/scripts/sign-file \
    sha512 \
    /etc/keys/signing_key.priv \
    /etc/keys/signing_key.x509 "$@" \;
echo "Signed file in ${PWD}, ok!"
