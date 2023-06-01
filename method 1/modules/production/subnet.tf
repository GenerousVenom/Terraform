# resource "azurerm_subnet" "tf-prosubnet" {
#   name                 = "tf-prosubnet"
#   resource_group_name  = var.name_of_rsg
#   virtual_network_name = var.name_of_subnet_prd[0]
#   address_prefixes     = var.subnet_address_space_prd
# }