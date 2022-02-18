#!/usr/bin/env bash

_GPG_KEY_NAME="apt-service"

## Clean residual files
rm -rf $_GPG_KEY_NAME.txt $_GPG_KEY_NAME*.gpg

## Create a temporary GPG home
export GNUPGHOME="$(mktemp -d)"

## Create GPG key metadata file
cat <<EOF >${_GPG_KEY_NAME}.txt
%echo Generating a basic OpenPGP key
Key-Type: default
Key-Length: 4096
Subkey-Type: default
Name-Real: APT Service
Name-Comment: APT Service GPG key
Name-Email: apt@service.gpg.local
Expire-Date: 0
Passphrase: 1234
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

## Generate GPG keys
gpg --batch --generate-key ${_GPG_KEY_NAME}.txt

_GPG_KEY_ID="$(gpg --list-keys | grep -E '^\s+[A-F0-9a-f]+' | xargs)"

echo "Finish generate key: $_GPG_KEY_ID"

## Export keys
gpg --armor --output "${_GPG_KEY_NAME}_public.gpg" --export $_GPG_KEY_ID
gpg --armor --output "${_GPG_KEY_NAME}_private.gpg" --export-secret-key $_GPG_KEY_ID

## Destroy the temporary GPG home
rm -rf "$GNUPGHOME"

echo "Finish export key: ${_GPG_KEY_NAME}_public.gpg ${_GPG_KEY_NAME}_private.gpg "

## Import keys
echo -e "\nYou can import keys with the following commands:\n"
echo "gpg --import ${_GPG_KEY_NAME}_public.gpg"
echo "gpg --allow-secret-key-import --import ${_GPG_KEY_NAME}_private.gpg"
