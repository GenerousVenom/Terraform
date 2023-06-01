#* Peering from 1
resource "azurerm_virtual_network_peering" "tf-vnet-peer1to2-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer1to2${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[0]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[1].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer1to3-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer1to3${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[0]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[2].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}

#* Peering from 2
resource "azurerm_virtual_network_peering" "tf-vnet-peer2to1-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer2to1${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[1]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[0].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer2to3-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer2to3${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[1]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[2].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}

#* Peering from 3
resource "azurerm_virtual_network_peering" "tf-vnet-peer3to1-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer3to1${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[2]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[0].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer3to2-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer3to2${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[2]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[1].id
  depends_on = [ 
    azurerm_virtual_network.tf-vnet
  ]
}