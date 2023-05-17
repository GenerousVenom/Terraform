variable "number_of_machines" {
  type = number
}

resource "azurerm_public_ip" "tf-publicip" {
  count = var.number_of_machines
  name                = "tfpublicip${count.index}"
  resource_group_name = local.group_name
  location            = local.location
  allocation_method   = "Static"
  # TODO: zones = 
  tags = {
    environment = "Production"
  }

  depends_on = [
    azurerm_resource_group.tf-resourcegrp
  ]
}

resource "azurerm_network_interface" "tf-netint" {
  count = var.number_of_machines
  name                = "tfnetint"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-publicip[count.index].id
  }

  depends_on = [
    azurerm_resource_group.tf-resourcegrp,
    azurerm_public_ip.tf-publicip
  ]
}

resource "azurerm_windows_virtual_machine" "tf-vm" {
  count = var.number_of_machines
  name                = "tfvm"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-netint[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_resource_group.tf-resourcegrp,
    azurerm_network_interface.tf-netint
  ]
}

output "tf-public-ip" {
  value = azurerm_public_ip.tf-publicip.*.ip_address
}