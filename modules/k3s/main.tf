# the rg which contains vnet
data "azurerm_resource_group" "common" {
  name = var.vnet_rg_name
}

# the rg which we create vm into it
data "azurerm_resource_group" "k3s" {
  name = var.vm_rg_name
}

data "azurerm_subnet" "k3s" {
  resource_group_name  = data.azurerm_resource_group.common.name
  virtual_network_name = var.vnet_name
  name                 = var.vnet_subnet_name
}


resource "azurerm_network_interface" "k3s" {
  location            = data.azurerm_resource_group.k3s.location
  resource_group_name = data.azurerm_resource_group.k3s.name

  name = "nic-${var.vm_name}"

  ip_configuration {
    name                          = "main"
    subnet_id                     = data.azurerm_subnet.k3s.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_ip_address
  }
}


resource "azurerm_linux_virtual_machine" "k3s" {
  location            = data.azurerm_resource_group.k3s.location
  resource_group_name = data.azurerm_resource_group.k3s.name
  size                = var.vm_size
  depends_on = [
    azurerm_network_interface.k3s,
    data.azurerm_subnet.k3s,
    azurerm_network_interface.k3s
  ]

  name           = var.vm_name
  computer_name  = var.vm_name
  admin_username = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.k3s.id
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "k3s" {
  location              = azurerm_linux_virtual_machine.k3s.location
  enabled               = true
  daily_recurrence_time = "1800"
  timezone              = "Turkey Standard Time"
  notification_settings {
    enabled = false
  }

  depends_on = [
    azurerm_linux_virtual_machine.k3s
  ]

  virtual_machine_id = azurerm_linux_virtual_machine.k3s.id
}
