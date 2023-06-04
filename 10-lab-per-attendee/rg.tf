resource "azurerm_resource_group" "lab_iaas" {
  location = module.global.common.location
  name     = "rg-${local.resource_name_prefix}-infra"
}

resource "azurerm_resource_group" "lab_paas" {
  location = module.global.common.location

  for_each = module.global.hosting_environments
  name     = "rg-${local.resource_name_prefix}-${each.key}"
}
