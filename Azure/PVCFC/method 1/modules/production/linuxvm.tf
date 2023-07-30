# resource "azurerm_public_ip" "tf-pubip-prolinux" {
#   name                = "pubip-prolinux"
#   resource_group_name = var.name_of_rsg
#   location            = var.name_of_location
#   allocation_method   = "Static"
# }

resource "azurerm_network_interface" "tf-prdnwint" {
  name                = "prdlinux-nic"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-prdsubnet[0].id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.tf-pubip-prolinux.id
  }

  depends_on = [ 
    azurerm_subnet_network_security_group_association.tf-netsecgrpass-prd,
    # azurerm_public_ip.tf-pubip-prolinux
  ]
}

resource "azurerm_linux_virtual_machine" "tf-prdlinux" {
  name                = "Prd-Linux"
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  size                = "Standard_DS1_v2"
  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-prdnwint.id,
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