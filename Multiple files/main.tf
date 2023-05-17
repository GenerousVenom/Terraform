resource "azurerm_resource_group" "tf-rg" {
  name     = local.group_name
  location = local.location                     #https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#geographies
}

resource "azurerm_virtual_network" "tf-virnet" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

output "main_file" {
  value = "main file"
}