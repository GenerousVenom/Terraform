resource "azurerm_log_analytics_workspace" "tf-loganalws-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg)[0]}loganalws${split("rsg", var.name_of_rsg)[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  sku                 = "PerGB2018"
  retention_in_days   = 30
}