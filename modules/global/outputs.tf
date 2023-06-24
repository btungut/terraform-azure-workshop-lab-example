output "hosting_environments" {
  value = toset([
    "devtest",
    "preprod",
    "prod"
  ])
}

output "common" {
  value = {

    rg_name               = "rg-${local.common_resources_suffix}"
    location              = local.location_short
    location_long         = local.location
    azure_subscription_id = data.azurerm_client_config.current.subscription_id
    azure_tenant_id       = data.azurerm_client_config.current.tenant_id
    azure_object_id       = data.azurerm_client_config.current.object_id

    acr_name_prefix = "acrworkshopbt"

  }
}

output "vpn" {
  value = {
    name                  = "vpn-vnet-${local.common_resources_suffix}"
    ip_name               = "ip-vpn-vnet-${local.common_resources_suffix}"
    client_address_prefix = local.azure_vpn_gatewayclients_address_prefix
  }
}

output "vnet" {
  value = {
    name          = "vnet-${local.common_resources_suffix}"
    address_space = ["${local.ip_prefix}.0.0/16"]

    subnets = {
      vms = {
        ip_prefix      = local.subnet_vms_prefix
        address_prefix = "${local.subnet_vms_prefix}.0/24"
      }
      devtest = {
        ip_prefix      = local.subnet_devtest_prefix
        address_prefix = "${local.subnet_devtest_prefix}.0/24"
      }

      preprod = {
        ip_prefix      = local.subnet_preprod_prefix
        address_prefix = "${local.subnet_preprod_prefix}.0/24"
      }

      prod = {
        ip_prefix      = local.subnet_prod_prefix
        address_prefix = "${local.subnet_prod_prefix}.0/24"
      }
      GatewaySubnet = { # It needs to be named as 'GatewaySubnet' due to rules of Azure
        address_prefix = "${local.subnet_gateway_prefix}.0/24"
      }
    }
  }
}
