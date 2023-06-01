resource "azurerm_resource_group" "tf-rg" {
  count     = length(var.name_of_rsg)
  name      = var.name_of_rsg[count.index]
  location  = var.name_of_location
}

resource "azurerm_virtual_network" "tf-vnet" {
  count               = length(var.name_of_rsg)
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg[count.index])[0]}vnet${split("rsg", var.name_of_rsg[count.index])[1]}" 
  resource_group_name = azurerm_resource_group.tf-rg[count.index].name
  address_space       = [var.vnet_address_space[count.index]]

  # ddos_protection_plan {
  #   id     = azurerm_network_ddos_protection_plan.tf-nwddosproplan-dmgmt.id
  #   enable = true
  # }
  
  depends_on = [ 
    azurerm_resource_group.tf-rg,
    # azurerm_network_ddos_protection_plan.tf-nwddosproplan-dmgmt
  ]
}