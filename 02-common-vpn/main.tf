module "global" {
  source    = "../.global"
  corp_name = var.corp_name
}

provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "common" {
  resource_group_name = module.global.common.rg_name
  name                = module.global.vnet.name
}

data "azurerm_subnet" "GatewaySubnet" {
  resource_group_name  = data.azurerm_virtual_network.common.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.common.name
  name                 = "GatewaySubnet"
}

resource "azurerm_public_ip" "vpn" {
  resource_group_name = data.azurerm_virtual_network.common.resource_group_name
  location            = data.azurerm_virtual_network.common.location
  name                = module.global.vpn.ip_name
  allocation_method   = "Dynamic"
}


resource "azurerm_virtual_network_gateway" "vpn" {
  resource_group_name = data.azurerm_virtual_network.common.resource_group_name
  location            = data.azurerm_virtual_network.common.location
  name                = module.global.vpn.name

  depends_on = [
    data.azurerm_virtual_network.common,
    data.azurerm_subnet.GatewaySubnet,
    azurerm_public_ip.vpn,
  ]

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.GatewaySubnet.id
  }

  vpn_client_configuration {
    address_space = ["${module.global.vpn.client_address_prefix}"]
    root_certificate {
      name             = "BT-WORKSHOP-ROOT"
      public_cert_data = file("../.assets/BT-WORKSHOP-ROOT.b64")
    }
  }
}
