mkfifo key_pipe & sleep 1 && gpg --decrypt PK.key.gpg > key_pipe & sign-efi-sig-list -a -k key_pipe -c PK.crt KEK KEK.esl KEK.auth ; rm key_pipe
