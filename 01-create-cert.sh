#!/bin/bash

set -euo pipefail

ROOT_BASE="BT-WORKSHOP-ROOT"
ROOT_CER_FILE="${ROOT_BASE}.cer"
ROOT_B64_FILE="${ROOT_BASE}.b64"
ROOT_KEY_FILE="${ROOT_BASE}.key"

CLIENT_BASE="BT-WORKSHOP-CLIENT"
CLIENT_CSR_FILE="${CLIENT_BASE}.csr"
CLIENT_CER_FILE="${CLIENT_BASE}.cer"
CLIENT_KEY_FILE="${CLIENT_BASE}.key"

echo -e "WELCOME!\nThis script and terraform manifests were developed by Burak Tungut for PoC purposes\nhttps://github.com/btungut\n\n"

[ -d ".assets" ] || { mkdir -p ".assets"; }
EXIST="0"
[ -f ".assets/${ROOT_CER_FILE}" ] && { EXIST="1"; }
[ -f ".assets/${ROOT_B64_FILE}" ] && { EXIST="1"; }
[ -f ".assets/${ROOT_KEY_FILE}" ] && { EXIST="1"; }
if [[ "${EXIST}" == "1" ]]; then
    echo "Certificate, b64 form and/or private key has been already created before."
    echo "Do you want to clear the contents of .assets directory ?"
    echo "NOTE THAT: If the existing certificate is being used by a Azure VPN, you should store it!"
    echo " --> ENTER to continue, CTRL + C to BREAK"
    read -r ANS
    
    rm -rf .assets/*
    echo ".assets directory is cleared!"
fi

pushd .assets
openssl req -x509 -nodes -sha256 -days 3650 -newkey rsa:2048 \
    -keyout ${ROOT_KEY_FILE} \
    -out ${ROOT_CER_FILE} \
    -subj "/C=TR/ST=${ROOT_BASE}/L=${ROOT_BASE}/O=${ROOT_BASE}/OU=${ROOT_BASE}/CN=${ROOT_BASE}"
echo "${ROOT_KEY_FILE} is created"
echo "${ROOT_CER_FILE} is created"

sed '1d;$d' BT-WORKSHOP-ROOT.cer > ./$ROOT_B64_FILE
echo "${ROOT_B64_FILE} is created"




openssl req -new -nodes \
    -subj "/C=TR/ST=${CLIENT_BASE}/L=${CLIENT_BASE}/O=${CLIENT_BASE}/OU=${CLIENT_BASE}/CN=${CLIENT_BASE}" \
    -newkey rsa:2048 \
    -keyout $CLIENT_KEY_FILE \
    -out $CLIENT_CSR_FILE


openssl x509 -req -days 365 \
    -CA ${ROOT_CER_FILE} \
    -CAkey ${ROOT_KEY_FILE} \
    -CAcreateserial \
    -in $CLIENT_CSR_FILE \
    -out $CLIENT_CER_FILE

rm -f $CLIENT_CSR_FILE

openssl pkcs12 -export \
    -certfile $ROOT_CER_FILE \
    -inkey $CLIENT_KEY_FILE \
    -in $CLIENT_CER_FILE \
    -passout pass:"" \
    -out install.pfx

popd
echo -e "\n\nGood bye!\nDeveloped by Burak Tungut for PoC purposes\nhttps://github.com/btungut"