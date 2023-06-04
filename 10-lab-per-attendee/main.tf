module "global" {
  source    = "../.global"
  corp_name = var.corp_name
}

provider "azurerm" {
  features {}
}

data "azurerm_subnet" "common" {
  resource_group_name  = module.global.common.rg_name
  virtual_network_name = module.global.vnet.name

  for_each = module.global.vnet.subnets
  name     = each.key
}