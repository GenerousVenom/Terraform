resource "azurerm_resource_group" "tf-resourcegrp" {
  name     = local.group_name
  location = local.location
}

resource "azurerm_virtual_network" "tf-virnet" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [
    azurerm_resource_group.tf-resourcegrp
  ]
}

resource "azurerm_network_security_group" "tf-nwsecgrp" {
  name                = "tfnwsecgrp"
  location            = local.location
  resource_group_name = local.group_name
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

  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_subnet" "tf-sub" {
  name                 = "tfsub"
  resource_group_name  = local.group_name
  virtual_network_name = azurerm_virtual_network.tf-virnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

