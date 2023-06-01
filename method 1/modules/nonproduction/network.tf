resource "azurerm_network_security_group" "tf-netsecgrp-nonprd" {
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg)[0]}netsecgrp${split("rsg", var.name_of_rsg)[1]}"
  resource_group_name = var.name_of_rsg

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

resource "azurerm_subnet" "tf-nonprdsubnet" {
  count                = length(var.name_of_subnet_nonprd)
  name                 = var.name_of_subnet_nonprd[count.index]
  resource_group_name  = var.name_of_rsg
  virtual_network_name = "${split("rsg", var.name_of_rsg)[0]}vnet${split("rsg", var.name_of_rsg)[1]}"
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