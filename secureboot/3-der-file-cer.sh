for key_type in PK KEK db dbx; do openssl x509 -outform DER -in ${key_type}.crt -out ${key_type}.cer ; done
