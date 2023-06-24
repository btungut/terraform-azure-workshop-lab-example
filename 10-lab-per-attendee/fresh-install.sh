#!/bin/bash

## export CORP_NAME="phonestore" && export SSH_PRIVATE_KEY="~/.ssh/id_rsa" && export SSH_PUBLIC_KEY="~/.ssh/id_rsa.pub" && export LAB_NUMBER="1"

[[ -z "${CORP_NAME}" ]] && { echo "The variable CORP_NAME is required"; exit 1; }
[[ -z "${SSH_PUBLIC_KEY}" ]] && { echo "The variable 'SSH_PUBLIC_KEY' is required"; exit 1; }
[[ -z "${SSH_PRIVATE_KEY}" ]] && { echo "The variable 'SSH_PRIVATE_KEY' is required"; exit 1; }
[[ -z "${LAB_NUMBER}" ]] && { echo "The variable 'LAB_NUMBER' is required"; exit 1; }


set -euo pipefail

# rm -rf .terraform* && rm -rf terraform*

terraform init

terraform plan \
    -var corp_name="$CORP_NAME" \
    -var ssh_public_key_path="$SSH_PUBLIC_KEY" \
    -var ssh_private_key_path="$SSH_PRIVATE_KEY" \
    -var lab_number="$LAB_NUMBER"

echo -e "\nDo you want to 'terraform apply' ?\nENTER to continue, CTRL + C to BREAK"
read -r ANS

terraform apply \
    -var corp_name="$CORP_NAME" \
    -var ssh_public_key_path="$SSH_PUBLIC_KEY" \
    -var ssh_private_key_path="$SSH_PRIVATE_KEY" \
    -var lab_number="$LAB_NUMBER"