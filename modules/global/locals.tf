locals {
  # NOTE: If you need to change predefined location, please provide long and short names by utilizing following two variables.
  location       = "West Europe"
  location_short = "westeurope"

  # It can be modified, if one of the your already existing network address range's is conflicting.
  ip_prefix = "10.199"

  # Modify only if you already have a VPN with same client address range.
  azure_vpn_gatewayclients_address_prefix = "172.31.199.0/24"



  # --- DO NOT MODIFY ---
  common_resources_suffix = "${var.corp_name}-common"

  subnet_vms_prefix     = "${local.ip_prefix}.0"
  subnet_devtest_prefix = "${local.ip_prefix}.1"
  subnet_preprod_prefix = "${local.ip_prefix}.2"
  subnet_prod_prefix    = "${local.ip_prefix}.3"
  subnet_gateway_prefix = "${local.ip_prefix}.254"
}
