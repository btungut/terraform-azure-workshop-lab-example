#!/bin/bash

[ -f "$PWD/main.tf" ] || {
    echo "Current directory does not include main.tf"
    exit 1
}
[[ -z "$corp_name" ]] && {
    echo "The variable 'corp_name' is required!"
    exit 1
}

set -euo pipefail


COMMON_RG="rg-${corp_name}-common"
echo "The resources will be imported created in '$COMMON_RG' resource group"

### RG
COMMON_RG_ID=$(az group show -n "$COMMON_RG" -o tsv --query "id")
terraform import \
    -var corp_name="$corp_name" \
    "azurerm_resource_group.common" "$COMMON_RG_ID"

### VNET
COMMON_VNET_NAME="vnet-${corp_name}-common"
COMMON_VNET_ID=$(az network vnet show -g "$COMMON_RG" -n "$COMMON_VNET_NAME" -o tsv --query "id")
terraform import \
    -var corp_name="$corp_name" \
    "azurerm_virtual_network.common" "$COMMON_VNET_ID"

### SUBNETS
SUBNETS=("common" "vms" "devtest" "preprod" "prod" "GatewaySubnet")
for SUBNET_NAME in "${SUBNETS[@]}"; do
    SUBNET_ID=$(az network vnet subnet show -g "$COMMON_RG" --vnet-name "$COMMON_VNET_NAME" -n "$SUBNET_NAME" -o tsv --query "id")
    terraform import \
        -var corp_name="$corp_name" \
        "azurerm_subnet.common_subnets" "$SUBNET_ID"
done
