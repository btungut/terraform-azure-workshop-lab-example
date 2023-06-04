#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Please provide a unique name for this workshop enviroment as an argument. E.g. : ./foo.sh contoso"
    exit 1;
fi
if [[ -z "$1" ]]; then
    echo "Please provide a unique name for this workshop enviroment as an argument. E.g. : ./foo.sh contoso"
    exit 1;
fi

set -euo pipefail
MSG="\n --> (Y to proceed or any to pass) ?"
echo -e "WELCOME!\nThis script and terraform manifests were developed by Burak Tungut for PoC purposes\nhttps://github.com/btungut\n\n"

CORP_NAME="$1"
echo "Provided unique name is : $CORP_NAME"


### BEGIN : 01-common
echo -e "\n -----> Execute 01-common : common rg and vnet? $MSG"
read -r "ANS"
if [[ "${ANS}" == "Y" ]]; then
    pushd 01-common
    echo "Working in $PWD"

    terraform init && terraform plan \
        -var corp_name="$CORP_NAME"

    echo -e "\n\nterraform init and plan is succeeded. Do you want to apply? $MSG"
    read -r "ANS"
    if [[ "${ANS}" == "Y" ]]; then
        terraform apply \
        -auto-approve \
        -var corp_name="$CORP_NAME"

        echo "terraform apply is succeeded"
    fi

    echo -e "\n\n$PWD is completed."
    popd
fi
### END


### BEGIN : 02-common-vpn
echo -e "\n -----> Execute 02-common-vpn : Provision the VPN for point to site connections? $MSG"
read -r "ANS"
if [[ "${ANS}" == "Y" ]]; then
    pushd 02-common-vpn
    echo "Working in $PWD"

    terraform init && terraform plan \
        -var corp_name="$CORP_NAME"
    
    echo -e "\n\nterraform init and plan is succeeded. Do you want to apply? $MSG"
    read -r "ANS"
    if [[ "${ANS}" == "Y" ]]; then
        terraform apply \
        -auto-approve \
        -var corp_name="$CORP_NAME"

        echo "terraform apply is succeeded"
    fi

    echo -e "\n\n$PWD is completed."
    popd
fi

### END

echo -e "\n\nGood bye!\nDeveloped by Burak Tungut for PoC purposes\nhttps://github.com/btungut"
