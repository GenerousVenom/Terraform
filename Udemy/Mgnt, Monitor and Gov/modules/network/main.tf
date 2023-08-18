resource "azurerm_virtual_network" "tf-vnet" {
  name                = "tf-vnet"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  address_space       = ["10.18.0.0/16"]
}

resource "azurerm_subnet" "tf-sub" {
  name                 = "tf-sub"
  resource_group_name  = var.name_of_rsg
  virtual_network_name = azurerm_virtual_network.tf-vnet.name
  address_prefixes     = ["10.18.1.0/24"]
}