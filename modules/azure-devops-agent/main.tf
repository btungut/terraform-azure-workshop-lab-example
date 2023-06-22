data "azurerm_resource_group" "common" {
  name = var.vnet_rg_name
}

data "azurerm_subnet" "common" {
  resource_group_name  = data.azurerm_resource_group.common.name
  virtual_network_name = var.vnet_name
  name                 = var.vnet_subnet_name
}

data "azurerm_resource_group" "infra" {
  name = var.vm_rg_name
}

resource "azurerm_network_interface" "agent" {
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name

  name = "nic-${var.vm_name}"

  ip_configuration {
    name                          = "main"
    subnet_id                     = data.azurerm_subnet.common.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "agent" {
  location            = azurerm_network_interface.agent.location
  resource_group_name = azurerm_network_interface.agent.resource_group_name
  size                = var.vm_size
  depends_on = [
    data.azurerm_resource_group.common,
    data.azurerm_subnet.common,
    azurerm_network_interface.agent
  ]

  name           = var.vm_name
  computer_name  = var.vm_name
  admin_username = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.agent.id
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = file(var.vm_ssh_public_key)
  }

  os_disk {
    name                 = "disk-os-${var.vm_name}"
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "agent" {
  location              = azurerm_linux_virtual_machine.agent.location
  enabled               = true
  daily_recurrence_time = "1800"
  timezone              = "Turkey Standard Time"
  notification_settings {
    enabled = false
  }

  depends_on = [
    azurerm_linux_virtual_machine.agent
  ]

  virtual_machine_id = azurerm_linux_virtual_machine.agent.id
}