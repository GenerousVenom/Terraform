resource "azurerm_network_security_group" "tf-netsecgrp-dmgmt" {
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg[0])[0]}netsecgrp${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name = var.name_of_rsg[0]

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

resource "azurerm_subnet" "tf-sub-dmgmt" {
  count                = length(var.name_of_subnet_dmgmt)
  name                 = var.name_of_subnet_dmgmt[count.index]
  resource_group_name  = var.name_of_rsg[0]
  virtual_network_name = "${split("rsg", var.name_of_rsg[0])[0]}vnet${split("rsg", var.name_of_rsg[0])[1]}"
  address_prefixes     = [var.subnet_address_space_dmgmt[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "tf-netsecgrpass-dmgmt" {
  count                     = length(var.name_of_subnet_dmgmt)
  subnet_id                 = azurerm_subnet.tf-sub-dmgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.tf-netsecgrp-dmgmt.id
  depends_on = [ 
    azurerm_subnet.tf-sub-dmgmt,
    azurerm_network_security_group.tf-netsecgrp-dmgmt
  ]
}