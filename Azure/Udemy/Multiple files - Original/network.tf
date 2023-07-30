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

  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_subnet" "tf-subnet" {
  count = var.number_of_subnets
  name                 = "tfsubnet-${count.index}"
  resource_group_name  = local.group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "tf-nwsecgrpass" {
  count = var.number_of_subnets
  subnet_id = azurerm_subnet.tf-subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.tf-nwsecgrp.id
  depends_on = [
    azurerm_subnet.tf-subnet,
    azurerm_network_security_group.tf-nwsecgrp
  ]
}

# output "network_file" {
#   value = "network file"
# }