for key_type in PK KEK db dbx; do cert-to-efi-sig-list -g $( < uuid.txt) ${key_type}.crt ${key_type}.esl; done
