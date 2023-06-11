resource "azurerm_storage_account" "tf-stracc" {
  name                     = "tfthinhstracc"
  resource_group_name      = var.name_of_rsg
  location                 = var.name_of_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}