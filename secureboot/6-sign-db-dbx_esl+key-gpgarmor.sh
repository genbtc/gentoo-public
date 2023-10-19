mkfifo key_pipe & sleep 1 && for db_type in db dbx; do gpg --decrypt KEK.key.gpg > key_pipe & sign-efi-sig-list -k key_pipe -c KEK.crt $db_type ${db_type}.esl ${db_type}.auth ; done ; rm key_pipe
