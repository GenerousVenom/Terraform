#* Create network security group
resource "azurerm_network_security_group" "tf-netsecgrp-nonprd" {
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg[2])[0]}netsecgrp${split("rsg", var.name_of_rsg[2])[1]}"
  resource_group_name = var.name_of_rsg[2]

  security_rule {
    name                       = "AllowRDP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#* Create Subnet
resource "azurerm_subnet" "tf-nonprdsubnet" {
  count                = length(var.name_of_subnet_nonprd)
  name                 = var.name_of_subnet_nonprd[count.index]
  resource_group_name  = var.name_of_rsg[2]
  virtual_network_name = "${split("rsg", var.name_of_rsg[2])[0]}vnet${split("rsg", var.name_of_rsg[2])[1]}"
  address_prefixes     = [var.subnet_address_space_nonprd[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "tf-netsecgrpass-nonprd" {
  count                = length(var.name_of_subnet_nonprd)
  subnet_id                 = azurerm_subnet.tf-nonprdsubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.tf-netsecgrp-nonprd.id
  depends_on = [ 
    azurerm_subnet.tf-nonprdsubnet,
    azurerm_network_security_group.tf-netsecgrp-nonprd
  ]
}

#* Create Linux VM
resource "azurerm_network_interface" "tf-nonprdnwint" {
  name                = "nonprdlinux-nic"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[2]

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
  resource_group_name = var.name_of_rsg[2]
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
