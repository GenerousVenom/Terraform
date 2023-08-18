resource "azurerm_storage_account" "tf-test-stacc" {
  name                     = local.tf-blb.name_of_storage
  resource_group_name      = var.name_of_rsg
  location                 = var.name_of_location
  tags = var.name_of_tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf-test-blb" {
  name                  = local.tf-blb.name_of_blob
  storage_account_name  = azurerm_storage_account.tf-test-stacc.name
  container_access_type = "blob"
}

# resource "azurerm_storage_blob" "example" {
#   name                   = "my-awesome-content.zip"
#   storage_account_name   = azurerm_storage_account.tf-test-stacc.name
#   storage_container_name = azurerm_storage_container.tf-test-blb.name
#   type                   = "Block"
#   depends_on = [ 
#     azurerm_storage_account.tf-test-stacc,
#     azurerm_storage_container.tf-test-blb
#   ]
# }