resource "azurerm_log_analytics_workspace" "tf-loganalws-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}loganalws${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_storage_insights" "tf-loganalstoin-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}loganalstoin${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name = var.name_of_rsg[0]
  workspace_id        = azurerm_log_analytics_workspace.tf-loganalws-dmgmt.id

  storage_account_id  = azurerm_storage_account.tf-stracc-dmgmt.id
  storage_account_key = azurerm_storage_account.tf-stracc-dmgmt.primary_access_key
  depends_on = [ 
    azurerm_log_analytics_workspace.tf-loganalws-dmgmt,
    azurerm_storage_account.tf-stracc-dmgmt
  ]
}

