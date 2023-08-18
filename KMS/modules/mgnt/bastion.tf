resource "azurerm_subnet" "tf-sub-bas" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.name_of_rsg
  virtual_network_name = var.name_of_vnet
  address_prefixes     = [local.tf-bas.bas_address_space]
}

resource "azurerm_public_ip" "tf-pubip-bas" {
  name                = local.tf-bas.name_of_pubip
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  tags = var.name_of_tags
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "tf-bas-host" {
  name                = local.tf-bas.name_of_bas
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  tags = var.name_of_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.tf-sub-bas.id
    public_ip_address_id = azurerm_public_ip.tf-pubip-bas.id
  }
}