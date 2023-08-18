resource "azurerm_subnet" "tf-bassub" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.tf-rg.name
  virtual_network_name = azurerm_virtual_network.tf-virnet.name
  address_prefixes     = ["10.0.10.0/24"]
  depends_on = [
    azurerm_resource_group.tf-rg,
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_public_ip" "tf-baspubip" {
  name                = "tfbaspubip"
  location            = local.location
  resource_group_name = local.group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_bastion_host" "tf-bashost" {
  name                = "tfbashost"
  location            = local.location
  resource_group_name = local.group_name
  ip_configuration {
    name                 = "ipbasconf"
    subnet_id            = azurerm_subnet.tf-bassub.id
    public_ip_address_id = azurerm_public_ip.tf-baspubip.id
  }

  depends_on = [
    azurerm_resource_group.tf-rg,
    azurerm_subnet.tf-bassub,
    azurerm_public_ip.tf-baspubip
  ]
}

output "bastion_output" {
  value = "Bastion file"
}