data "azurerm_client_config" "current" {
  # *Automatically take what is the current client configuration?
}

resource "azurerm_key_vault" "tf-keyvault" {
  name                        = "tfkeyvaultbythinhphung"
  location                    = local.location
  resource_group_name         = local.group_name
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

resource "azurerm_key_vault_secret" "tf-keyvaultsec" {
  name         = "tfkeyvaultsecthinhphung1"
  value        = "123qwe!@#QWE"
  key_vault_id = azurerm_key_vault.tf-keyvault.id
  depends_on = [
    azurerm_key_vault.tf-keyvault
  ]
}

output "keyvalue_output" {
  value = "keyvalue file"
}