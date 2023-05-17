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