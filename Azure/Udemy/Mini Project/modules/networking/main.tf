# module "general_module" {
#   source = ".././general"
#   resource_group_name = var.resource_group_name
#   location = var.location
# }

resource "azurerm_virtual_network" "tf-virnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.virtual_network_address_space]
}

resource "azurerm_subnet" "tf-sub" {
  for_each = var.subnet_names
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [cidrsubnet(var.virtual_network_address_space,8,index(tolist(var.subnet_names), each.key))]      #* https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

#* Creating a bastion subnet
resource "azurerm_subnet" "tf-bassub" {
  count = var.bastion_required ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.10.0/24"]
  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_public_ip" "tf-baspubip" {
  count = var.bastion_required ? 1 : 0
  name                = "tfbaspubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "tf-bashost" {
  count = var.bastion_required ? 1 : 0
  name                = "tfbashost"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "tfbasipconfiguration"
    subnet_id            = azurerm_subnet.tf-bassub[0].id
    public_ip_address_id = azurerm_public_ip.tf-baspubip[0].id
  }

  depends_on = [
    azurerm_subnet.tf-bassub,
    azurerm_public_ip.tf-baspubip
  ]
}

resource "azurerm_network_security_group" "tf-nwsecgrp" {
  for_each = var.network_security_group_name
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "tf-nwsecgrpass" {
  for_each = var.network_security_group_name
  subnet_id = azurerm_subnet.tf-sub[each.value].id
  network_security_group_id = azurerm_network_security_group.tf-nwsecgrp[each.key].id

  depends_on = [
    azurerm_subnet.tf-sub,
    azurerm_network_security_group.tf-nwsecgrp
  ]
}

resource "azurerm_network_security_rule" "tf-netsecrule" {
  for_each = {for rule in var.network_security_group_rules : rule.id=>rule}     #* To define rule.id is a key of this block
  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = "Inbound"
  access                     = each.value.access
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tf-nwsecgrp[each.value.network_security_group_name].name
  
  depends_on = [
    azurerm_network_security_group.tf-nwsecgrp
  ]
}