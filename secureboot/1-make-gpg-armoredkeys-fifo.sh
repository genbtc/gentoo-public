mkfifo /tmp/key_pipe & sleep 1 && for key_type in PK KEK db dbx; do
 openssl req -new -x509 -newkey rsa:4096 -subj "/CN=ABC Secureboot ${key_type}" -keyout /tmp/key_pipe -out ${key_type}.crt -days 9999 -nodes -sha512 &
  gpg --output ${key_type}.key.gpg --recipient secureboot@avv.com --encrypt < /tmp/key_pipe ;
done ; rm /tmp/key_pipe
