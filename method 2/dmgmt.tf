#* Create subnet
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

  depends_on = [ 
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_subnet" "tf-sub-dmgmt" {
  count                = length(var.name_of_subnet_dmgmt)
  name                 = var.name_of_subnet_dmgmt[count.index]
  resource_group_name  = var.name_of_rsg[0]
  virtual_network_name = "${split("rsg", var.name_of_rsg[0])[0]}vnet${split("rsg", var.name_of_rsg[0])[1]}"
  address_prefixes     = [var.subnet_address_space_dmgmt[count.index]]
  depends_on = [ 
    azurerm_resource_group.tf-rg,
    azurerm_virtual_network.tf-vnet
  ]
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

#* Create bastion
resource "azurerm_public_ip" "tf-pubip-bas-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}pubip-bas${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "tf-bas-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}bas${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]

  ip_configuration {
    name                 = "${split("rsg", var.name_of_rsg[0])[0]}ipconf-bas${split("rsg", var.name_of_rsg[0])[1]}"
    subnet_id            = azurerm_subnet.tf-sub-dmgmt[1].id
    public_ip_address_id = azurerm_public_ip.tf-pubip-bas-dmgmt.id
  }
}

#* Create Gateway to connect to on-premise
resource "azurerm_local_network_gateway" "tf-localnetgw-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}localnetgw${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
  gateway_address     = var.onpre_public_ip_dmgmt
  address_space       = [var.onpre_subnet_space_dmgmt]
}

resource "azurerm_public_ip" "tf-pubgw-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}pubgw${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "tf-vnetgw-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}vnetgw${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.tf-pubgw-dmgmt.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.tf-sub-dmgmt[0].id
  }
}

resource "azurerm_virtual_network_gateway_connection" "tf-vnetgw-con" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}vnetgw-con${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.tf-vnetgw-dmgmt.id
  local_network_gateway_id   = azurerm_local_network_gateway.tf-localnetgw-dmgmt.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

#* Create storage account for this zone
resource "azurerm_storage_account" "tf-stracc-dmgmt" {
#  name                     = "${split("rsg", var.name_of_rsg[0])[0]}stracc${split("rsg", var.name_of_rsg[0])[1]}"
  name                     = "straccdmgmt"
  resource_group_name      = var.name_of_rsg[0]
  location                 = var.name_of_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#* Create log analytics
resource "azurerm_log_analytics_workspace" "tf-loganalws-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}loganalws${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_storage_insights" "tf-loganalstoin-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}loganalstoin${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name = var.name_of_rsg[0]
  workspace_id        = azurerm_log_analytics_workspace.tf-loganalws-dmgmt.id

  storage_account_id  = azurerm_storage_account.tf-stracc-dmgmt.id
  storage_account_key = azurerm_storage_account.tf-stracc-dmgmt.primary_access_key
  depends_on = [ 
    azurerm_log_analytics_workspace.tf-loganalws-dmgmt,
    azurerm_storage_account.tf-stracc-dmgmt
  ]
}