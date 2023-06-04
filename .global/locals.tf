locals {
  # NOTE: If you need to change predefined location, please provide long and short names by utilizing following two variables.
  location       = "West Europe"
  location_short = "westeurope"

  # It can be modified, if one of the your already existing network address range's is conflicting.
  ip_prefix      = "10.199"

  # Modify only if you already have a VPN with same client address range.
  azure_vpn_gatewayclients_address_prefix = "172.31.199.0/24" 



  # --- DO NOT MODIFY ---
  common_resources_suffix = "${var.corp_name}-common"
}
