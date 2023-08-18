resource "azurerm_network_interface" "tf-test-nwint" {
  name                = local.tf-winvm.name_of_int
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-test-sub.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.11.0.10"
  }

  depends_on = [ 
    azurerm_subnet.tf-test-sub
  ]
}

resource "azurerm_network_interface_security_group_association" "tf-test-nwintsecgrpass" {
  network_interface_id      = azurerm_network_interface.tf-test-nwint.id
  network_security_group_id = azurerm_network_security_group.tf-test-nsg.id
  depends_on = [ 
    azurerm_network_interface.tf-test-nwint,
    azurerm_network_security_group.tf-test-nsg
  ]
}

resource "azurerm_windows_virtual_machine" "tf-test-vmwin" {
  name                = local.tf-winvm.name_of_winvm      #Computer name can be at most 15 characters
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  size                = local.tf-winvm.size
  admin_username      = local.tf-winvm.admin_username
  admin_password      = local.tf-winvm.admin_password
  network_interface_ids = [
    azurerm_network_interface.tf-test-nwint.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.tf-winvm.publisher
    offer     = local.tf-winvm.offer
    sku       = local.tf-winvm.sku
    version   = local.tf-winvm.version
  }
  
  depends_on = [ 
    azurerm_network_interface.tf-test-nwint
  ]
}