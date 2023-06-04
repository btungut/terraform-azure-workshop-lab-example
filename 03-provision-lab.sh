#!/bin/bash

clear_tf_history() {
    rm -rf .terraform*
    rm -rf terraform*
}

if ! [ $# -eq 2 ]
  then
    echo -e "Please provide the unique name and uniqe index for attendee.\nE.g.: ./foo.sh contoso 5   --> This will create the 5th lab environment with rg-contoso-05-.... resources"
    exit 1;
fi
if [[ -z "$1" ]]; then
    echo "1st argument is required that indicates the unique name of environment."
    exit 1;
fi
if [[ -z "$2" ]]; then
    echo "2nd argument is required that indicates indice of workshop attendee."
    exit 1;
fi

set -euo pipefail
MSG="\n --> (Y to proceed or any to pass) ?"
echo -e "WELCOME!\nThis script and terraform manifests were developed by Burak Tungut for PoC purposes\nhttps://github.com/btungut\n\n"

CORP_NAME="$1"
IDX="$2"
echo "Provided unique name is : $CORP_NAME"
echo "Provided index is : $IDX"

if [ "$IDX" -gt "12" ]; then
    echo "Attending count could not be greater than 12"
    exit 1
fi
if [ "$IDX" -lt "1" ]; then
    echo "Attending count could not be lower than 1"
    exit 1
fi


pushd 10-lab-per-attendee
echo "Working in $PWD"
clear_tf_history

terraform init
terraform plan \
    -var corp_name="$CORP_NAME" \
    -var lab_number="$IDX"

echo -e "\nterraform init and plan is succeeded. Do you want to apply? $MSG"
read -r "ANS"
if [[ "${ANS}" == "Y" ]]; then
    terraform apply \
        -auto-approve \
        -var corp_name="$CORP_NAME" \
        -var lab_number="$IDX"

    echo -e "terraform apply is succeeded for $IDX\n"
fi

echo -e "\n\n$PWD is completed."
popd

### END

echo -e "\n\nGood bye!\nDeveloped by Burak Tungut for PoC purposes\nhttps://github.com/btungut"
