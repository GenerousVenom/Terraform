data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "tf-keyvault-dmgmt" {
  name                        = "${split("rsg", var.name_of_rsg[0])[0]}keyvault${split("rsg", var.name_of_rsg[0])[1]}"
  location                    = var.name_of_location
  resource_group_name         = var.name_of_rsg[0]
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "Delete", "Purge"
    ]

    key_permissions = [
      "Get", "Delete", "Purge", "Create"
    ]
  }
}