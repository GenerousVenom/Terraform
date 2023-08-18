resource "azurerm_network_security_group" "tf-test-nsg" {
  location            = var.name_of_location
  name                = local.tf-sub.name_of_nsg
  resource_group_name = var.name_of_rsg
  tags = var.name_of_tags

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
    name                       = "AllowICMP"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "tf-test-sub" {
  name                 = local.tf-sub.name_of_sub
  resource_group_name  = var.name_of_rsg
  virtual_network_name = var.name_of_vnet
  address_prefixes     = [local.tf-sub.sub_address_space]
}

resource "azurerm_subnet_network_security_group_association" "tf-netsecgrpass-nonprd" {
  subnet_id                 = azurerm_subnet.tf-test-sub.id
  network_security_group_id = azurerm_network_security_group.tf-test-nsg.id
  depends_on = [ 
    azurerm_subnet.tf-test-sub,
    azurerm_network_security_group.tf-test-nsg
  ]
}