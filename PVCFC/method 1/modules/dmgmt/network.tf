resource "azurerm_network_security_group" "tf-netsecgrp-dmgmt" {
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
  security_rule {
    name                       = "AllowSMBUsers"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowICMPPing"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create subnet masks
resource "azurerm_subnet" "tf-dmgmtsub" {
  count                = length(var.name_of_subnet_dmgmt)
  name                 = var.name_of_subnet_dmgmt[count.index]
  resource_group_name  = var.name_of_rsg
  virtual_network_name = "${split("rsg", var.name_of_rsg)[0]}vnet${split("rsg", var.name_of_rsg)[1]}"
  address_prefixes     = [var.subnet_address_space_dmgmt[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "tf-netsecgrpass-dmgmt" {
  # count                     = length(var.name_of_subnet_dmgmt)
  subnet_id                 = azurerm_subnet.tf-dmgmtsub[2].id
  network_security_group_id = azurerm_network_security_group.tf-netsecgrp-dmgmt.id
  depends_on = [ 
    azurerm_subnet.tf-dmgmtsub,
    azurerm_network_security_group.tf-netsecgrp-dmgmt
  ]
}

# Create NAT Gateway
resource "azurerm_public_ip" "tf-dmgmtnatgwpubip" {
  name                = "dmgmt-natgwpubip"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  allocation_method   = "Static"
  sku                 = "Standard"
  # zones               = ["1"]
}

resource "azurerm_nat_gateway" "tf-natgw" {
  name                    = "dmgmt-natgw"
  location                = var.name_of_location
  resource_group_name     = var.name_of_rsg
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  # zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.tf-natgw.id
  public_ip_address_id = azurerm_public_ip.tf-dmgmtnatgwpubip.id
  depends_on = [ 
    azurerm_nat_gateway.tf-natgw,
    azurerm_public_ip.tf-dmgmtnatgwpubip
  ]
}

resource "azurerm_subnet_nat_gateway_association" "tf-subnatgwass" {
  subnet_id      = azurerm_subnet.tf-dmgmtsub[2].id
  nat_gateway_id = azurerm_nat_gateway.tf-natgw.id
  depends_on = [ 
    azurerm_subnet.tf-dmgmtsub,
    azurerm_nat_gateway.tf-natgw
  ]
}

# # Create Route table
# resource "azurerm_route_table" "tf-routetb" {
#   name                          = "dmgmt-routetb"
#   location                      = var.name_of_location
#   resource_group_name           = var.name_of_rsg
#   disable_bgp_route_propagation = false
# }