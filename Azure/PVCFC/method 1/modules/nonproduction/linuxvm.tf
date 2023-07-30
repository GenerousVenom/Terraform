resource "azurerm_network_interface" "tf-nonprdnwint" {
  name                = "nonprdlinux-nic"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-nonprdsubnet[0].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ 
    azurerm_subnet_network_security_group_association.tf-netsecgrpass-nonprd
  ]
}

resource "azurerm_linux_virtual_machine" "tf-nonprdlinux" {
  name                = "Nonprd-Linux"
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  size                = "Standard_DS1_v2"
  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-nonprdnwint.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}