# resource "azurerm_network_ddos_protection_plan" "tf-nwddosproplan-dmgmt" {
#   name                = "${split("rsg", var.name_of_rsg[0])[0]}nwddosproplan${split("rsg", var.name_of_rsg[0])[1]}"
#   location            = var.name_of_location
#   resource_group_name = var.name_of_rsg[0]
#   depends_on = [ 
#     azurerm_resource_group.tf-rg
#   ]
# }