data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "tf-dmgmt-keyvault" {
  name                        = "terraform-thinh-keyvault"
  location                    = var.name_of_location
  resource_group_name         = var.name_of_rsg
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

resource "azurerm_key_vault_secret" "tf-dmgmt-keyvaultsec" {
  name         = var.name_of_keyvault
  value        = "123qwe!@#QWE"
  key_vault_id = azurerm_key_vault.tf-dmgmt-keyvault.id
  depends_on = [
    azurerm_key_vault.tf-dmgmt-keyvault
  ]
}