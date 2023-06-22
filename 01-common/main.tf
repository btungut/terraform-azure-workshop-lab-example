module "global" {
  source    = "../modules/global"
  corp_name = var.corp_name
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "common" {
  location = module.global.common.location
  name     = module.global.common.rg_name
}

resource "azurerm_virtual_network" "common" {
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  name                = module.global.vnet.name
  address_space       = module.global.vnet.address_space
}

resource "azurerm_subnet" "common" {

  resource_group_name  = azurerm_virtual_network.common.resource_group_name
  virtual_network_name = azurerm_virtual_network.common.name

  for_each         = module.global.vnet.subnets
  name             = each.key                        
  address_prefixes = ["${each.value.address_prefix}"]
}
