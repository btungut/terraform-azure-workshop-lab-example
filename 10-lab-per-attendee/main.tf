module "global" {
  source    = "../modules/global"
  corp_name = var.corp_name
}

provider "azurerm" {
  features {}
}


### Fetch existing resources
data "azurerm_resource_group" "common" {
  name = module.global.common.rg_name
}

data "azurerm_virtual_network" "common" {
  resource_group_name = data.azurerm_resource_group.common.name
  name                = module.global.vnet.name
}

data "azurerm_subnet" "common" {
  resource_group_name  = data.azurerm_virtual_network.common.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.common.name

  for_each = module.global.vnet.subnets
  name     = each.key
}



### Create resource groups
resource "azurerm_resource_group" "lab_infra" {
  location = module.global.common.location
  name     = "rg-${local.resource_name_prefix}-infra"
}

resource "azurerm_resource_group" "env" {
  location = module.global.common.location

  for_each = module.global.hosting_environments
  name     = "rg-${local.resource_name_prefix}-${each.key}"
}




### Invoke azure-devops-agent
module "azure-devops-agent" {
  depends_on = [
    azurerm_resource_group.lab_infra
  ]
  count  = 1
  source = "../modules/azure-devops-agent"

  vnet_rg_name       = data.azurerm_virtual_network.common.resource_group_name
  vnet_name          = data.azurerm_virtual_network.common.name
  vnet_subnet_name   = data.azurerm_subnet.common["vms"].name
  vm_rg_name         = azurerm_resource_group.lab_infra.name
  vm_name            = "vm-azdo-agent-${local.resource_name_prefix}"
  vm_size            = "Standard_B2s"
  vm_ip_address      = "${module.global.vnet.subnets.vms.ip_prefix}.${((var.lab_number * 10) + 0)}"
  vm_username        = local.linux_username
  vm_ssh_private_key = var.ssh_private_key_path
  vm_ssh_public_key = var.ssh_public_key_path
}


### Invoke k3s
module "k3s" {
  for_each = module.global.hosting_environments

  depends_on = [
    azurerm_resource_group.lab_infra,
    azurerm_resource_group.env
  ]

  source = "../modules/k3s"

  vnet_rg_name       = data.azurerm_virtual_network.common.resource_group_name
  vnet_name          = data.azurerm_virtual_network.common.name
  vnet_subnet_name   = each.key
  vm_rg_name         = azurerm_resource_group.lab_infra.name
  vm_name            = "vm-k3s-${local.resource_name_prefix}-${each.key}"
  vm_size            = var.default_vm_size
  vm_ip_address      = "${module.global.vnet.subnets[each.key].ip_prefix}.${((var.lab_number * 10) + 1)}"
  vm_username        = local.linux_username
  vm_ssh_private_key = var.ssh_private_key_path
  vm_ssh_public_key  = var.ssh_public_key_path
}
