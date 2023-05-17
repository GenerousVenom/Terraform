resource "azurerm_storage_account" "tf-stracc-dmgmt" {
#  name                     = "${split("rsg", var.name_of_rsg[0])[0]}stracc${split("rsg", var.name_of_rsg[0])[1]}"
  name                     = "straccdmgmt"
  resource_group_name      = var.name_of_rsg[0]
  location                 = var.name_of_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}