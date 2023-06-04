#!/bin/bash

set -euo pipefail

ROOT_BASE="BT-WORKSHOP-ROOT"
ROOT_CER_FILE="${ROOT_BASE}.cer"
ROOT_B64_FILE="${ROOT_BASE}.b64"
ROOT_KEY_FILE="${ROOT_BASE}.key"
echo -e "WELCOME!\nThis script and terraform manifests were developed by Burak Tungut for PoC purposes\nhttps://github.com/btungut\n\n"

[ -d ".assets" ] || { echo ".assets directory does not exist"; exit 1;}
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
    
    rm -rf .assets/${ROOT_BASE}*
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

popd
echo -e "\n\nGood bye!\nDeveloped by Burak Tungut for PoC purposes\nhttps://github.com/btungut"