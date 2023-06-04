
resource "azurerm_network_interface" "k3s" {
  location            = azurerm_resource_group.lab_iaas.location
  resource_group_name = azurerm_resource_group.lab_iaas.name

  for_each = module.global.hosting_environments
  name     = "nic-vm-k3s-${local.resource_name_prefix}-${each.key}"

  ip_configuration {
    name                          = "main"
    subnet_id                     = data.azurerm_subnet.common[each.key].id
    private_ip_address_allocation = "Static"
    private_ip_address            = replace(data.azurerm_subnet.common[each.key].address_prefix, "0/22", local.k3s_vm_ip_last_block)
  }
}

resource "azurerm_linux_virtual_machine" "k3s" {
  location            = azurerm_resource_group.lab_iaas.location
  resource_group_name = azurerm_resource_group.lab_iaas.name
  size                = var.default_vm_size
  depends_on = [
    azurerm_resource_group.lab_iaas,
    azurerm_network_interface.k3s
  ]

  for_each       = module.global.hosting_environments
  name           = "vm-k3s-${local.resource_name_prefix}-${each.key}"
  computer_name  = "vm-k3s-${local.resource_name_prefix}-${each.key}"
  admin_username = var.default_linux_username
  network_interface_ids = [
    azurerm_network_interface.k3s[each.key].id
  ]

  admin_ssh_key {
    username   = var.default_linux_username
    public_key = file(var.default_linux_ssh_private_key_path)
  }

  os_disk {
    name                 = "disk-os-vm-k3s-${local.resource_name_prefix}-${each.key}"
    disk_size_gb         = 64
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "k3s" {
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  name                 = "k3s_install_beta"

  for_each           = module.global.hosting_environments
  virtual_machine_id = azurerm_linux_virtual_machine.k3s[each.key].id

  settings = local.k3s_vm_post_install_script
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "k3s" {
  location              = azurerm_resource_group.lab_iaas.location
  enabled               = true
  daily_recurrence_time = "1800"
  timezone              = "Turkey Standard Time"
  notification_settings {
    enabled = false
  }

  depends_on = [
    azurerm_linux_virtual_machine.k3s
  ]

  for_each           = module.global.hosting_environments
  virtual_machine_id = azurerm_linux_virtual_machine.k3s[each.key].id


}