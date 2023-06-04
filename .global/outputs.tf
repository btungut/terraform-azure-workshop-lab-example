output "hosting_environments" {
  value = {
    devtest = {
      subnet_name = "devtest"
      kv_name = "test"
      k8s_vm_ip_prefix = "${local.ip_prefix}.4"
    }

    preprod = {
      subnet_name = "preprod"
      kv_name = "preprod"
      k8s_vm_ip_prefix = "${local.ip_prefix}.8"
    }

    prod = {
      subnet_name = "prod"
      kv_name = "prod"
      k8s_vm_ip_prefix = "${local.ip_prefix}.12"
    }
  }
}

output "common" {
  value = {

    rg_name            = "rg-${local.common_resources_suffix}"
    location        = local.location_short
    location_long   = local.location
    azure_tenant_id = data.azurerm_client_config.current.tenant_id
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

      common = {
        address_prefix = "${local.ip_prefix}.0.0/22"
      }

      devtest = {
        address_prefix = "${local.ip_prefix}.4.0/22"
      }

      preprod = {
        address_prefix = "${local.ip_prefix}.8.0/22"
      }

      prod = {
        address_prefix = "${local.ip_prefix}.12.0/22"
      }

      GatewaySubnet = { # It needs to be named as 'GatewaySubnet' due to rules of Azure
        address_prefix = "${local.ip_prefix}.254.0/24"
      }
    }
  }
}
