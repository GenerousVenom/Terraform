resource "azurerm_subnet" "tf-sub-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.name_of_rsg
  virtual_network_name = var.name_of_vnet
  address_prefixes     = [local.tf-vgw.vgw_address_space]
}

resource "azurerm_local_network_gateway" "tf-lgw" {
  name                = local.tf-lgw.name_of_lgw
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  gateway_address     = local.tf-lgw.lgw_address
  address_space       = [local.tf-lgw.lgw_address_space]
  tags = var.name_of_tags
}


resource "azurerm_public_ip" "tf-pubip-vgw" {
  name                = local.tf-vgw.name_of_pubip
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  allocation_method   = "Dynamic"
  tags = var.name_of_tags
}

resource "azurerm_virtual_network_gateway" "tf-vgw" {
  name                = local.tf-vgw.name_of_vgw
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  tags = var.name_of_tags

  type     = local.tf-vgw.type
  vpn_type = local.tf-vgw.vpn_type

  active_active = false
  enable_bgp    = false
  sku           = local.tf-vgw.sku
  generation = "Generation1"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.tf-pubip-vgw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.tf-sub-vgw.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "tf-vgw-con" {
  name                = local.tf-vgw.name_of_connection
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  tags = var.name_of_tags

  type                       = local.tf-vgw.connection_type
  virtual_network_gateway_id = azurerm_virtual_network_gateway.tf-vgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.tf-lgw.id

  shared_key = local.tf-vgw.shared_key

  connection_protocol = local.tf-vgw-con.connection_protocol
  dpd_timeout_seconds = local.tf-vgw-con.dpd_timeout_seconds        # Dead peer detection timeout
  enable_bgp = local.tf-vgw-con.enable_bgp

  ipsec_policy {
    dh_group = local.tf-vgw-con.ipsec_policy.dh_group
    ike_encryption = local.tf-vgw-con.ipsec_policy.ike_encryption
    ike_integrity = local.tf-vgw-con.ipsec_policy.ike_integrity
    ipsec_encryption = local.tf-vgw-con.ipsec_policy.ipsec_encryption
    ipsec_integrity = local.tf-vgw-con.ipsec_policy.ipsec_integrity
    pfs_group = local.tf-vgw-con.ipsec_policy.pfs_group
    sa_datasize = local.tf-vgw-con.ipsec_policy.sa_datasize
    sa_lifetime = local.tf-vgw-con.ipsec_policy.sa_lifetime
  }

  depends_on = [ 
    azurerm_virtual_network_gateway.tf-vgw,
    azurerm_local_network_gateway.tf-lgw
  ]
}