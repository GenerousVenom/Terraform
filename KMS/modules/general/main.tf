resource "azurerm_resource_group" "tf-rg" {
  count     = length(var.name_of_rsg)
  name      = var.name_of_rsg[count.index]
  location  = var.name_of_location
  tags = var.name_of_tags
}

resource "azurerm_virtual_network" "tf-vnet" {
  count               = length(var.name_of_rsg)
  location            = var.name_of_location
  name                = var.name_of_vnet[count.index]
  resource_group_name = var.name_of_rsg[count.index]
  address_space       = [var.vnet_address_space[count.index]]
  tags = var.name_of_tags

  depends_on = [ 
    azurerm_resource_group.tf-rg,
  ]
}

resource "azurerm_virtual_network_peering" "tf-peer1to2" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.tf-rg[0].name
  virtual_network_name      = azurerm_virtual_network.tf-vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[1].id
  allow_forwarded_traffic = true
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "tf-peer2to1" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.tf-rg[1].name
  virtual_network_name      = azurerm_virtual_network.tf-vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[0].id
  use_remote_gateways = true
}