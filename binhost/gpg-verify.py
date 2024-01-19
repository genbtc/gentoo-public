#!/usr/bin/env python3
# Created Jan 18, 2024 - inf1nity @ gentoo
# https://forums.gentoo.org/viewtopic-p-8813617.html#8813617

import gnupg
gpg = gnupg.GPG(gnupghome=BINPKG_GPG_SIGNING_GPG_HOME)
FILENAME = '/tmp/tempdir/libreoffice-7.5.9.2/metadata.tar.zst.sig'
stream = open(FILENAME+'.sig', "rb")
verified = gpg.verify_file(stream, FILENAME)
if not verified:
    print("signature verify failed")
else:
    fpr = verified.fingerprint
    private_keys = gpg.list_keys(True)
    for pkey in private_keys:
        for skey in pkey["subkeys"]:
            if fpr in skey:
                print("signing key present")
                break
        else:
            continue
        break
stream.close()
