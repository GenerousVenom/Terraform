resource "azurerm_network_interface" "tf-dmgmtnwint" {
  name                = "dmgmtwin-nic"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-dmgmtsub[2].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ 
    azurerm_subnet.tf-dmgmtsub
  ]
}

resource "azurerm_windows_virtual_machine" "tf-dmgmtwinvm" {
  name                = "dmgmtwin-vm"
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-dmgmtnwint.id,
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
    azurerm_network_interface.tf-dmgmtnwint
  ]
}