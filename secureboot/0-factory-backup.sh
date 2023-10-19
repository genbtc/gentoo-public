for key_type in PK KEK db dbx; do efi-readvar -v $key_type -o ${key_type}.esl; done
