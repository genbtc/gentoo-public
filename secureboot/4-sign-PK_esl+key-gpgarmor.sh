#!/bin/bash
#This works but not in a bash prompt
mkfifo key_pipe & sleep 1 && gpg --decrypt PK.key.gpg > key_pipe & sign-efi-sig-list -k key_pipe -c PK.crt PK PK.esl PK.auth ; rm key_pipe
