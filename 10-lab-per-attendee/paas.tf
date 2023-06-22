# ### Azure Container Registry
# resource "azurerm_container_registry" "common" {
#   #TODO: create service principal per env and authorize for GET actions
#   location            = azurerm_resource_group.lab_infra.location
#   resource_group_name = azurerm_resource_group.lab_infra.name

#   name          = "${module.global.common.acr_name_prefix}${replace(local.resource_name_prefix, "-", "")}"
#   admin_enabled = false
#   sku           = "Standard"
# }


# ### Azure KeyVaults
# resource "azurerm_key_vault" "kv" {
#   location  = module.global.common.location
#   tenant_id = module.global.common.azure_tenant_id
#   sku_name  = "standard"

#   for_each            = module.global.hosting_environments
#   resource_group_name = azurerm_resource_group.env[each.key].name
#   name                = "kv-${local.resource_name_prefix}-${each.key}"
# }